#include "viewportslayoutmodel.h"

#include <QUuid>
#include <algorithm>

ViewportsLayoutItem::ViewportsLayoutItem(QObject *parent)
    : QObject(parent)
{
    QMetaMethod changedMethod = QMetaMethod::fromSignal(&ViewportsLayoutItem::changed);
    for (int i = staticMetaObject.methodOffset(); i < staticMetaObject.methodCount(); ++i) {
        QMetaMethod method = staticMetaObject.method(i);
        if (method.methodType() == QMetaMethod::Signal && method != changedMethod) {
            connect(this, method, this, changedMethod);
        }
    }
}

ViewportsLayoutModel::ViewportsLayoutModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_columns(0)
    , m_rows(0)
{
    m_uid = QUuid::createUuid().toString(QUuid::WithoutBraces);
    const QMetaObject* meta = &ViewportsLayoutItem::staticMetaObject;
    for (int i = meta->propertyOffset(); i < meta->propertyCount(); ++i) {
        QMetaProperty property = meta->property(i);
        m_roleNames[Qt::UserRole + i] = property.name();
    }

    connect(this, &ViewportsLayoutModel::dataChanged, this, &ViewportsLayoutModel::changed);

    QMetaMethod changedMethod = QMetaMethod::fromSignal(&ViewportsLayoutModel::changed);
    for (int i = staticMetaObject.methodOffset(); i < staticMetaObject.methodCount(); ++i) {
        QMetaMethod method = staticMetaObject.method(i);
        if (method.methodType() == QMetaMethod::Signal && method != changedMethod) {
            connect(this, method, this, changedMethod);
        }
    }
}

int ViewportsLayoutModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_columns * m_rows;
}

QVariant ViewportsLayoutModel::data(const QModelIndex &index, int role) const
{
    if (!hasIndex(index.row(), index.column())) {
        return {};
    }

    ViewportsLayoutItem *item = get(index.row());
    if (!item) {
        return {};
    }

    return item->property(m_roleNames.value(role));
}

bool ViewportsLayoutModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!hasIndex(index.row(), index.column())) {
        return false;
    }

    ViewportsLayoutItem *item = get(index.row());
    if (!item) {
        return false;
    }

    return item->setProperty(m_roleNames.value(role), value);
}

ViewportsLayoutItem *ViewportsLayoutModel::set(int index, ViewportsLayoutItem *p)
{
    if (p == get(index)) {
        return p;
    }

    if (index >= 0 && index < m_items.size()) {
        m_items[index] = p;

        QModelIndex modelIndex = QAbstractListModel::index(index, 0);
        emit dataChanged(modelIndex, modelIndex);
    }

    return p;
}

void ViewportsLayoutModel::clear() {
    beginResetModel();
    m_items.clear();
    endResetModel();
}

void ViewportsLayoutModel::ensureItemsAllocated()
{
    for (int index = 0; index < m_items.size(); ++index) {
        if (m_items.at(index) == nullptr) {
            QQmlEngine *engine = qmlEngine(this);
            Q_ASSERT(engine != nullptr);

            auto *item = new ViewportsLayoutItem(this);
            QQmlEngine::setContextForObject(item, engine->rootContext());
            connect(item, &ViewportsLayoutItem::changed, this, [=] {
                for (int i = 0; i < m_items.size(); ++i) {
                    if (item == m_items.at(i)) {
                        QModelIndex modelIndex = createIndex(i, 0);
                        emit reinterpret_cast<ViewportsLayoutModel *>(this)->dataChanged(modelIndex, modelIndex);
                    }
                }
            });
            set(index, item);
        }
    }
}

void ViewportsLayoutModel::resize(int columns, int rows)
{
    if (rows < 0 || columns < 0) {
        return;
    }

    int newActiveCount = rows * columns;
    int oldActiveCount = m_columns * m_rows;

    // Grow and allocate all ViewportsLayoutItem objects BEFORE beginInsertRows/endInsertRows
    // so QML delegates never observe null items during model notifications.
    int maxNeeded = std::max(newActiveCount, m_items.size());
    if (maxNeeded > m_items.size()) {
        m_items.resize(maxNeeded);
    }
    ensureItemsAllocated();

    if (newActiveCount > oldActiveCount) {
        beginInsertRows(QModelIndex(), oldActiveCount, newActiveCount - 1);
        m_columns = columns;
        m_rows = rows;
        endInsertRows();
    } else if (newActiveCount < oldActiveCount) {
        beginRemoveRows(QModelIndex(), newActiveCount, oldActiveCount - 1);
        m_columns = columns;
        m_rows = rows;
        endRemoveRows();
    } else {
        m_columns = columns;
        m_rows = rows;
    }

    normalize();
}

void ViewportsLayoutModel::normalize()
{
    int count = m_columns * m_rows;

    // Resize (never shrink, only grow if m_items is smaller than active count)
    if (m_items.size() < count) {
        m_items.resize(count);
        emit sizeChanged(QSize(m_columns, m_rows));
    }

    // Ensure all allocated items (including surplus items beyond current grid size) are initialized
    ensureItemsAllocated();

    if (m_columns <= 0 || m_rows <= 0 || count <= 0) {
        return;
    }

    // Compute active spans/visibility for 0 .. count - 1 from savedColumnSpan/savedRowSpan,
    // without overwriting saved spans or mutating surplus items at index >= count.
    QVector<int> baseColSpan(count, 1);
    QVector<int> baseRowSpan(count, 1);

    for (int index = 0; index < count; ++index) {
        auto item = get(index);
        int savedColSpan = std::max(1, item->savedColumnSpan());
        int savedRowSpan = std::max(1, item->savedRowSpan());
        int clampedCol = clamp(savedColSpan, 1, m_columns - column(index));
        int clampedRow = clamp(savedRowSpan, 1, m_rows - row(index));

        int span = 1;
        if (clampedCol != m_columns || clampedRow != m_rows) {
            span = std::min(clampedRow, clampedCol);
        }

        baseColSpan[index] = span;
        baseRowSpan[index] = span;
        item->setVolume(clamp(item->volume().toDouble(), 0.0, 1.0));
    }

    QVector<int> effColSpan(count, 1);
    QVector<int> effRowSpan(count, 1);
    QVector<ViewportsLayoutItem::Visible> effVisible(count, ViewportsLayoutItem::Visible::Visible);

    bool collision = true;
    while (collision) {
        collision = false;
        effColSpan = baseColSpan;
        effRowSpan = baseRowSpan;
        std::fill(effVisible.begin(), effVisible.end(), ViewportsLayoutItem::Visible::Visible);

        for (int index = 0; index < count; ++index) {
            if (effVisible[index] == ViewportsLayoutItem::Visible::Visible) {
                int cSpan = effColSpan[index];
                int rSpan = effRowSpan[index];

                // Mark covered cells as Hidden
                for (int r = 0; r < rSpan && !collision; ++r) {
                    for (int c = 0; c < cSpan && !collision; ++c) {
                        int hiddenIndex = dataIndex(column(index) + c, row(index) + r);
                        if (hiddenIndex != index && hiddenIndex >= 0 && hiddenIndex < count) {
                            if (effVisible[hiddenIndex] == ViewportsLayoutItem::Visible::Visible) {
                                effColSpan[hiddenIndex] = -c;
                                effRowSpan[hiddenIndex] = -r;
                                effVisible[hiddenIndex] = ViewportsLayoutItem::Visible::Hidden;
                            } else {
                                // Span collision in smaller grid: temporarily fall back to 1x1
                                baseColSpan[index] = 1;
                                baseRowSpan[index] = 1;
                                collision = true;
                            }
                        }
                    }
                }
            }
            if (collision) {
                break;
            }
        }
    }

    for (int index = 0; index < count; ++index) {
        auto item = get(index);
        item->setColumnSpan(effColSpan[index]);
        item->setRowSpan(effRowSpan[index]);
        item->setVisible(effVisible[index]);
    }

    emit dataChanged(createIndex(0, 0), createIndex(count - 1, 0));
}

void ViewportsLayoutModel::fromJSValue(const QVariantMap &model)
{
    QVariant val;

    if (model.contains("uid")) {
        const QString parsedUid = model.value("uid").toString().trimmed();
        if (!parsedUid.isEmpty()) {
            setUid(parsedUid);
        }
    } else if (m_uid.isEmpty()) {
        setUid(QUuid::createUuid().toString(QUuid::WithoutBraces));
    }
    if (model.contains("isNvr")) {
        setIsNvr(model.value("isNvr").toBool());
    }
    if (model.contains("nvrIp")) {
        setNvrIp(model.value("nvrIp").toString());
    }
    if (model.contains("isNvrPreset")) {
        setIsNvrPreset(model.value("isNvrPreset").toBool());
    }
    if (model.contains("name")) {
        setName(model.value("name").toString());
    }
    QStringList parsedGroups;
    if (model.contains("groups")) {
        const QStringList rawGroups = model.value("groups").toStringList();
        for (const QString &g : rawGroups) {
            const QString trimmed = g.trimmed();
            if (!trimmed.isEmpty() && !parsedGroups.contains(trimmed)) {
                parsedGroups.append(trimmed);
            }
        }
        setGroups(parsedGroups);
    } else if (model.contains("group")) {
        const QString legacyGroup = model.value("group").toString().trimmed();
        if (!legacyGroup.isEmpty()) {
            parsedGroups.append(legacyGroup);
        }
        setGroups(parsedGroups);
    }
    if (model.contains("showUngrouped")) {
        setShowUngrouped(model.value("showUngrouped").toBool());
    } else if (!parsedGroups.isEmpty() && model.contains("group") && !model.contains("groups")) {
        setShowUngrouped(false);
    }
    if (model.contains("visible")) {
        setVisible(model.value("visible").toBool());
    }
    if (model.contains("badgeColor")) {
        setBadgeColor(model.value("badgeColor").toString().trimmed());
    } else {
        setBadgeColor(QString());
    }

    if (model.contains("size")) {
        val = model.value("size");
        if (val.canConvert(QMetaType::QVariantMap)) {
            int width = val.toMap().value("width").toInt();
            int height = val.toMap().value("height").toInt();
            setSize(QSize(width, height));
        }
    }

    if (model.contains("aspectRatio")) {
        val = model.value("aspectRatio");
        if (val.canConvert(QMetaType::QVariantMap)) {
            int width = val.toMap().value("width").toInt();
            int height = val.toMap().value("height").toInt();
            setAspectRatio(QSize(width, height));
        }
    }

    if (model.contains("items")) {
        val = model.value("items");
    }
    if (val.canConvert(QMetaType::QVariantList)) {
        QVariantList items = val.toList();
        if (items.size() > m_items.size()) {
            m_items.resize(items.size());
        }
        normalize();
        for (int i = 0; i < std::min(m_items.size(), items.size()); ++i) {
            QVariantMap item = items.at(i).toMap();
            QHashIterator<int, QByteArray> role(m_roleNames);
            while (role.hasNext()) {
                role.next();

                QByteArray roleName = role.value();
                const char *name = roleName.constData();
                QString key = QString::fromUtf8(roleName);
                if (item.contains(key)) {
                    m_items.at(i)->setProperty(name, item.value(key));
                }
            }
            if (!item.contains(QStringLiteral("savedColumnSpan"))) {
                m_items.at(i)->setSavedColumnSpan(std::max(1, item.value(QStringLiteral("columnSpan")).toInt()));
            }
            if (!item.contains(QStringLiteral("savedRowSpan"))) {
                m_items.at(i)->setSavedRowSpan(std::max(1, item.value(QStringLiteral("rowSpan")).toInt()));
            }
        }
    }

    normalize();
}

QVariantMap ViewportsLayoutModel::toJSValue() const
{
    QVariantMap model;
    QVariantList items;

    for (int i = 0; i < m_items.size(); ++i) {
        QVariantMap item;
        if (get(i) != nullptr) {
            const QMetaObject* metaObject = get(i)->metaObject();
            for(int j = metaObject->propertyOffset(); j < metaObject->propertyCount(); ++j) {
                const char *name = metaObject->property(j).name();
                int hashKey = m_roleNames.key(name);
                if (hashKey) {
                    item[name] = get(i)->property(name);
                }
            }
            items.append(item);
        }
    }

    model["size"] = size();
    model["aspectRatio"] = m_aspectRatio;
    model["uid"] = uid();
    model["isNvr"] = isNvr();
    model["nvrIp"] = nvrIp();
    model["isNvrPreset"] = isNvrPreset();
    model["name"] = name();
    model["groups"] = groups();
    model["showUngrouped"] = showUngrouped();
    model["visible"] = visible();
    model["badgeColor"] = badgeColor();
    model["items"] = items;

    return model;
}

void ViewportsLayoutModel::setSize(const QSize &size)
{
    if (size == QSize(m_columns, m_rows)) {
        return;
    }

    resize(size.width(), size.height());

    emit sizeChanged(size);
}
