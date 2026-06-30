{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, gtk3
, libayatana-appindicator
, keybinder3
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "flclashx";
  version = "0.3.2"; 

  src = fetchurl {
    url = "https://github.com/pluralplay/FlClashX/releases/download/v${version}/FlClashX-linux-amd64.deb";
    # TODO: Paste the working SHA-256 hash that your system successfully built with last time
    hash = "sha256-VUDpjyt8rtDa7HMjUJjWVkdr47jfTf+YOeSi0ufWWGE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    keybinder3
    glib-networking
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out
    
    # 1. Preserve the desktop items and icons if they exist
    if [ -d "$out/usr/share" ]; then
      mkdir -p $out/share
      cp -r $out/usr/share/* $out/share/
      rm -rf $out/usr/share
    fi

    # 2. Dynamically scan the unpacked files to find the true executable location
    FOUND_BIN=""
    for name in "FlClashX" "flclashx" "FlClash" "flclash"; do
      if [ -z "$FOUND_BIN" ]; then
        FOUND_BIN=$(find $out -type f -executable -name "$name" | head -n 1)
      fi
    done

    # Fallback to search any binary containing "clash" if exact matches fail
    if [ -z "$FOUND_BIN" ]; then
      FOUND_BIN=$(find $out -type f -executable -iname "*clash*" | head -n 1)
    fi

    if [ -z "$FOUND_BIN" ]; then
      echo "ERROR: Failed to find the FlClashX executable binary inside the unpacked package layout!"
      exit 1
    fi

    echo "Target binary discovered at: $FOUND_BIN"

    # 3. Create an explicit wrapper script inside $out/bin so Nix registers it in your PATH
    mkdir -p $out/bin
    cat <<EOF > $out/bin/flclashx
#!/bin/sh
exec "$FOUND_BIN" "\$@"
EOF
    chmod +x $out/bin/flclashx

    # Provide a capitalized fallback link just in case
    ln -s flclashx $out/bin/FlClashX

    # 4. Point the desktop environment launcher to our new wrapper location
    if [ -d "$out/share/applications" ]; then
      substituteInPlace $out/share/applications/*.desktop \
        --replace "Exec=/usr/bin/" "Exec=$out/bin/" \
        --replace "Exec=flclashx" "Exec=$out/bin/flclashx" \
        --replace "Exec=FlClashX" "Exec=$out/bin/flclashx" || true
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fork of the multi-platform proxy client FlClash, based on original Mihomo Core";
    homepage = "https://github.com/pluralplay/FlClashX";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "flclashx";
  };
}
