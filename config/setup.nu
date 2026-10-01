# save xdg env vars
["", $"export XDG_CONFIG_HOME=($env.HOME)/ws/config", $"export XDG_DATA_HOME=($env.HOME)/ws/config/data"] | str join (char nl) | save -a .bashrc
mkdir ~/.local/share/applications/ | cp /usr/share/applications/org.wezfurlong.wezterm.desktop ~/.local/share/applications/
open .local/share/applications/org.wezfurlong.wezterm.desktop | str replace -a "wezterm start" "env XDG_CONFIG_HOME=/home/arthy/ws/config wezterm start" | save -f .local/share/applications/org.wezfurlong.wezterm.desktop

# install paru (AUR helper) and then install AUR packages
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru; makepkg -si --noconfirm
cd /home/arthy; rm -rp /tmp/paru
paru -S --noconfirm microsoft-edge-stable-bin visual-studio-code-bin carapace-bin openlogi-bin

# setup gpg and pass 
r#'
Key-Type: RSA
Key-Length: 4096
Name-Real: Arthur Peixoto Melo
Name-Email: arthurpeixotomelo@gmail.com
Expire-Date: 0
'# | gpg --batch --yes --pinentry-mode loopback --passphrase '' --full-generate-key
gpg --list-secret-keys
pass init (gpg --list-secret-keys | lines | get 3 | str trim)
pass insert user
