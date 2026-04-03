lib:
let
  to_non_empty_list =
    v:
    let
      list = if lib.isList v then v else [ v ];
    in
    lib.filter (s: s != "") (map toString list);

  render_kv_lines =
    kv:
    let
      pairs = lib.concatLists (
        lib.mapAttrsToList (
          k: v:
          let
            values = to_non_empty_list v;
          in
          map (vv: "${k} = ${vv}") values
        ) kv
      );
    in
    lib.concatStringsSep "\n" pairs;

  indent_lines = s: lib.concatStringsSep "\n" (map (l: "  " + l) (lib.splitString "\n" s));

  render_section =
    section_name: kv:
    let
      body = render_kv_lines kv;
    in
    if body == "" then
      ""
    else if section_name == "" then
      body
    else
      ''
        ${section_name} {
        ${indent_lines body}
        }
      '';
in
sections:
lib.concatStringsSep "\n\n" (lib.filter (s: s != "") (lib.mapAttrsToList render_section sections))
