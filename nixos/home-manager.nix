{ inputs, ... }: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.paul = {
      imports = [
        # Home Manager user-level agenix module
        inputs.agenix.homeManagerModules.default
        ../home-manager/home.nix
      ];
    };
  };
}
