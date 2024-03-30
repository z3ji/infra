self: super: {
  util = rec {
    # Function to get directory entries
    dirEntries = path: builtins.attrNames (builtins.readDir path);

    # Function to map over hosts directories
    mapHosts = f: builtins.map f (dirEntries ../hosts);

    # Function to map over hosts attributes
    mapHostAttrs = key_f: val_f:
      builtins.listToAttrs (mapHosts (host: {
        name = key_f host;
        value = val_f host;
      }));

    # Function to map over object keys
    mapObjKeys = obj: f: builtins.map f (builtins.attrNames obj);

    # Function to map over keys of a list
    mapKeys = obj: f: builtins.map f obj;

    # Function to filter Nix files in a directory and import them
    nixFilesIn = path:
      builtins.map
      (e: import (path + /${e}))
      (builtins.filter (x: (builtins.match ".*\\.nix$" x) != null) (dirEntries path));

    # Function to filter out exclusions from a list
    without = exclusions: list: builtins.filter (x: !builtins.elem x exclusions) list;
  };
}
