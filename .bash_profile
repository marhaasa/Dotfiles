# only run on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
	# needed for brew
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi >/dev/null 2>&1

# Only run these on Ubuntu and Fedora

if [[ $(grep -E "^(ID|NAME)=" /etc/os-release | grep -Eq "ubuntu|fedora")$? == 0 ]]; then
	# needed for brew to work
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi >/dev/null 2>&1

# source .bashrc
if [ -r ~/.bashrc ]; then
	source ~/.bashrc
fi

export XDG_CONFIG_HOME="$HOME"/.config

set -o vi
# FLYTTET OG FORENKLET TIL .baschrc
#export BASH_SILENCE_DEPRECATION_WARNING=1
#PATH="/mariushogliaasarod/local/bin:$PATH"
#export PATH=/opt/homebrew/bin:$PATH
#export PATH=/opt/homebrew/bin:/mariushogliaasarod/local/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/:/usr/bin/python3
#export PATH=$PATH:~/scripts
#export PATH="/usr/local/share/dotnet/:$PATH"
