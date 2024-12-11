{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    packages = {
      "x86_64-linux" = {
        default = home-manager.defaultPackage.x86_64-linux;
      };
      "aarch64-darwin" = {
        default = home-manager.defaultPackage.aarch64-darwin;
      };
    };

    homeConfigurations."cooper@americano" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./home.nix
        {
          home.username = "cooper";
          home.homeDirectory = "/Users/cooper";
        }
      ];
    };

    homeConfigurations."Cooper@cappuccino" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./home.nix
        ./work.nix
        {
          home.username = "Cooper";
          home.homeDirectory = "/Users/Cooper";
        }
      ];
    };

    homeConfigurations."cooper@lungo" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./home.nix
        ./work.nix
        {
          home.username = "cooper";
          home.homeDirectory = "/Users/cooper";
        }
      ];
    };
  };
}
