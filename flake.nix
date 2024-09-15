{
  description = "Nix flake for configuring earlyoom service";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      nixosConfigurations = {
        earlyoom = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }: {
              systemd.services.earlyoom.serviceConfig = {
                AmbientCapabilities = "CAP_KILL CAP_IPC_LOCK";
                CapabilityBoundingSet = "CAP_KILL CAP_IPC_LOCK";
                Nice = "-20";
                OOMScoreAdjust = "-100";
                Restart = "always";
                TasksMax = "10";
                MemoryMax = "50M";
                DynamicUser = true;
                ProtectSystem = "strict";
                ProtectHome = true;
                PrivateDevices = true;
                ProtectClock = true;
                ProtectHostname = true;
                ProtectKernelLogs = true;
                ProtectKernelModules = true;
                ProtectKernelTunables = true;
                ProtectControlGroups = true;
                RestrictNamespaces = true;
                RestrictRealtime = true;
                LockPersonality = true;
                PrivateNetwork = true;
                IPAddressDeny = true;
                RestrictAddressFamilies = "AF_UNIX";
                SystemCallArchitectures = "native";
                SystemCallFilter = [ "@system-service" "~@resources @privileged" ];
              };

              services.earlyoom = {
                enable = true;
                freeMemThreshold = 5; # <%5 free
              };
            })
          ];
        };
      };
    };
}
