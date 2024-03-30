{
  # Order of device mounting
  order = ["root" "boot"];

  # Device configurations
  devices = {
    root.path = "/dev/sda2";
    boot = {
      path = "/dev/sda1";
      mounts = ["/boot"];
    };
  };

  # Subvolume configurations
  subvols.root = with import ../../fs/primitives.nix; [
    root
    home
    tmp
    swap
    nix
  ];
}
