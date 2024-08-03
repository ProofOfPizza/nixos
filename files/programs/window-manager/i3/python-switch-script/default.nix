
# Below, we can supply defaults for the function arguments to make the script
# runnable with `nix-build` without having to supply arguments manually.
# Also, this lets me build with Python 3.7 by default, but makes it easy
# to change the python version for customised builds (e.g. testing).
{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python38Packages }:

let
  # This takes all Nix packages into this scope
  inherit (nixpkgs) pkgs;
  # This takes all Python packages from the selected version into this scope.
  inherit pythonPkgs;

  # Inject dependencies into the build function
#  f = { buildPythonPackage, bottle, requests }:
#    buildPythonPackage rec {
  f = { }:
      pkgs.stdenv.mkDerivation rec {
      pname = "i3switch";
      version = "0.0.1";

      # If you have your sources locally, you can specify a path
      #src = /home/chai/code/py/sw.py;

      # Pull source from a Git server. Optionally select a specific `ref` (e.g. branch),
      # or `rev` revision hash.
#      src = builtins.fetchGit {
#        url = "git://github.com/stigok/ruterstop.git";
#        ref = "master";
#        #rev = "a9a4cd60e609ed3471b4b8fac8958d009053260d";
#      };

  buildInputs = [
    (pkgs.python38.withPackages (pythonPackages: with pythonPackages; [
      consul
      six
      i3-py
    ]))
  ];
      # Specify runtime dependencies for the package
      propagatedBuildInputs = [ pythonPkgs.i3-py ];

      # If no `checkPhase` is specified, `python setup.py test` is executed
      # by default as long as `doCheck` is true (the default).
      # I want to run my tests in a different way:
#      checkPhase = ''
#        python -m unittest tests/*.py
#      '';
      unpackPhase = ":";
      installPhase = "install -m755 -D ${./i3switch.py} $out/bin/i3switch";
      # Meta information for the package
      doCheck = false;
      meta = {
        description = ''
          script for switching workspaces  around on more monitors... you ever know whatcha gonna  get
        '';
      };
    };

  drv = pythonPkgs.callPackage f {};
in
  if pkgs.lib.inNixShell then drv.env else drv
