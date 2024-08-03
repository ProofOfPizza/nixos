
{
  adab="cd ~/code/projects/adabtive && r";
  cc="rm -rf ~/.config/Cypress";
  cfb = "vim ~/.bashrc";
  cfi = "vim ~/.config/nixpkgs/program/window-manager/i3/config";
  cfv = "vim ~/.config/nixpkgs/program/editor/neovim/default.nix";
  cfx = "vim ~/.Xresources";
  cfz = "vim ~/.config/nixpkgs/program/shell/zsh/default.nix";
  conflicts = "git diff --name-only --diff-filter=U";
  die = "pkill -i $1 -f -e";
  dstop = "docker stop $(docker ps -q); docker rm --force $(docker ps -a -q); docker system prune -af --volumes";
  dstopz = "docker stop $(docker ps -q); docker rm --force $(docker ps -a -q);";
  fzfi = "rg --files --hidden --follow --no-ignore-vcs -g '!{node_modules,.git}' | fzf";
  gd = "cd ~/Downloads && r";
  gdev = "cd ~/code/projects && r";
  gf = "cd ~/code/Consular.Kairos.Frontend/src/Portals/kairos && r";
  gh = "cd ~ && r";
  gn = "cd ~/Nextcloud/Documents && r";
  kk = "kill -9 $(pgrep KeeWeb)";
  kswp = "cd ~/.local/state/nvim/swap && rm *.* && ls -a";
  nixos-rb ="sudo nixos-rebuild switch -I nixos-config=/home/chai/.config/nixpkgs/system/configuration.nix";
  nx = "~/.config/nixpkgs";
  nxo = "nx && o";
  nxr = "nx && r";
  o = "x=$(fzfi); if [[ ! -z $x ]]; then vim $x; fi";
  r = "vicd ./";
  p = "~/code/try-outs && python";
  reboot = "dstop && shutdown -r now";
  swp = "cd ~/.local/state/nvim/swap && ls -a";
  trash = "cd ~/.local/share/Trash && r";
  try = "~/code/try-outs && r";
  vtrash = "cd ~/.local/share/vifm/Trash && r";
  vimii = "x='/home/chai/.vim/pack/coc/start'; if [ ! -d '$x' ]; then mkdir -p $x && cd $x && git clone 'git@github.com:neoclide/coc.nvim.git'; fi; echo 'check je vim alias voor coc bs' && nvim";
  x = "exit";
  xc = "xclip_in";
}
