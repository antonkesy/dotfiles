# prefix + * to kill the running process in a pane. Not in nixpkgs.
{ tmuxPlugins, fetchFromGitHub }:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "cowboy";
  version = "0-unstable-2021-05-11";
  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-cowboy";
    rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
    hash = "sha256-KJNsdDLqT2Uzc25U4GLSB2O1SA/PThmDj9Aej5XjmJs=";
  };
}
