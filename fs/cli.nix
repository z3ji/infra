{
  util,
  pkgs,
  ...
}: let
  allHosts = util.mapHosts (f: f);
  managedHosts = builtins.filter (h: (builtins.readDir ../hosts/${h}) ? "fs.nix") allHosts;
  hostApps = map (host:
    pkgs.callPackage ./btrfs_setup.nix {
      inherit host;
      fs = import ../hosts/${host}/fs.nix;
    })
  managedHosts;
in
  pkgs.writeShellApplication {
    name = "fs_cli";
    runtimeInputs = hostApps;
    text = ''
      set +u

      host=$1
      command=$2

      if [ -z "$host" ] || [ -z "$command" ]; then
          echo "
          usage: fs_cli <host> <command>
          commands:
            show: prints the setup script
            show_config: prints the config result in a pretty format
            show_src: prints the nix source of the config file
            apply: runs the setup script
          "
          exit 1
      fi

      if [ "$command" = "show" ]; then
          cat "$(which "btrfs_setup_$host")"
      elif [ "$command" = "apply" ]; then
          eval "$(which "btrfs_setup_$host")"
      elif [ "$command" = "show_config" ]; then
          if [ ! -f /tmp/alejandra ]; then
              curl -L https://github.com/kamadorueda/alejandra/releases/download/3.0.0/alejandra-x86_64-unknown-linux-musl > /tmp/alejandra
              chmod +x /tmp/alejandra
          fi
          nix eval -f "./hosts/$host/fs.nix" | /tmp/alejandra --quiet
      elif [ "$command" = "show_src" ]; then
          cat "./hosts/$host/fs.nix"
      else
          echo "unknown command $command"
          exit 1
      fi
    '';
  }
