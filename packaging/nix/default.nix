{ lib
, stdenv
, cmake
, pkg-config
, wrapQtAppsHook
, autoPatchelfHook
, qttools
, qtbase
, qtdeclarative
, qtmultimedia
, qtsvg
, qtquickcontrols
, qtquickcontrols2
, qtgraphicaleffects
, qtwayland
, ffmpeg
, libva
, libGL
, xorg
, gtest
, bzip2
, freetype
, libuuid
, zlib
}:

let
  cmakeLines = lib.splitString "\n" (builtins.readFile ../../CMakeLists.txt);
  readVer = name:
    let
      prefix = "set(${name} ";
      line = lib.findFirst (l: lib.hasPrefix prefix l) "" cmakeLines;
    in
    lib.removeSuffix ")" (lib.removePrefix prefix line);

  version = "${readVer "VER_MAJ"}.${readVer "VER_MIN"}.${readVer "VER_PAT"}";

  cleanedSrc = lib.cleanSourceWith {
    src = ../..;
    filter = path: type:
      let
        relPath = lib.removePrefix (toString ../.. + "/") (toString path);
      in
      !(lib.hasPrefix ".git" relPath
        || lib.hasPrefix "build" relPath
        || lib.hasPrefix "dist" relPath
        || lib.hasPrefix "AppDir" relPath
        || lib.hasPrefix "appimage-tools" relPath
        || lib.hasSuffix ".pkg.tar.zst" relPath);
  };
in
stdenv.mkDerivation {
  pname = "kvision";
  inherit version;

  src = cleanedSrc;

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtmultimedia
    qtsvg
    qtquickcontrols
    qtquickcontrols2
    qtgraphicaleffects
    qtwayland
    ffmpeg
    libva
    libGL
    xorg.libX11
    gtest
    stdenv.cc.cc.lib
    bzip2
    freetype
    libuuid
    zlib
  ];

  NIX_LDFLAGS = toString [
    "--allow-shlib-undefined"
    "-rpath-link ${lib.makeLibraryPath [ freetype xorg.libX11 libGL libuuid bzip2 zlib ]}"
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DPACKAGER=NIX"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  preBuild = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/lib/kvision"
    addAutoPatchelfSearchPath "$out/lib/kvision/HCNetSDKCom"
    qtWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ ffmpeg ]}")
  '';

  meta = with lib; {
    description = "KVision VMS - Cross-platform NVR and IP camera viewing application for Hikvision NVR/DVR and RTSP streams";
    homepage = "https://github.com/Arkanista/KVision";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kvision";
  };
}
