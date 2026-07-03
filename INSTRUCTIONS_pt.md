# Manual do usuário do KVision

> [!NOTA]
> Este manual de instruções foi traduzido e formatado automaticamente com o auxílio da Inteligência Artificial (IA).

**KVision** é um aplicativo de desktop avançado de classe VMS (Sistema de gerenciamento de vídeo) projetado para visualização simultânea de transmissões de vídeo ao vivo (RTSP/ONVIF) e integração com gravadores Hikvision NVR/DVR (tanto no modo Ao vivo quanto no modo de arquivo de reprodução).

O programa foi otimizado para estabilidade, operação suave (60 FPS) e consumo mínimo de recursos do sistema.

---

## Índice
1. [Descrição das ações do botão](#1-description-of-button-actions)
2. [Instalação e lançamento](#2-installation-and-launching)
3. [Gerenciamento de gravadores NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Visualização ao vivo e sobreposições de viewport](#4-live-view-and-viewport-overlays)
5. [Layouts de tela, predefinições e barra de ferramentas](#5-screen-layouts-presets-and-toolbar)
6. [Painel de estatísticas do sistema (estatísticas do sistema)](#6-system-statistics-panel-system-stats)
7. [Reprodutor de arquivo de reprodução](#7-playback-archive-player)
8. [Baixando gravações (Downloader)](#8-downloading-recordings-downloader)
9. [Configurações avançadas e personalização na janela de opções](#9-advanced-settings-and-customization-in-options-window)
10. [Atalhos de teclado e controles de mouse](#10-keyboard-shortcuts-and-mouse-controls)
11. [Tirando instantâneos e configuração de caminho](#11-taking-snapshots-and-path-configuration)

---

## 1. Descrição das ações dos botões

Esta seção descreve o significado de todos os ícones gráficos e botões usados ​​no aplicativo.

### Barra de ferramentas superior
* {ICON:quit} **Fechar janela**: solicita confirmação e fecha a janela ou aplicativo ativo.
* {ICON:pin} **Pin Bar**: bloqueia a barra superior em um estado expandido ou permite o recolhimento automático.
* {ICON:fullscreen} **Tela cheia**: alterna a janela ativa para o modo de tela cheia.
* {ICON:minimize} **Minimizar**: Minimiza a janela do aplicativo na barra de tarefas do sistema.
* {ICON:options} **Opções**: Abre ou fecha a janela de opções de configuração (configurações e gravadores).
* {ICON:new_window} **Nova Janela**: Abre uma nova janela auxiliar independente para transmissões de câmeras.
* {ICON:archive} **Arquivar**: Abre a janela de arquivo de gravações de reprodução (linha do tempo e calendário).
* {ICON:instructions} **Instruções**: Abre este manual do usuário e a janela de assistência técnica.
* {ICON:stats} **Estatísticas**: Alterna o painel deslizante de estatísticas do sistema (CPU, RAM, GPU, Net).
* {ICON:lock} **Grid Lock**: desativa os ajustes de divisão da grade para proteger seu layout ativo.
* {ICON:hamburger} **Mais opções**: abre a caixa de ferramentas deslizante para tamanhos avançados de divisão, proporções e mesclagem de células.

### Sobreposições de viewport (câmeras)
* {ICON:snapshot} **Instantâneo**: captura uma imagem sem perdas em resolução total e a salva como um arquivo JPEG.
* {ICON:play} **Arquivo da câmera**: inicia a janela de reprodução da linha do tempo para esta câmera (retrocesso de 15 minutos).
* {ICON:quick_play} **Reprodução rápida (miniplayer)**: inicia uma reprodução de arquivo na janela de visualização dos últimos 30 minutos, permitindo que você revise rapidamente as filmagens recentes diretamente no bloco da câmera sem sair da visualização ao vivo.
* {ICON:grid_1x1} **Tente 1:1**: exibe o stream de vídeo em sua resolução nativa original sem esticar.
* {ICON:zoom_in} **Zoom interativo**: alterna a ampliação de clicar e arrastar para uma região selecionada do letreiro.
* {ICON:zoom_out} **Redefinir zoom**: redefine a ampliação digital e restaura todo o campo de visão da câmera.
* {ICON:speaker_unmute} **Silenciar áudio**: representa um fluxo de áudio sem som; clicar nele silencia o stream.
* {ICON:speaker_mute} **Ativar áudio**: representa um fluxo de áudio silenciado; clicar nele ativa o som do stream.

### Controles da janela de reprodução

**Controles da barra superior:**
* {ICON:close} **Fechar**: Fecha a janela do reprodutor de arquivo de reprodução.
* {ICON:pin} **Pin Bar**: bloqueia a barra superior em um estado expandido ou permite o recolhimento automático.
* {ICON:fullscreen} **Tela cheia**: alterna a janela de reprodução para o modo de tela cheia.
* {ICON:sidebar} **Mostrar/Ocultar barra lateral**: alterna a visibilidade da barra lateral esquerda que contém câmeras e gravadores.
* {ICON:timeline_show} / {ICON:timeline_hide} **Mostrar/Ocultar linha do tempo**: mostra ou oculta o painel inferior que contém a linha do tempo e os controles de reprodução.
* {ICON:video_folder} **Pasta de vídeos**: abre a pasta do sistema local que contém os videoclipes baixados.
* {ICON:photo_folder} **Pasta de instantâneos**: abre a pasta do sistema local que contém os instantâneos capturados.
* botões de grade `1x1`, `1x2`, `2x1`, `2x2`: Muda o layout de exibição da câmera da janela de reprodução para 1, 2 (vertical/horizontal) ou 4 visualizações simultâneas.

**Barra inferior e controles da linha do tempo:**
* {ICON:prev_day} **Dia anterior**: navega para as gravações do dia anterior.
* {ICON:calendar_select} **Seletor de data**: abre uma caixa de diálogo de calendário para selecionar uma data específica para reprodução.
* {ICON:next_day} **Próximo dia**: navega para as gravações do próximo dia corrido.
* {ICON:today} **Hoje**: muda instantaneamente o foco da reprodução para o dia atual do calendário.
* {ICON:refresh_recordings} **Atualizar gravações**: atualiza e consulta novamente os segmentos de gravação disponíveis no dispositivo.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Predefinições de zoom da linha do tempo**: dimensiona a janela visível da linha do tempo (para 1 hora, 8 horas ou 24 horas) para navegação de alta precisão.
* {ICON:timeline_center} **Centralizar linha do tempo**: centraliza a visualização da linha do tempo precisamente em torno do carimbo de data/hora da reprodução atual.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Velocidade de reprodução**: ajusta o multiplicador de reprodução de vídeo (velocidade padrão de 1x, reprodução acelerada de 2x ou reprodução rápida de 4x).
* {ICON:download} **Download**: abre a ferramenta de download para exportar um segmento de vídeo definido do dispositivo.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Pular para trás**: retrocede o carimbo de data/hora da reprodução em 60, 45 ou 15 segundos.
* {ICON:play} / {ICON:pause} **Reproduzir / Pausar**: inicia ou pausa a reprodução do fluxo de vídeo do arquivo.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Avançar**: avança o carimbo de data/hora da reprodução em 15, 45 ou 60 segundos.

**Outros ícones gerais e de diagnóstico:**
* {ICON:calendar} **Calendário**: Representa configurações de calendário/agendamento.
* {ICON:clock} **Tempo**: Representa relógio ou indicadores de status temporais.
* {ICON:zoom} **Zoom**: representa configurações de escala ou zoom digital.
* {ICON:timeline_toggle} **Alternância da linha do tempo**: representa a alternância ou atualização das visualizações cronológicas.
* {ICON:trash} **Excluir**: Remove com segurança gravadores ou layouts configurados com confirmação.
* {ICON:warning} **Aviso**: exibido em caixas de diálogo para ações irreversíveis ou avisos de exclusão.

---

## 2. Instalação e lançamento

### Instalando no Arch Linux (Pacman)
Para instalar o programa a partir do pacote binário preparado, vá para o diretório `packaging/arch/` e execute:
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
O pacote instalará automaticamente o programa, o arquivo de ativação `.desktop` e as bibliotecas Hikvision SDK necessárias no caminho do sistema `/usr/lib/kvision`.

### Compilação manual (do código-fonte)
Se você quiser compilar o programa manualmente (por exemplo, em outra distribuição Linux) em vez de usar o pacote pronto:

1. Instale as dependências de compilação e tempo de execução necessárias usando seu gerenciador de pacotes. Para Arch Linux/CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configure o projeto usando CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compile o código:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Instale o aplicativo no sistema:
   ```bash
   sudo cmake --install build
   ```

### Lançamento
O programa pode ser iniciado a partir do menu do sistema ou digitando no terminal:
```bash
kvision
```

### Solução de problemas de dimensionamento do sistema (KDE Plasma)

A partir da versão 2.4.4, o KVision detecta automaticamente e aplica corretamente o dimensionamento fracionário da área de trabalho (por exemplo, 125%, 145%, 150%) configurado nas configurações do KDE Plasma, aplicando políticas nativas de passagem de alto DPI no Qt. A interface do usuário agora deve ser dimensionada corretamente imediatamente, sem qualquer intervenção manual.

#### Suporte nativo ao Wayland

Para garantir a melhor experiência de dimensionamento e desempenho no Wayland, certifique-se de ter o pacote `qt5-wayland` opcional instalado em seu sistema. Isto permite que o KVision rode nativamente no Wayland em vez de voltar ao XWayland.

Para Arch Linux/Manjaro/CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Para Debian/Ubuntu/Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Substituição manual de dimensionamento (legado/substituto)

Se você estiver executando uma versão mais antiga, uma configuração incomum ou simplesmente desejar forçar manualmente um fator de escala diferente do resto do sistema, você ainda poderá substituir o escalamento do aplicativo usando variáveis ​​de ambiente.

Por exemplo, para forçar o escalonamento de **150%**, inicie o aplicativo no terminal com:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Você pode aplicar isso permanentemente editando o inicializador de aplicativos `kvision.desktop` no editor de menu do KDE e adicionando essas variáveis ao campo "Variáveis de ambiente").*

---

## 3. Gerenciando gravadores NVR/DVR

Para configurar a conexão com um gravador Hikvision:
1. Abra a janela de opções e vá até a aba **Gravadores** (ícone do servidor).
2. Insira os detalhes de acesso do dispositivo:
   * **Endereço IP**: O endereço de rede do gravador.
   * **Porta**: a porta de rede do SDK (o padrão é `8000`).
   * **Nome de usuário**: nome de usuário (por exemplo, `admin`).
   * **Senha**: Senha de acesso ao gravador.
3. Clique em **Conectar e descobrir** (ou **Salvar e atualizar**).
4. Após a conexão bem-sucedida, o aplicativo detectará automaticamente todas as câmeras ativas (canais) conectadas ao NVR/DVR e as adicionará à lista.
5. Clicar no botão **Gerar Grade** criará automaticamente um layout de janela de visualização (predefinido) contendo todas as câmeras ativas daquele NVR em um layout de grade ideal.
6. **Exibindo listas de câmeras (NvrCamerasWindow)**: Clicar no botão do ícone do monitor do computador em qualquer cartão de gravador abre uma janela dedicada mostrando todos os canais de câmeras detectados como blocos interativos.
7. **Gerando miniaturas (Gerar miniaturas)**: Na janela de lista de câmeras NVR, um botão *„Gerar miniaturas”* está disponível. Clicar nele comanda o aplicativo para extrair quadros únicos do Sub Stream de cada canal em segundo plano, definindo-os como miniaturas de fundo do bloco. Isso fornece uma visualização rápida de cada câmera sem iniciar feeds completos ao vivo.
8. **Recurso clicar e adicionar**: O aplicativo não suporta arrastar blocos (arrastar e soltar) da janela da lista de câmeras para a grade principal. A atribuição da câmera é feita de maneira simples e confiável: primeiro clique com o botão esquerdo em qualquer bloco da janela de visualização na grade da tela principal para selecioná-la (ela será destacada com uma borda brilhante) e, em seguida, clique no botão verde **"+" (Atribuir à janela de visualização ativa)** no bloco da câmera desejada na janela da lista de câmeras do NVR. O stream será carregado instantaneamente nesse slot.
9. **Status da sessão SDK (indicador de ponto)**: ao lado do IP de cada gravador na lista, há um ponto de status colorido:
   * **Verde (LOGGED IN)**: Representa uma sessão ativa do Hikvision SDK, que é necessária para controle PTZ, solicitações de arquivo da linha do tempo e download.
   * **Vermelho (NÃO CONECTADO)**: Nenhuma sessão ativa do SDK está estabelecida no momento (por exemplo, antes da primeira solicitação do SDK ou após o logout manual/automático). Observe que os feeds ao vivo RTSP da câmera continuarão a ser reproduzidos independentemente do status da sessão do SDK.
10. **Renomeação de câmera local**: Em qualquer bloco de câmera na lista de câmeras NVR, clique no ícone **Editar** (lápis). Isso abre uma caixa de diálogo que permite definir um nome personalizado para a câmera. Esse nome é salvo localmente e atualizado instantaneamente nos players ao vivo, na linha do tempo e nas visualizações de blocos, sem modificar o dispositivo NVR físico. Você pode redefini-lo para o nome padrão a qualquer momento.
11. **Removendo um gravador da lista**: Ao lado de cada gravador configurado na lista, há um botão vermelho de lixeira. Clicar nele inicia um protocolo de segurança de dois estágios projetado para evitar exclusão acidental:
    * **Etapa 1 (Confirmação)**: Uma caixa de diálogo intitulada *“Confirmar exclusão do NVR”* aparece, perguntando se você tem certeza de que deseja excluir o gravador.
    * **Etapa 2 (Aviso)**: Uma segunda caixa de diálogo de aviso intitulada *“Aviso!”* aparece, perguntando se você tem certeza absoluta e está ciente do que está fazendo.
    * **Efeito de exclusão**: Ao aceitar o segundo aviso, o programa efetua logout daquele NVR em segundo plano, exclui sua entrada da configuração do aplicativo e **varre automaticamente a lista de layouts predefinidos**, removendo todas as grades dinâmicas geradas para este dispositivo NVR.

---

## 4. Visualização ao vivo e sobreposições de viewport

A janela principal do programa exibe o feed ao vivo:
* **Camera Grid**: Exibe fluxos ou feeds RTSP diretamente do Hikvision SDK.
* **Seleção de qualidade de stream**: clicando com o botão direito na janela de visualização da câmera, você pode selecionar o **stream principal** para obter a resolução mais alta ou o **stream secundário** para reduzir a carga da rede e da placa gráfica.
* **Alternar tela inteira com clique duplo**: Clicar duas vezes com o botão esquerdo do mouse em qualquer janela de visualização da câmera a maximiza instantaneamente para preencher toda a área ativa da janela (tela cheia de janela de visualização única). Clicar duas vezes novamente restaura o layout original da grade multicâmera.
* **Ocultar automaticamente a barra superior**: A barra de ferramentas de opções superiores (topToolBar) pode recolher automaticamente para a borda superior da tela quando o cursor do mouse sai de sua área (esta opção é configurável em Configurações -> *„Recolher automaticamente a barra superior”* ou diretamente usando o ícone de alfinete na barra superior).
* **Multi-Monitor e Janelas Auxiliares**: Você pode abrir janelas adicionais independentes (auxiliares) para executar diferentes layouts de grade simultaneamente em múltiplas telas ou monitores. Para abrir uma nova janela, use o atalho de teclado `Ctrl+N` ou clique no botão **"Nova janela"** na barra de ferramentas superior do slide suspenso. Cada janela pode ser configurada com seu próprio tamanho de grade e layout predefinido selecionado. Para garantir a máxima estabilidade em configurações de vários monitores, todas as janelas são iniciadas estritamente centralizadas na tela principal com 90% de sua resolução.

### Botões de sobreposição de viewport
No canto inferior direito de cada bloco/janela de visualização da câmera, um painel de controle com cinco ícones funcionais é exibido ao passar o cursor do mouse sobre ele (dependendo das preferências da UI):
1. **Ícone da câmera (instantâneo)**: permite que você faça uma captura de tela do feed da câmera. O instantâneo é salvo na resolução nativa completa do fluxo diretamente do buffer de quadros do decodificador, evitando quaisquer perdas devido ao tamanho atual do bloco da janela de visualização ou ao dimensionamento da resolução da tela. O salvamento bem-sucedido do instantâneo é confirmado pelo ícone da câmera piscando em laranja (`#ff7a00`) por exatamente 1 segundo.
2. **Ícone de reprodução (Arquivo)**: Usado para abrir rapidamente o arquivo de gravações. Clicar neste botão inicia automaticamente a linha do tempo `PlaybackWindow` para esta câmera específica, iniciando a reprodução **exatamente 15 minutos antes da hora atual do sistema** (um deslocamento rápido e conveniente para trás).
3. **Ícone de seta circular (reprodução rápida/miniplayer)**: ativa uma reprodução rápida na janela de visualização das gravações do arquivo da câmera dos últimos 30 minutos diretamente dentro do bloco da câmera, sem sair da grade ao vivo ou abrir a janela completa do arquivo.
   * **Painel de Controle**: Quando ativo, um painel de controle deslizante aparece na parte inferior da janela de visualização contendo:
     * **Reproduzir/Pausar**: pausa ou retoma o fluxo de reprodução.
     * **Exibição de tempo e deslocamento**: exibe o carimbo de data/hora da reprodução atual e sua idade relativa em comparação com o tempo real (por exemplo, `-12:34` representa 12 minutos e 34 segundos atrás).
     * **Controle deslizante interativo da linha do tempo**: permite clicar ou arrastar para buscar qualquer lugar dentro do buffer de 30 minutos. Os segmentos de gravação disponíveis são destacados com um fundo azul-petróleo e um indicador de reprodução vermelho marca a posição atual.
     * **Multiplicador de velocidade**: percorre as velocidades de reprodução (`1x`, `2x` e `4x`) para digitalizar a filmagem rapidamente.
     * **Fechar (✕)**: Fecha o miniplayer e retorna instantaneamente a janela de visualização para o feed ao vivo.
   * **Suporte para zoom panorâmico**: assim como na visualização ao vivo, você pode usar a ferramenta lupa para ampliar uma região do miniplayer ou segurar o botão do meio do mouse e arrastar para deslocar-se.
4. **Ícone 1:1 (escala nativa)**: alterna o modo de exibição de vídeo pixel a pixel. Quando ativado, o vídeo não é esticado ou distorcido para preencher os limites do bloco, mas é centralizado e mostrado em sua resolução nativa original. Quando este modo está ativo, o fundo do botão e o texto "1:1" são destacados em neon turquesa brilhante.
5. **Ícone de lupa (zoom interativo)**: permite ampliar qualquer região específica do feed de vídeo:
   * **Ativação**: clicar no ícone o alterna para um estado ativo (destaque turquesa). O cursor muda de forma e uma dica de ferramenta instrui: *“Clique e arraste na imagem da câmera para ampliar”*.
   * **Operação**: Clique com o botão esquerdo e arraste uma região retangular sobre o feed ao vivo. A janela de visualização cortará e dimensionará automaticamente a área selecionada para preencher todo o bloco.
     * **Zoom Proporcional**: Mantenha pressionada a tecla **Shift** enquanto desenha o retângulo de zoom para forçar a seleção a travar em uma proporção de 16:9, estritamente restrita aos limites da janela de visualização.
     * **Deslocamento panorâmico da imagem ampliada (Pan Zoom)**: Depois de aumentar o zoom, você pode manter pressionado o **botão do meio do mouse (roda de rolagem)** e arrastar o cursor para movimentar livremente a visualização ampliada ao redor do campo de visualização do vídeo. Isso funciona na visualização ao vivo, no arquivo de reprodução e no miniplayer.
   * **Redefinir**: Quando ampliado, o ícone da lupa muda de ícone (borda vermelha com um sinal de menos). Clicar nele redefine imediatamente o zoom, retornando à imagem completa da câmera.

---

## 5. Layouts de tela, predefinições e barra de ferramentas

Os layouts permitem organizar a disposição das câmeras na tela. Na aba **Presets** (ícone de estrela) você pode:
* **Criar novas predefinições**: Adicione seu próprio layout com qualquer configuração de colunas e linhas (por exemplo, 2x2, 3x3, 4x4).
* **Atribuir câmeras**: clique em uma janela de visualização no layout de grade para selecioná-la, abra a janela de câmeras NVR e clique no botão **"+" (Adicionar)** no bloco de câmera desejado. Você também pode trocar as posições da viewport usando o menu de contexto do botão direito (*„Zamień miejscami”* / *„Swap viewports”*) da viewport de origem e depois clicando na viewport de destino.

### Botões da barra superior (barra de ferramentas superior)
A barra de ferramentas deslizante superior fornece um conjunto abrangente de botões de navegação e controle de aplicativos:
1. **Fechar janela (botão vermelho ✕)**: fecha a janela ativa. Para evitar cliques acidentais, ele intercepta o evento de fechamento e exibe uma caixa de diálogo para confirmar a saída do aplicativo.
2. **Botão Fixar**: Controla o comportamento de ocultação automática da barra de ferramentas superior. Quando o pino está apontando verticalmente (estado fixado), a barra fica travada no lugar e permanece permanentemente visível. Quando o pino é girado em -45 graus (estado não fixado), a barra desliza automaticamente para cima, fora de vista, quando o mouse sai de sua área.
3. **Tela inteira (ícone de setas verdes)**: alterna instantaneamente a janela ativa para o modo de tela cheia e vice-versa. No modo de tela cheia, as setas apontam para dentro (recolher) e no modo de janela, apontam para fora (expandir).
4. **Minimizar (ícone de minimização ciano)**: Minimiza a janela do aplicativo na barra de tarefas. Restaurá-lo retorna a janela ao seu estado anterior exato (por exemplo, maximizado ou tela cheia).
5. **⚙️ OPÇÕES (OPCJE)**: Alterna a janela de opções de configuração. Se a janela já estiver aberta, clicar neste botão a fecha.
6. **📺 NOVA JANELA (AGORA OK NÃO)**: Abre um `Auxiliary Window` novo, independente e totalmente configurável, perfeito para expandir os layouts de sua câmera em várias configurações de monitor.
7. **ARQUIVO**: Abre um `PlaybackWindow` vazio (reprodutor de gravações) com linha do tempo e calendário ativos, permitindo seleção manual de transmissão e canais de câmera de qualquer NVR configurado por meio da lista da barra lateral.
8. **INSTRUÇÕES (INSTRUKCJA)**: Abre a janela deste manual, carregando a documentação completa do usuário em inglês ou polonês, dependendo da sua localidade ativa.
9. **📊 Chave STATS (STATYSTYKI)**: alterne a chave para deslizar o painel de monitoramento de estatísticas do sistema a partir da borda esquerda da tela.
10. **Chave de bloqueio de grade (cadeado)**: Chave que, quando ligada (destacada em laranja brilhante), desativa ações de redimensionamento de grade nos botões de grade adjacentes, protegendo o layout da câmera ativa contra alterações acidentais.
11. **Seletores de tamanho de grade (de 1x1 a 9x9)**: uma linha de nove botões que permite definir instantaneamente a estrutura de linha e coluna de sua janela de visualização (desde uma visualização 1x1 de uma única câmera até 81 feeds de câmera simultâneos em um layout 9x9). O tamanho atualmente ativo é destacado em laranja brilhante.
12. **Mais opções (menu hambúrguer com três linhas)**: botão que abre a caixa de ferramentas deslizante `Layout & Grid Tools` para ajuste avançado de grade, ajustes de geometria e opções de depuração (detalhadas abaixo).
13. **Botões de predefinição/visualização**: botões renderizados dinamicamente no lado direito da barra de ferramentas que representam seus layouts predefinidos configurados e visíveis (por exemplo, *达NVR*, *Visualizar 1*, etc.). Clicar em um botão muda imediatamente a grade. A visualização ativa é destacada em turquesa claro brilhante.

### Personalização e proporções avançadas de grade (ferramentas de layout e grade)
Abrir o menu Hambúrguer (Mais opções) abre uma caixa de ferramentas de layout especializada. Para ativar seus controles:
1. **Desbloquear painel de ferramentas**: alterne o botão "Desbloquear painel de ferramentas" na parte superior. Esta é uma medida de segurança explícita para evitar alterações acidentais em layouts complexos.
2. **Divisão de janela personalizada (F2 ou Press-and-Hold)**: A caixa de ferramentas exibe botões de divisão de grade de 1x1 a 9x9. Um recurso extremamente avançado é a capacidade de **substituir e editar tamanhos de divisão**. Se você clicar e segurar qualquer botão da grade com o botão esquerdo do mouse (ou focalizá-lo e pressionar **F2**), uma caixa de texto aparecerá. Você pode digitar qualquer divisão personalizada ou assimétrica (como `2x3`, `1x4`, etc.) e pressionar Enter. O botão é reprogramado instantaneamente e clicar nele aplica seu layout personalizado à janela de visualização principal.
3. **Proporções geométricas**: Permite forçar a exibição da grade para proporções específicas:
   * **Proporção de aspecto 16:9**: bloqueia e dimensiona o contêiner da grade para o formato widescreen 16:9 (padrão para câmeras IP modernas).
   * **Proporção de aspecto 4:3**: Adapta o contêiner da grade à proporção tradicional de 4:3 (comum em câmeras analógicas/IP legadas).
4. **Operações de grade (mesclar células destacadas)**: Acesse o recurso de mesclagem assimétrica de células (detalhado na Seção 9.2).

---

## 6. Painel de estatísticas do sistema (estatísticas do sistema)

Deslizando para fora da borda esquerda da tela Live View, este painel monitora a saúde do computador e a carga gerada pelo aplicativo:
* **Parâmetros monitorados**:
  * **CPU/RAM**: uso do processador principal (em % de todos os núcleos) e da RAM usada diretamente pelo processo `kvision` e seus subprocessos de download relacionados.
  * **GPU/VRAM**: utilização do núcleo da placa gráfica (em%) e a quantidade de memória gráfica VRAM ocupada pela renderização e decodificação de hardware (suporta listagem completa de processos de GPU usando o analisador XML de `nvidia-smi`).
  * **REDE (Net)**: Velocidade real de transferência de download do aplicativo de todos os players ativos ao vivo, players de arquivo e processos de download de gravação.
* **Multithreading (Stutter-Free)**: a coleta de dados do processo e da GPU é executada em um thread de sistema separado (`StatsWorker`). Isso evita qualquer micro-interrupção na renderização de vídeo (sem quedas de quadros).
* **Recurso Fixar**: clicar no botão **"Fixar"** (ícone de alfinete) bloqueia o painel em seu estado expandido.
* **Estética**: os gráficos apresentam bordas verdes neon brilhantes, um preenchimento gradiente sob a curva do gráfico e uma transparência de fundo equilibrada de 35% para garantir a legibilidade do texto.

---

## 7. Reprodutor de arquivo de reprodução

Disponível clicando no ícone de relógio/reprodução próximo a uma câmera ou gravador específico. Permite a visualização simultânea de gravações arquivadas de múltiplas câmeras Hikvision em sincronização em tempo integral.

### Linha do tempo e controles:
* **Início rápido (15 minutos atrás)**: Ao abrir o arquivo na visualização ao vivo, o player inicia automaticamente a partir de um momento **exatamente 15 minutos antes da hora atual do sistema** (em vez de começar à meia-noite). Isso permite a visualização imediata de um evento que acabou de ocorrer.
* **Navegação**: A linha do tempo pode ser rolada para a esquerda e para a direita arrastando-a com o botão esquerdo do mouse.
* **Zoom (escala)**: você pode alterar suavemente a escala da linha do tempo com a roda de rolagem do mouse (ou botões de zoom) – desde a visualização do dia inteiro até uma visualização precisa de 10 minutos.
* **Atalhos de zoom rápido**: a barra de controle inferior apresenta botões de ícones circulares dedicados para dimensionar instantaneamente a visualização da linha do tempo:
  * **Ícone “1h”**: Amplia a linha do tempo para inspeção detalhada em um período de 1 hora.
  * **Ícone “8h”**: Amplia a linha do tempo para exibir um intervalo de 8 horas.
  * **Ícone “24h”**: redefine o zoom para caber o dia inteiro de 24 horas em uma única tela.
  * **Ícone Centralizar (Destino)**: Centraliza imediatamente a linha do tempo para que o indicador vermelho de reprodução fique exatamente no meio da tela (substituindo o antigo botão de texto).
* **Navegação por data (calendário e dias)**: os controles ao lado da data exibida permitem saltos rápidos:
  * Botões **„<” (dia anterior)** e **„>” (dia seguinte)**: permitem avançar ou retroceder 24 horas instantaneamente sem abrir a caixa de diálogo do calendário.
  * **Ícone de calendário**: abre o pop-up do calendário para selecionar uma data específica.
  * **Ícone Atualizar**: Força uma nova pesquisa de gravações. Clicar nele varre o cache local de segmentos de disponibilidade de gravação para todos os canais ativos e envia novas consultas ao NVR, o que é muito útil para carregar arquivos gravados há poucos momentos (substituindo o antigo botão de texto).
  * **Ícone Hoje (data/número de hoje)**: volta instantaneamente para o dia atual (substituindo o botão de texto antigo).
* **Atalhos de velocidade de reprodução**:
  * **Ícones “1x”, “2x” e “4x”**: Altere instantaneamente o multiplicador de velocidade de reprodução.
* **Botões de salto do videocassete**:
  * **Ícones “15”, “45” e “60” com setas circulares**: permitem que você retroceda ou avance rapidamente pelo número especificado de segundos.
* **Barras de disponibilidade de gravação**: barras coloridas que representam os segmentos de vídeo encontrados no disco do gravador são renderizadas abaixo da linha do tempo. Um sistema de cache evita que eles pisquem ao arrastar.
* **Seguimento automático (rastreamento do indicador)**: O indicador de reprodução (linha vermelha vertical) é monitorado constantemente. Se o indicador sair do intervalo visível da linha do tempo, a visualização rolará automaticamente para centralizá-lo. Esta opção é bloqueada de forma inteligente durante o arrastamento manual do indicador pelo usuário.

### Painel lateral da câmera na janela de reprodução
Uma lista lateral vertical na borda direita do player lista todos os NVRs configurados e seus canais de câmera:
* **Alternar canais**: clicar em qualquer canal de câmera na lista o adiciona como um slot de reprodução ativo na linha do tempo (gerando um player de vídeo). Clicar novamente remove o canal.
* **Menu de contexto do canal**: clicar com o botão direito em um slot de vídeo ativo na grade de reprodução abre um menu para:
  * Alternar qualidade de vídeo (stream principal/stream secundário).
  * Fechar/remover o player ativo da reprodução do arquivo.

---

## 8. Baixando Gravações (Downloader)

Na janela Arquivo de reprodução, você pode baixar segmentos selecionados de gravações diretamente para a unidade do seu computador como arquivos MP4:
1. Clique no ícone de download (seta para baixo) próximo à câmera selecionada.
2. Selecione o intervalo de tempo (início e fim da gravação).
3. Selecione o local para salvar o arquivo de destino.
4. Clique em **Baixar**.

### Recursos avançados de download:
* **Download de segmento sequencial (partes de 1 GB)**: o programa divide automaticamente sua consulta de intervalo de tempo em segmentos de arquivos físicos (aproximadamente 1 GB cada na unidade NVR) e os baixa e converte um por um (usando arquivos `.pspart` temporários que são convertidos diretamente para o formato `.mp4`). Isso garante downloads altamente estáveis ​​de intervalos de longa duração sem estouro de memória ou travamentos de conversão FFmpeg.
* **Visualização do progresso geral**: a barra de progresso (cor azul-petróleo brilhante) exibe o progresso geral do download da câmera em todos os segmentos. O texto de status sobreposto na barra de progresso mostra a parte atual e as porcentagens, por exemplo, `Downloading part 1 of 3... 45% (Overall: 15%)`, com um estilo de contorno para garantir a legibilidade em qualquer plano de fundo.
* **Limpeza de IP de nome de arquivo**: os nomes de arquivos de vídeo (e instantâneos ao vivo/de arquivo) são automaticamente removidos dos endereços IP do NVR/DVR para mantê-los limpos e legíveis por humanos (por exemplo, `4_Wejscie_glowne_2026-06-15.mp4` em vez de `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Configurações avançadas e personalização na janela de opções

A janela de opções e configuração (`SideBar`) consiste em seis guias dedicadas:

### 1. Detalhes da janela de visualização (ícone do monitor)
Exibe parâmetros avançados do bloco de grade atualmente selecionado. Permite que você:
* Digite um **URL de fluxo primário** personalizado (RTSP/ONVIF) e um **URL de backup secundário** para configurações manuais.
* Alternar para ativar/desativar o som do canal de áudio da imagem da câmera selecionada.
* Insira substituições avançadas do decodificador na caixa de texto **Substituição de opções do FFmpeg**.
> [!TIP]
> Para conexão de stream mais rápida e estabilidade máxima em RTSP, os parâmetros recomendados são:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Ferramentas de layout e grade (ícone de controles deslizantes)
Opções avançadas de personalização de grade de tela:
* Alternância rápida para o modo Tela Cheia.
* **Mesclagem assimétrica de células (mesclagem de células destacadas)**: Um editor de layout altamente avançado. Segure **Ctrl** ou **Shift** e clique para selecionar vários blocos adjacentes na grade, ou use o teclado segurando **Shift** e navegando com as **teclas de seta**, depois clique em "Mesclar células destacadas" para fundi-las em uma única janela de visualização maior. Isso permite criar designs de grade assimétrica totalmente personalizados (por exemplo, um enorme painel de câmera com feeds menores ao seu redor).

### 3. Gravadores (ícone do servidor)
Gerenciador de configuração completo para conexões com dispositivos Hikvision NVR/DVR (descritos em detalhes na Seção 3).

### 4. Predefinições (ícone de estrela)
Gerenciador de layouts de grade e atribuições de câmera salvos. Permite criar modelos de grade vazios, alterar sua ordem, alternar a visibilidade da barra superior (através do botão "Visível") ou ativá-los na janela atual.

### 5. Configurações (ícone de engrenagem)
Permite ajustar as configurações globais do aplicativo:
* **Permitir a execução de múltiplas instâncias**: Marcar esta caixa permite iniciar múltiplas cópias paralelas do processo KVision (por padrão, ela restringe as execuções a uma única instância ativa).
* **Configurações de recolhimento automático**: personaliza o tempo de animação deslizante da barra superior e do painel de estatísticas.
* **Permitir troca de viewports**: A caixa de seleção *„Permitir troca de locais de viewports”* permite reorganizar as posições da câmera na grade instantaneamente (clique com o botão direito no bloco de origem -> Escolha "Trocar viewports" -> clique com o botão esquerdo no bloco de destino).
* **Permissões de clique com o botão direito**: alterna para bloquear/desbloquear controles interativos no menu de contexto do botão direito (Ativar menu de contexto, Permitir troca de viewports, Ativar a opção 'Remover câmera', Permitir alterar as configurações da viewport, Ativar seleção de qualidade principal/sub do stream).
* **Ativar som automaticamente**: ativa automaticamente o fluxo de áudio da janela de visualização ativa ao entrar no modo de tela cheia.
* **Ocultar o cursor em tela cheia**: A caixa de seleção *„Ocultar o cursor no modo de tela cheia”* oculta automaticamente o cursor do mouse após um breve período de inatividade durante a visualização em tela cheia para garantir uma visualização desobstruída.
* **Seleção de idioma**: alterna instantaneamente a tradução da interface (padrão do sistema, polonês, inglês).
* **Preferências da UI**: ocultar/mostrar rótulos de status da janela de visualização ou emblemas de controle (como ocultar automaticamente as sobreposições de controle no canto inferior direito dos blocos, a menos que você passe o mouse).
* **Opções padrão do FFmpeg e atualização em massa**: Permite configurar opções globais do FFmpeg aplicadas a novas viewports (recomendado: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[RECOMENDAÇÃO]** Se você estiver migrando de uma versão mais antiga do KVision (anterior à v2.4.5), é altamente recomendável alterar `-analyzeduration 0` para `-analyzeduration 100000` nas configurações globais e clicar em "Atualizar todas as câmeras". Definir `0` em streams sem trilha de áudio causa atrasos na comutação porque o FFmpeg bloqueará por um tempo limite codificado de 5 segundos aguardando pacotes de áudio. Definir um valor muito baixo (por exemplo, 100.000 microssegundos = 0,1s) resolve completamente esse problema, mantendo a comutação instantânea.
  * **Botão Atualizar todas as câmeras**: O botão *„Zaktualizuj wszystkie kamery”* aplica essas opções globais a todas as viewports configuradas.
  * **Sinalizações de baixa latência (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` desativa o buffer interno de pacotes do desmultiplicador para eliminar o atraso de streaming ao longo do tempo, mas pode causar interrupções se a conexão de rede com a câmera estiver instável.
    * `-flags low_delay` informa ao decodificador para gerar quadros imediatamente, mas pode causar breves artefatos/manchas em fluxos que usam quadros B sob movimentos rápidos.
  * **Caixa de seleção Substituir**: você pode excluir viewports específicas de atualizações globais ou padrões dinâmicos marcando **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** na caixa de diálogo Configurações de viewport individual. Útil para solucionar problemas de câmeras com travamento.


### 6. Changelog (ícone de relógio/documento)
Apresenta uma linha do tempo interativa mostrando o histórico completo de lançamentos, atualizações, correções de bugs e adições de recursos do KVision, garantindo que você tenha acesso direto aos detalhes das atualizações do programa.

---

## 10. Atalhos de teclado e controles de mouse

### Atalhos de teclado:
| Chave/Atalho | Ação |
|---|---|
| **F** / **F11** | Alternar modo de tela cheia. |
| **M** | Ativar/desativar áudio (funciona para a câmera ativa com áudio). |
| **Espaço** | Reproduzir/Pausar a reprodução na janela Arquivo de Reprodução. |
| **Alt + 1** a **Alt + 9** | Mudança rápida para uma predefinição/layout nos índices 1 a 9. |
| **Alt + Seta para a esquerda** | Mudança rápida para a predefinição/layout anterior da coleção. |
| **Alt + Seta para a direita** | Mudança rápida para o próximo preset/layout da coleção. |
| **Teclas de seta (para cima/para baixo/esquerda/direita)** | Navegue e mova o foco/seleção ativo entre as viewports da câmera. |
| **Shift + Teclas de seta** | Selecione múltiplas viewports de câmeras adjacentes simultaneamente (usadas para mesclagem de células, etc.). |
| **Ctrl + N** | Abra uma nova janela auxiliar independente. |
| **+** / **-** | Aumentar/diminuir zoom (câmeras Hikvision compatíveis com PTZ). |
| **Shift** (arrastar letreiro) | Força a seleção do letreiro para travar uma proporção de 16:9 durante o zoom interativo. |
| **Esc** | Saia do modo Tela Cheia/cancele a seleção da viewport ativa. |

### Interação do mouse:
* **Botão esquerdo do mouse**:
  * **Clique duas vezes** em uma janela de visualização de câmera na grade para maximizá-la para tela cheia. Outro clique duplo restaura a visualização em grade.
  * Arraste a linha do tempo na janela Reprodução para navegar.
* **Botão do meio do mouse (clique e arraste com a roda de rolagem)**:
  * Arraste para deslocar e mover a imagem digitalmente ampliada/com zoom ao redor do campo de visualização da janela de visualização (funciona em Live, Archive e Mini-player).
* **Botão direito do mouse (menu de contexto)**:
  * Abre um menu de configurações rápidas para a viewport selecionada (permite remover a câmera da grade, alterar entre fluxos principais/sub ou acessar parâmetros de exibição individuais).
* **Roda de rolagem do mouse**:
  * Ajusta a escala (Zoom) da linha do tempo no reprodutor de arquivo de reprodução.

---

## 11. Tirando instantâneos e configuração de caminho

O aplicativo permite capturar rapidamente instantâneos de alta qualidade de qualquer janela de visualização da câmera nos modos Live View e Playback Archive.

### Tirando fotos:
1. Um botão de sobreposição de ícone de câmera está disponível no canto inferior direito de cada viewport (detalhado na Seção 4).
2. Clicar no ícone da câmera captura o quadro e o salva como uma imagem JPEG (qualidade 98 – praticamente sem perdas).
3. Uma captura bem-sucedida é confirmada pelo ícone da câmera piscando em laranja (`#ff7a00`) por exatamente 1 segundo.
4. **Resolução total**: no modo Playback Archive, os instantâneos são salvos na resolução de origem nativa completa do stream diretamente do buffer de quadros do decodificador, independentemente do tamanho da janela de visualização ativa na tela ou da escala de exibição.

### Salvando configurações de caminho:
1. Vá para a guia **Configurações** (ícone de engrenagem na janela de opções).
2. Na seção **Salvando** ("Zapis"), você pode configurar os caminhos padrão:
   * **Caminho padrão dos snapshots**: pasta onde os snapshots serão salvos (o padrão é `~/Obrazy/CCTV`).
   * **Caminho de gravação padrão**: Pasta onde os vídeos MP4 baixados serão salvos (o padrão é `~/Wideo/CCTV`).
3. Clicar no botão do navegador `...` abre o seletor de pasta nativo do seu sistema operacional (Breeze no KDE).
4. **Comportamento do botão do navegador**: O seletor de diretório abre precisamente no caminho digitado no campo de texto (se existir). Se o campo estiver vazio, inválido ou apontando para uma pasta à qual você não tem acesso, a caixa de diálogo volta e abre em seu diretório inicial (`~/`).

### Configurações da interface do usuário (IU):
1. Vá para a aba **Configurações** (ícone de engrenagem na janela de opções) ou abra a janela **Opções** ("Opcje").
2. Na seção **Configurações da interface do usuário**, você pode personalizar a visibilidade dos elementos sobrepostos nas kafelki/viewports da câmera:
   * **Mostrar o status do canal no canto superior esquerdo da janela de visualização** (ativado por padrão) — Exibe informações de carregamento, reprodução e status da conexão do stream.
   * **Mostrar informações da câmera no canto inferior esquerdo da janela de visualização** (habilitado por padrão) — Exibe o nome da câmera recuperada do gravador Hikvision.
   * **Mostrar ícones de controle no canto inferior direito da janela de visualização somente ao passar o mouse** (habilitado por padrão) — Oculta automaticamente o painel de botões de controle (instantâneo, arquivo, 1:1 pixel a pixel, zoom de região) quando o cursor do mouse está fora da janela de visualização específica da câmera. Os ícones aparecem instantaneamente assim que você move o mouse sobre a janela de visualização (não é necessário clicar) e desaparecem ao sair, maximizando a visibilidade dos fluxos de sua câmera.
   * **Mostrar campos de informações somente ao passar o mouse** (desativado por padrão) — Opção análoga que oculta o status no canto superior esquerdo e o nome no canto inferior esquerdo das janelas de visualização, exibindo um fluxo de câmera completamente limpo, a menos que o cursor seja movido sobre esse bloco de câmera específico.
