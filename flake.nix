{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";

    # antigravity-nix = {
    #   url = "github:jacopone/antigravity-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    driftwm.url = "github:malbiruk/driftwm";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    helium,
    # antigravity-nix,
    driftwm,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # 1. Define your system architecture here
    system = "x86_64-linux";

    # 2. Define the pkgs instance using that system
    pkgs = nixpkgs.legacyPackages.${system};

    # 3. Call your package here so it's available for both packages and modules
    driftwm-settings = pkgs.callPackage ./driftwm-settings-package.nix { };
    flclashx = pkgs.callPackage ./flclashx-package.nix { };
    # helium = pkgs.callPackage ./helium-package.nix { };
  in {
    # Makes it buildable via: nix build .#driftwm-settings
    packages.${system}.driftwm-settings = driftwm-settings;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#redmibook'
    nixosConfigurations = {
      redmibook = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [ 
          stylix.nixosModules.stylix 
	  ./nixos/power-management.nix
          ./nixos/configuration.nix
          ({ pkgs, ... }: {
            environment.systemPackages = [ driftwm-settings
	    flclashx  
	    inputs.helium.packages.${system}.default
            ];
          })
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#user@redmibook'
    homeConfigurations = {
      "user@redmibook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # Reuses the pkgs instance we defined in the let block
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ 
          stylix.homeModules.stylix 
          ./home-manager/home.nix 
          {
            nixpkgs.overlays = [
              # (final: prev: {
              #   openldap = prev.openldap.overrideAttrs (_: {
              #     doCheck = false;
              #   });
              # })
            ];
          }
        ];
      };
    };
  };
}
