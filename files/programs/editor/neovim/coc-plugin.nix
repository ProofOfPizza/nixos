{ pkgs, fetchFromGitHub }:

pkgs.vimUtils.buildVimPlugin {
  pname = "coc-nvim";
  version = "v0.82";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "v0.0.82";
    sha256 = "TIkx/Sp9jnRd+3jokab91S5Mb3JV8yyz3wy7+UAd0A0=";
  };
}

    # rev = "b28b8dc4278f0c68f14b74609d73169c88c97ec4";
    # sha256 = "Btj7crJo0zk8/uF/RXtbGOiD3fQxzxKwmK+mMhf2s0I=";

    # rev = "578d2e348a15d9e0d653f3c4859eb65c74ce9c5e";
    # sha256 =   "pcnNAL7JLXlkm9MemCDJ8tNESZAxYq09fyUpSOa1FzQ=";
    # sha256 =     "0000000000000000000000000000000000000000000=";
    #installPhase = "yarn install";
