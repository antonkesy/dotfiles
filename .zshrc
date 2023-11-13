[[ -r ~/.repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.repos/znap
source ~/.repos/znap/znap.zsh

znap prompt sindresorhus/pure
znap source marlonrichert/zsh-autocomplete
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'

# TODO znap autoload ros

znap install ael-code/zsh-colored-man-pages
znap install momo-lab/zsh-abbrev-alias

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Antigen
source ~/.repos/antigen/antigen.zsh
antigen init ~/.antigenrc

path+=(/bin)

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
# Haskell
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
# anaconda
# export PATH="$HOME/anaconda3/bin:$PATH"

#flatpak
export PATH="/var/lib/flatpak/exports/share:$PATH"
export PATH="$HOME/.local/share/flatpak/exports/share:$PATH"

# ALIAS
alias htop=btop
alias g="lazygit"
# alias cat="bat"
alias l="exa -la"
alias la="exa -la"
alias exa="exa -la"
# alias du="dust"
# alias find="fdfind"
# alias ps="procs -t"
alias lvim="/home/ak/.local/bin/lvim"
alias vim="lvim"
alias neovim="lvim"
alias nvim="lvim"
alias n="nvim"
# alias n.="nvim ."
alias python=python3
alias py=python
alias py3=python3
alias tilix=tilix --full-screen
# use trash-cli instead of rm
alias rm="trash-put"

# Rust
source "$HOME/.cargo/env"

# TACO
alias audissh="ssh audi@192.168.1.102"
export VISION_WEIGHT_PATH="/home/ak/workspace/taco/data/weights/best.pt"
export VISION_CLASSES_PATH="/home/ak/workspace/taco/data/classes.yaml"
alias .ros="
source /opt/ros/humble/setup.zsh
source /home/ak/workspace/taco/install/setup.zsh
source /opt/ros/humble/share/ros2cli/environment/ros2-argcomplete.zsh
source /home/ak/workspace/git/bachelor-thesis/example/install/setup.zsh
"

alias tacodev="
cd /home/ak/workspace/git/taco/
./build.sh &&
cd -
export MESA_GL_VERSION_OVERRIDE=2.0
/home/ak/.jdks/corretto-1.8.0_382/bin/java -javaagent:/home/ak/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/231.9161.38/lib/idea_rt.jar=40585:/home/ak/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/231.9161.38/bin -Dfile.encoding=UTF-8 -classpath /home/ak/.jdks/corretto-1.8.0_382/jre/lib/charsets.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/cldrdata.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/dnsns.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/jaccess.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/jfxrt.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/localedata.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/nashorn.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/sunec.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/sunjce_provider.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/sunpkcs11.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/ext/zipfs.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/jce.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/jfr.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/jfxswt.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/jsse.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/management-agent.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/resources.jar:/home/ak/.jdks/corretto-1.8.0_382/jre/lib/rt.jar:/home/ak/workspace/git/taco/vdi/vditools/target/classes:/home/ak/workspace/git/taco/autonomousDriving/base/util/target/classes:/home/ak/.m2/repository/com/google/code/gson/gson/2.9.1/gson-2.9.1.jar:/home/ak/.m2/repository/javax/usb/usb-api/1.0.2/usb-api-1.0.2.jar:/home/ak/workspace/git/taco/autonomousDriving/base/tools/target/classes:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt-main/2.3.2/gluegen-rt-main-2.3.2.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-android-aarch64.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-android-armv6.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-linux-amd64.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-linux-armv6.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-linux-armv6hf.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-linux-i586.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-macosx-universal.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-solaris-amd64.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-solaris-i586.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-windows-amd64.jar:/home/ak/.m2/repository/org/jogamp/gluegen/gluegen-rt/2.3.2/gluegen-rt-2.3.2-natives-windows-i586.jar:/home/ak/.m2/repository/com/thoughtworks/xstream/xstream/1.4.19/xstream-1.4.19.jar:/home/ak/.m2/repository/io/github/x-stream/mxparser/1.2.2/mxparser-1.2.2.jar:/home/ak/.m2/repository/xmlpull/xmlpull/1.1.3.1/xmlpull-1.1.3.1.jar:/home/ak/workspace/git/taco/autonomousDriving/base/agent/target/classes:/home/ak/workspace/git/taco/autonomousDriving/adagent/target/classes:/home/ak/.m2/repository/org/scream3r/jssc/2.8.0/jssc-2.8.0.jar:/home/ak/workspace/git/taco/autonomousDriving/adtools/target/classes:/home/ak/.m2/repository/uk/com/robust-it/cloning/1.9.12/cloning-1.9.12.jar:/home/ak/.m2/repository/org/objenesis/objenesis/3.0.1/objenesis-3.0.1.jar:/home/ak/.m2/repository/org/jfree/jfreechart/1.5.0/jfreechart-1.5.0.jar:/home/ak/workspace/git/taco/fmc/fmctools/target/classes:/home/ak/.m2/repository/de/hso/autonomy/autonomousDriving/opendrive-java-api/1.0-SNAPSHOT/opendrive-java-api-1.0-SNAPSHOT.jar:/home/ak/workspace/git/taco/fmc/fmcagent/target/classes:/home/ak/.m2/repository/edu/wpi/rail/jrosbridge/0.2.0/jrosbridge-0.2.0.jar:/home/ak/.m2/repository/org/glassfish/tyrus/tyrus-client/1.2.1/tyrus-client-1.2.1.jar:/home/ak/.m2/repository/org/glassfish/tyrus/tyrus-core/1.2.1/tyrus-core-1.2.1.jar:/home/ak/.m2/repository/org/glassfish/tyrus/tyrus-spi/1.2.1/tyrus-spi-1.2.1.jar:/home/ak/.m2/repository/javax/websocket/javax.websocket-api/1.0/javax.websocket-api-1.0.jar:/home/ak/.m2/repository/org/glassfish/tyrus/tyrus-websocket-core/1.2.1/tyrus-websocket-core-1.2.1.jar:/home/ak/.m2/repository/org/glassfish/tyrus/tyrus-container-grizzly/1.2.1/tyrus-container-grizzly-1.2.1.jar:/home/ak/.m2/repository/org/glassfish/grizzly/grizzly-framework/2.3.3/grizzly-framework-2.3.3.jar:/home/ak/.m2/repository/org/glassfish/grizzly/grizzly-http-server/2.3.3/grizzly-http-server-2.3.3.jar:/home/ak/.m2/repository/org/glassfish/grizzly/grizzly-http/2.3.3/grizzly-http-2.3.3.jar:/home/ak/.m2/repository/org/glassfish/grizzly/grizzly-rcm/2.3.3/grizzly-rcm-2.3.3.jar:/home/ak/.m2/repository/com/fasterxml/jackson/core/jackson-databind/2.9.0/jackson-databind-2.9.0.jar:/home/ak/.m2/repository/com/fasterxml/jackson/core/jackson-annotations/2.9.0/jackson-annotations-2.9.0.jar:/home/ak/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.9.0/jackson-core-2.9.0.jar:/home/ak/.m2/repository/org/glassfish/javax.json/1.0.4/javax.json-1.0.4.jar:/home/ak/.m2/repository/de/kdo/kdolib/1.0-SNAPSHOT/kdolib-1.0-SNAPSHOT.jar:/home/ak/workspace/git/taco/vdi/vdiagent/target/classes:/home/ak/.m2/repository/org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all-main/2.3.2/jogl-all-main-2.3.2.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-android-aarch64.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-android-armv6.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-linux-amd64.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-linux-armv6.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-linux-armv6hf.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-linux-i586.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-macosx-universal.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-solaris-amd64.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-solaris-i586.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-windows-amd64.jar:/home/ak/.m2/repository/org/jogamp/jogl/jogl-all/2.3.2/jogl-all-2.3.2-natives-windows-i586.jar taco.tools.developer.VDIDeveloper
"
export VISION_TACO_ROOT_PATH="/home/ak/workspace/git/taco"
# export ROS_DOMAIN_ID=73 # enable to not interfere with other ros on the same network

# Webots
export WEBOTS_HOME=/usr/local/webots
export LD_LIBRARY_PATH=$WEBOTS_HOME/lib/controller:$LD_LIBRARY_PATH

# Haskell
[ -f "/home/ak/.ghcup/env" ] && source "/home/ak/.ghcup/env" # ghcup-env

# Groot
alias groot=~/workspace/git/bachelor-thesis/example/tools/Groot/build/Groot

# Load Angular CLI autocompletion.
source <(ng completion script)

# tmux 
export EDITOR='nvim'
export VISUAL='nvim'

# create tmux main session
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
