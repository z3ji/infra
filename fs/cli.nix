{
  util,
  pkgs,
  ...
}: let
  # Function to filter hosts with Nix files
  managedHosts = builtins.filter (h: builtins.readDir ../hosts/${h} ? "fs.nix") (util.mapHosts (f: f));

  # Function to generate host-specific applications
  hostApps = map (host:
    pkgs.callPackage ./btrfs_setup.nix {
      inherit host;
      fs = import ../hosts/${host}/fs.nix;
    })
  managedHosts;
in
  pkgs.writeShellApplication {
    name = "fs_cli";

    # Runtime inputs required by the application
    runtimeInputs = hostApps;

    # Shell script text
    text = ''
      # Disable undefined variable error checking
      set +u

      # Read command line arguments
      host=$1
      command=$2

      # Function to display usage information
      usage() {
          cat <<-USAGE
          usage: fs_cli <host> <command>
          commands:
            show: prints the setup script
            show_config: prints the config result in a pretty format
            show_src: prints the nix source of the config file
            apply: runs the setup script
          USAGE
          exit 1
      }

      # Check if host and command are provided
      if [ -z "$host" ] || [ -z "$command" ]; then
          usage
      fi

      # Execute the appropriate command
      case "$command" in
          show)
              cat "$(command -v "btrfs_setup_$host")"
              ;;
          apply)
              eval "$(command -v "btrfs_setup_$host")"
              ;;
          show_config)
              # Download Alejandra if not present and show config
              if [ ! -f /tmp/alejandra ]; then
                  curl -L https://github.com/kamadorueda/alejandra/releases/download/3.0.0/alejandra-x86_64-unknown-linux-musl > /tmp/alejandra
                  chmod +x /tmp/alejandra
              fi
              nix eval -f "./hosts/$host/fs.nix" | /tmp/alejandra --quiet
              ;;
          show_src)
              cat "./hosts/$host/fs.nix"
              ;;
          *)
              echo "unknown command $command"
              usage
              ;;
      esac
    '';
  }
