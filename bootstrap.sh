#!/usr/bin/env bash

# Inspired by https://gist.github.com/OleksandrKucherenko/e76220f22359e0e49c81c5474b1457a1

set -x # uncomment to debug


########################################################
# Phase 1: Homebrew
########################################################
# required for Homebrew
xcode-select —-install
# install https://brew.sh/
which brew || (/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" )

# add brew to PATH
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# install latest bash
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
  brew install bash
else
  echo "[info] detected BASH version: ${BASH_VERSION}"
fi

# install ZSH
which zsh || (brew install zsh)
# ZSH Plugins: https://github.com/zdharma-continuum/zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# A fast, cross-platform build tool inspired by Make, designed for modern workflows.
brew install "go-task/tap/go-task"

# install ghostty terminal
brew install --cask ghostty
# Cross-shell prompt instead of oh-my-zsh + powerlevel10k
which starship || brew install starship

# install latest GIT
brew install git # GitHub command-line tool
brew install git-lfs
brew install gh
brew install git-delta # Syntax-highlighting pager for git and diff output

########################################################
# Phase 2: Clone dotfiles
########################################################
# Clone dotfiles
git clone --depth=1 https://github.com/keidarcy/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install dotfiles
./install.sh
########################################################

########################################################
# Define XDG path specifications
########################################################

export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/projects}
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"


# install oh-my-zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ZSH fast-syntax-highlighting (this one is not working)
# git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# or ZSH zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# ZSH autosuggestions, https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# ZSH zsh-completions, https://github.com/zsh-users/zsh-completions/
# git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# ZSH powerlevel10k, https://github.com/romkatv/powerlevel10k#oh-my-zsh
#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Set ZSH_THEME=powerlevel10k/powerlevel10k in ~/.zshrc.

# make ZSH default shell
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

# install powerline fonts (https://github.com/powerline/fonts/#quick-installation)
mkdir ~/workspace
git clone https://github.com/powerline/fonts.git --depth=1 ~/workspace/fonts
~/workspace/fonts/install.sh

# Fuzzy search
# https://github.com/junegunn/fzf
which fzf || (brew install fzf)
$(brew --prefix)/opt/fzf/install

# show file system as tree in terminal
which tree || (brew install tree)

# `cat` replacer 
which bat || (brew install bat)

# expect, simualte user input in scripts
which expect || (brew install expect)

# RIP grep
which rg || (brew install ripgrep)

## https://formulae.brew.sh/formula/midnight-commander
# which mcedit || (brew install midnight-commander)

# https://github.com/tldr-pages/tldr
which tldr || (brew install tldr)

# Log file highlighter
which tailspin || (brew --install tailspin)

# https://formulae.brew.sh/formula/htop
which htop || (brew install htop)

which eza || (brew install eza)

which lsd || (brew install lsd)

which neovim || (brew install neovim)

# https://formulae.brew.sh/formula/tmux
which tmux || (brew install tmux)
# https://github.com/jrmoulton/tmux-sessionizer
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/jrmoulton/tmux-sessionizer/releases/download/v0.4.2/tmux-sessionizer-installer.sh | sh

# JSON, https://formulae.brew.sh/formula/jq
which jq || (brew install jq)

# Yaml, https://github.com/mikefarah/yq
which yq || (brew install yq)

# https://formulae.brew.sh/formula/watchman - watch files and record when they actually change. It can also trigger actions
which watchman || (brew install watchman)

# https://formulae.brew.sh/formula/watch, https://www.geeksforgeeks.org/watch-command-in-linux-with-examples/
which watch || (brew install watch)

# PipeViewer, https://www.ivarch.com/programs/pv.shtml # terminal-based tool for monitoring the progress of data through a pipeline
which pv || (brew install pv)

# Gnu-Sed, https://www.gnu.org/software/sed/
which gsed || (brew install gsed)

# https://command-not-found.com/whiptail - Display text-based dialog boxes from shell scripts
brew install newt

# instal NVM 
which nvm || (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash)
nvm install --lts
nvm use --lts

# install YVM
#which yvm || (brew install tophat/bar/yvm)
which yvm || (curl -s https://raw.githubusercontent.com/tophat/yvm/master/scripts/install.js | node)
yvm list-remote

# install direnv
which direnv || (curl -sfL https://direnv.net/install.sh | bash)
direnv allow

# install RVM, https://rvm.io/rvm/install
# which rvm || (curl -sSL https://get.rvm.io | bash -s stable --ruby)

# install LastPass
# brew install --cask lastpass

# install Bitwarden CLI
# npm install -g @bitwarden/cli
brew install bitwarden-cli

# # diff tools
# brew install --cask p4v 

# # p4merge, as GIT default merge tool... https://gist.github.com/tony4d/3454372
# git config --global merge.tool p4mergetool
# git config --global mergetool.p4mergetool.cmd "/Applications/p4merge.app/Contents/Resources/launchp4merge \$PWD/\$BASE \$PWD/\$REMOTE \$PWD/\$LOCAL \$PWD/\$MERGED"
# git config --global mergetool.p4mergetool.trustExitCode false
# git config --global mergetool.keepBackup false

#brew install kdiff3

# GIT UI
brew install --cask fork

# install messangers
brew install --cask slack telegram

# install alternative browser
# brew install --cask google-chrome
brew install --cask brave-browser
# Extensions:
# Bitwarden: https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb
# LanguageTool: https://chrome.google.com/webstore/detail/grammar-and-spell-checker/oldceeleldhonbafppcapldpdifcinji?hl=en-GB
# Grammarly: https://chrome.google.com/webstore/detail/grammarly-for-chrome/kbfnbcaeplbcioakkpcpgfkobkghlhen?hl=en-GB
# ImTranslator: https://chrome.google.com/webstore/detail/imtranslator-translator-d/noaijdpnepcgjemiklgfkcfbkokogabh?hl=en-GB
# AdsBlock: https://getadblock.com/

#brew install --cask firefox
#/Applications/Firefox.app/Contents/MacOS/firefox https://addons.mozilla.org/en-US/firefox/addon/lastpass-password-manager/ & 

# https://github.com/AdoptOpenJDK/homebrew-openjdk
#brew tap AdoptOpenJDK/openjdk
#brew install --cask adoptopenjdk11

# install extra fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew tap colindean/fonts-nonfree
brew install --cask font-microsoft-office

# install vscode
brew install --cask visual-studio-code

# install TextMate, https://formulae.brew.sh/cask/textmate
#brew install --cask textmate

# Sublime, https://formulae.brew.sh/cask/sublime-text
brew install --cask sublime-text

# Anydesk, https://formulae.brew.sh/cask/anydesk - Access any device at any time. From anywhere. Always secure and fast.
#brew install --cask anydesk

# cyberduck, https://cyberduck.io/ - libre server and cloud storage browser with support for FTP, SFTP, 
# WebDAV, Amazon S3, OpenStack Swift, Backblaze B2,
# Microsoft Azure & OneDrive, Google Drive and Dropbox.
#brew install --cask cyberduck

# XnConvert, https://www.xnview.com/en/xnconvert/
brew install --cask xnconvert

# Clipy (clipboard manager), https://clipy-app.com/
# brew install --cask clipy
# Maccy (clipboard manager), https://maccy.app/
brew install --cask maccy
# Jumpcut (clipboard manager), https://snark.github.io/jumpcut/
# brew install --cask jumpcut

# trolCommander, https://trolsoft.ru/en/soft/trolcommander
# brew install --cask trolcommander

# Kap (Capture your screen), https://getkap.co/
brew install --cask kap

# Keka (macOS file archiver), www.keka.io
brew install --cask keka

# Be Focused, https://xwavesoft.com/be-focused-pro-for-iphone-ipad-mac-os-x.html

# Windows manager
# AltTab, https://github.com/lwouis/alt-tab-macos
brew install  --cask alt-tab
# Rectangle, https://rectangleapp.com/
brew install --cask rectangle
# Magnet, https://magnet.crowdcafe.com/index.html
# Penc, Trackpad-oriented window manager, https://deniz.co/penc/
# brew install --cask penc
# Divvy, https://mizage.com/divvy/
# brew install --cask divvy

# Calendar, Time, https://www.mowglii.com/itsycal/
# Use pattern: E | 'w'ww | d MMM, HH:mm:ss
# brew install --cask itsycal

# Hex Fiend, https://ridiculousfish.com/hexfiend/, https://formulae.brew.sh/cask/hex-fiend
# brew install --cask hex-fiend

# https://github.com/zsh-users/zsh-completions

# Android Logcat 
# brew install pidcat

# Android Screen Copy tool, https://formulae.brew.sh/formula/scrcpy
# brew instal scrcpy

# Screensaver
# https://fliqlo.com/#/screensaver
# brew install --cask fliqlo

# Markdown editor, https://macdown.uranusjr.com/
# brew install --cask macdown

# https://objective-see.com/products/knockknock.html
# brew install --cask knockknock

#brew install --cask docker # can be substituted by colima
brew install colima
# Start colima for M2 processors
# colima start --cpu 4 --memory 12 --disk 100 --vz-rosetta


# To make docker working in M2
echo 'export DOCKER_DEFAULT_PLATFORM=linux/amd64' >> ~/.zshenv

# DuckDB
# https://github.com/duckdb/duckdb , https://duckdb.org/
brew install duckdb

# yazy
# https://yazi-rs.github.io/features
brew install font-hack-nerd-font
brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# Collaboration platform for API development
brew install --cask postman


# LazyGit
# https://github.com/jesseduffield/lazygit/
brew install lazygit
# https://github.com/jesseduffield/lazydocker
brew install lazydocker

# A simple terminal UI for managing SSH connections.
brew install "adembc/tap/lazyssh"

# AWS 
brew install awscli
brew install aws-cdk
# AWS Session Manager Plugin
brew install --cask session-manager-plugin

# Install vscode extentions
# code --install-extension 4ops.terraform
code --install-extension alexkrechik.cucumberautocomplete
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension anthropic.claude-code
code --install-extension astral-sh.ty
code --install-extension aykutsarac.jsoncrack-vscode
code --install-extension charliermarsh.ruff
code --install-extension donjayamanne.python-environment-manager
code --install-extension eamodio.gitlens
code --install-extension editorconfig.editorconfig
code --install-extension emilijanmb.sublime-text-4-theme
code --install-extension esbenp.prettier-vscode
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension github.vscode-github-actions
code --install-extension innoverio.vscode-dbt-power-user
# code --install-extension hashicorp.terraform
code --install-extension jithurjacob.nbpreviewer
code --install-extension kevinrose.vsc-python-indent
code --install-extension mechatroner.rainbow-csv
code --install-extension mikestead.dotenv
# code --install-extension monokai.theme-monokai-pro-vscode
code --install-extension ms-azuretools.vscode-containers
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-python.debugpy
code --install-extension ms-python.isort
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-toolsai.datawrangler
code --install-extension ms-toolsai.jupyter
code --install-extension ms-toolsai.jupyter-keymap
code --install-extension ms-toolsai.jupyter-renderers
code --install-extension ms-toolsai.vscode-jupyter-cell-tags
code --install-extension ms-toolsai.vscode-jupyter-slideshow
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode.makefile-tools
code --install-extension ms-vscode.powershell
# code --install-extension ms-vscode.sublime-keybindings
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension oderwat.indent-rainbow
code --install-extension pkief.material-icon-theme
code --install-extension redhat.vscode-xml
code --install-extension redhat.vscode-yaml

code --install-extension ryu1kn.partial-diff
code --install-extension samuelcolvin.jinjahtml
code --install-extension sanjulaganepola.github-local-actions
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension sqlfluff.vscode-sqlfluff
code --install-extension streetsidesoftware.avro
code --install-extension tamasfe.even-better-toml
code --install-extension task.vscode-task
# code --install-extension taoklerks.poor-mans-t-sql-formatter-vscode
code --install-extension timonwong.shellcheck
code --install-extension visualstudioexptteam.intellicode-api-usage-examples
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension wayou.vscode-todo-highlight
code --install-extension yzhang.markdown-all-in-one

# manual actions
echo '
plugins=(git aws common-aliases macos npm direnv colored-man-pages colorize pip python brew zsh-autosuggestions compleat zsh-syntax-highlighting zsh-completions)
'
# .zshrc
echo '# important to run later `source $ZSH/oh-my-zsh.sh` line
+ autoload -U compinit && compinit
'

# .zshrc
# start yazi by typing 'y'
echo 'function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
'

# Set ZSH_THEME=powerlevel10k/powerlevel10k in ~/.zshrc.

# Minimize the Dock Size
defaults write com.apple.dock tilesize -int 50
# Enable Auto-Hide
defaults write com.apple.dock autohide -bool true
# Move the Dock to the Left
defaults write com.apple.dock orientation -string "left"
# Apply the Changes
killall Dock


# https://github.com/cnstntn-kndrtv/open-in-buttons-for-finder-toolbar

# Finder: Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# Finder: Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Activity Monitor: Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Disable annoying sound when fully charged
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true; killall PowerChime

# Temperature monitoring: https://beebom.com/how-check-cpu-temperature-mac/, https://fannywidget.com/
brew install fanny

# Enable TouchID for terminal SUDO
# https://dev.to/equiman/how-to-use-macos-s-touch-id-on-terminal-5fhg
# https://unix.stackexchange.com/questions/99350/how-to-insert-text-before-the-first-line-of-a-file
sudo gsed -i '1i auth    sufficient     pam_tid.so' /etc/pam.d/sudo

# Configure environment ~/.zshrc
# https://www.appsdeveloperblog.com/how-to-set-java_home-on-mac/
#
# List available: `/usr/libexec/java_home -V`
#
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ANDROID_HOME=/usr/local/opt/android
export GRADLE_USER_HOME=/usr/local/opt/.gradle
export M2_HOME=/usr/local/opt/.m2

# run in terminal 
launchctl setenv JAVA_HOME $JAVA_HOME
launchctl setenv GRADLE_USER_HOME $GRADLE_USER_HOME
launchctl setenv M2_HOME $M2_HOME
launchctl setenv ANDROID_HOME $ANDROID_HOME