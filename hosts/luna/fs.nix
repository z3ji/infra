{
  order = ["root" "boot"];
  devices = {
    root.path = "/dev/sda2";
    boot = {
      path = "/dev/sda1";
      mounts = ["/boot"];
    };
  };
  subvols.root = with import ../../fs/primitives.nix; [root home tmp swap nix];
}
