with import <nixpkgs> {};
with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "grip";
  version = "";
  # name = "mypackage";
  src = fetchFromGitHub{
    owner = "joeyespo";
    repo = pname;
    rev = "";
    sha256 = "0hphplnyi903jx7ghfxplg1qlj2kpcav1frr2js7p45pbh5ib9rm";
  };
  buildInputs = [ pip ];
  propagatedBuildInputs = [ pip pytest numpy pkgs.libsndfile ];
}
