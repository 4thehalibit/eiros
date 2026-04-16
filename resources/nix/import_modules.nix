# Recursively collects all public .nix files under a given directory, skipping dot/underscore-prefixed entries.
dir:
let
  inherit (builtins)
    attrNames
    concatLists
    match
    readDir
    sort
    ;

  is_private = name: match "^[._].*" name != null;

  sorted_public_names =
    entries: sort (a: b: a < b) (builtins.filter (n: !is_private n) (attrNames entries));

  collect_imports =
    rel_path:
    let
      full_path = if rel_path == "" then dir else dir + "/${rel_path}";

      entries = readDir full_path;

      process_entry =
        name:
        let
          sub_rel_path = if rel_path == "" then name else "${rel_path}/${name}";

          entry_path = dir + "/${sub_rel_path}";
          entry_type = entries.${name};
        in
        if entry_type == "directory" then
          collect_imports sub_rel_path
        else if entry_type == "regular" && match ".*\\.nix" name != null then
          [ (import entry_path) ]
        else
          [ ];
    in
    concatLists (map process_entry (sorted_public_names entries));
in
collect_imports ""
