{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, makeWrapper # 1. Added makeWrapper utility here
, glib
, gtk3
, atk
, cairo
, pango
, gdk-pixbuf
, nss
, nspr
, dbus
, libuuid
, libgbm
, libdrm
, libxshmfence
, libxkbcommon
, alsa-lib
, fontconfig
, freetype
, expat
, systemd
, cups
, qt6
, libGL
, libx11
, libxcomposite
, libxdamage
, libxext
, libxfixes
, libxrandr
, libxcb
, libxcursor
, libxi
, libxtst
, libxrender
, libxscrnsaver
}:

stdenv.mkDerivation rec {
  pname = "helium-browser";
  version = "0.13.4.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-bin_${version}-1_amd64.deb";
    # Use your working sha256 hash here
    hash = "sha256-g3INldvfV+kQ3HRCyhWdnL6KjGavuwqL5fB0A5cf8a0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper # 2. Included makeWrapper in native build utilities
  ];

  buildInputs = [
    glib
    gtk3
    atk
    cairo
    pango
    gdk-pixbuf
    nss
    nspr
    dbus
    libuuid
    libgbm
    libdrm
    libxshmfence
    libxkbcommon
    alsa-lib
    fontconfig
    freetype
    expat
    cups
    systemd
    qt6.qtbase
    libGL
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxcursor
    libxi
    libxtst
    libxrender
    libxscrnsaver
  ];

  dontWrapQtApps = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out

    # Wipe the legacy Qt5 shim so autoPatchelf doesn't throw a mismatched Qt error
    find $out -name "libqt5_shim.so" -delete

    # 1. Relocate desktop icons, launchers, and assets safely
    if [ -d "$out/usr/share" ]; then
      mkdir -p $out/share
      cp -r $out/usr/share/* $out/share/
      rm -rf $out/usr/share
    fi

    # 2. Locate the main browser binary executable inside the extracted payload
    FOUND_BIN=""
    for name in "helium" "helium-browser"; do
      if [ -z "$FOUND_BIN" ]; then
        FOUND_BIN=$(find $out -type f -executable -name "$name" | head -n 1)
      fi
    done

    if [ -z "$FOUND_BIN" ]; then
      echo "ERROR: Could not locate the Helium browser binary in the package structure!"
      exit 1
    fi

    echo "Helium binary discovered at: $FOUND_BIN"

    # 3. Use makeWrapper to safely create the execution script in $out/bin
    # This automatically appends system GPU paths and safely handles empty variables
    mkdir -p $out/bin
    makeWrapper "$FOUND_BIN" "$out/bin/helium" \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:${lib.makeLibraryPath [ libGL libgbm libdrm libxshmfence ]}"

    # 4. Correct execution parameters inside the extracted .desktop launchers
    if [ -d "$out/share/applications" ]; then
      substituteInPlace $out/share/applications/*.desktop \
        --replace "Exec=/usr/bin/" "Exec=$out/bin/" \
        --replace "Exec=helium" "Exec=$out/bin/helium" || true
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "A private, fast, and honest web browser based on ungoogled-chromium";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "helium";
  };
}
