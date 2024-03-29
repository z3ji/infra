{
  # Order of device mounting
  order = ["root" "boot"];

  # Device configurations
  devices = {
    root.path = "/dev/mapper/root";
    boot = {
      path = "/dev/nvme0n1p1";
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
