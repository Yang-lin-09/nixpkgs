{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotools";
  version = "0.7.0";

  # using GitHub instead of https://go.googlesource.com/tools because Gitiles UI is to basic to browse
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    # The gopls folder contains a Go submodule which causes a build failure
    # and lives in its own package named gopls.
    postFetch = ''
      rm -r $out/gopls
    '';
    sha256 = "sha256-6Sdo6oKJHYXWkvJmbte7Wc7tov5AHzn70Bi1QdQ5HR4=";
  };

  vendorSha256 = "sha256-fp0pb3EcGRDWlSpgel4pYRdsPJGk8/d57EjWJ+fzq7g=";

  doCheck = false;

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $out/nix-support
    substitute ${./setup-hook.sh} $out/nix-support/setup-hook \
      --subst-var-by bin $out
  '';

  meta = with lib; {
    description = "Additional tools for Go development";
    longDescription = ''
      This package contains tools like: godoc, goimports, callgraph, digraph, stringer or toolstash.
    '';
    homepage = "https://go.googlesource.com/tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson SuperSandro2000 ];
  };
}
