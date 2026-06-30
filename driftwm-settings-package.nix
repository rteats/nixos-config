{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, gtk4
, libadwaita
, glib
}:

rustPlatform.buildRustPackage rec {
  pname = "driftwm-settings";
  version = "0.4.0"; # Replace with the exact version or tag you wish to target

  src = fetchFromGitHub {
    owner = "wwmaxik";
    repo = "driftwm-settings";
    rev = "v${version}"; # If targeting a specific commit, use the full 40-character SHA instead
    hash = "sha256-XO2H5mSBkWMmqlSUXuzPmQMOQn5v1utLNlVzXBbNa6Y=";
    # hash = lib.fakeHash; # This acts as a placeholder; Nix will tell you the correct hash on build failure
  };

  # Modern Nixpkgs pattern for vendoring Rust dependencies
  useFetchCargoVendor = true;
  cargoHash = "sha256-5s1JCoIoOmBs/iUgtXoYBA4iZfVuqgMX6pHdtOv+5CE=";
  # cargoHash = lib.fakeHash; # Temporary placeholder hash

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita # Used for the modern sidebar navigation layout
    glib
  ];

  # The repository includes a Makefile. If it handles installing desktop icons/files nicely, 
  # you can uncomment this postInstall phase to leverage it:
  # postInstall = ''
  #   make install PREFIX=$out
  # '';

  meta = {
    description = "Complete GUI configuration editor for driftwm (GTK4/Rust)";
    homepage = "https://github.com/wwmaxik/driftwm-settings";
    license = lib.licenses.gpl3Only; # Verify the exact license file in the repository
    platforms = lib.platforms.linux;
    mainProgram = "driftwm-settings";
  };
}
