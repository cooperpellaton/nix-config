{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, doom-emacs, ... }@inputs: {
    packages = {
      "x86_64-linux" = {
        default = home-manager.defaultPackage.x86_64-linux;
      };
      "aarch64-darwin" = {
        default = home-manager.defaultPackage.aarch64-darwin;
      };
    };

    homeConfigurations."cooper@americano" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home.nix
          doom-emacs.hmModule
          {
            home.username = "cooper";
            home.homeDirectory = "/Users/cooper";
          }
          { nixpkgs.overlays = [ inputs.emacs.overlay ]; }
        ];
      };
  };
}
