%global debug_package %{nil}

Name:           kvision
Version:        %{?pkg_version:%{pkg_version}}%{!?pkg_version:2.8.4}
Release:        1%{?dist}
Summary:        KVision - NVR and IP camera viewing application

License:        GPL-3.0-or-later
URL:            https://github.com/Arkanista/KVision
Source0:        %{name}-%{version}.tar.gz

Requires:       qt5-qtbase
Requires:       qt5-qtdeclarative
Requires:       qt5-qtmultimedia
Requires:       qt5-qtsvg
Requires:       qt5-qtquickcontrols
Requires:       qt5-qtquickcontrols2
Requires:       qt5-qtgraphicaleffects
Requires:       qt5-qtwayland

%description
A cross-platform application for simultaneously viewing multiple IP camera
video streams and managing Hikvision NVR/DVR live view and archive playback.
Designed for high performance and low latency using Qt5, QML, and FFmpeg.

%prep
%setup -q -n %{name}-%{version}

%build
cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=%{_prefix} \
    -DCMAKE_INSTALL_LIBDIR=%{_libdir} \
    -DBUILD_TESTING=OFF
cmake --build build -j%{?_smp_build_ncpus:%{_smp_build_ncpus}}%{!?_smp_build_ncpus:4}

%install
DESTDIR=%{buildroot} cmake --install build

%files
%{_bindir}/kvision
%{_libdir}/kvision/
/usr/share/applications/kvision.desktop
/usr/share/icons/hicolor/128x128/apps/kvision.png
/usr/share/icons/hicolor/256x256/apps/kvision.png
/usr/share/icons/hicolor/512x512/apps/kvision.png
/usr/share/pixmaps/kvision.png

%changelog
* Fri Nov 20 2026 Arkanista <68946052+Arkanista@users.noreply.github.com> - 2.7.12-1
- Initial RPM packaging for Fedora and RHEL/Rocky Linux 9
