_: {
  nix = {
    linux-builder.enable = true;
    settings.trusted-users = ["root" "cass"];
  };
}
