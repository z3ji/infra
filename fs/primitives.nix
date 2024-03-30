{
  # Subvolume configurations
  root = {
    name = "@root";
    purpose = "This subvolume serves as the root filesystem.";
    backup = "Local only";
    mount = "/";
    additional_mounts = ["/_state"];
    compress = "zstd";
  };
  home = {
    name = "@home";
    purpose = "Subvolume for user home directories.";
    backup = "Often";
    mount = "/home";
    compress = "zstd";
  };
  tmp = {
    name = "@tmp";
    purpose = "Subvolume for temporary files.";
    backup = "None";
    mount = "/tmp";
    compress = "zstd";
  };
  swap = {
    name = "@swap";
    purpose = "Subvolume for swap space.";
    backup = "None";
    mount = "/swap";
    compress = "no";
  };
  nix = {
    name = "@nix";
    purpose = "Location for the Nix store.";
    backup = "None";
    mount = "/nix";
    compress = "zstd";
  };
}
