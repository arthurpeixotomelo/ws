# run this script
# nu --no-config-file
# git clone https://github.com/arthurpeixotomelo/ws.git; nu /ws/config/setup.nu`

# preinstallation packages
# git base-devel flatpack xdg-desktop-portal-cosmic pass ffmpeg openrgb solaar uv deno nushell starship github-cli nerdctl containerd steam blender obs-studio

# save xdg global environment vars
["XDG_CONFIG_HOME=/ws/config", "XDG_DATA_HOME=/ws/config/data"] | str join (char nl) | save -a /etc/environment

# set nu as default shell
"/usr/bin/nu" | save -a /etc/shells
chsh -s /usr/bin/nu

# install paru (AUR helper) and then install AUR packages
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru; makepkg -si --noconfirm
rm -rp /tmp/paru
paru -S --noconfirm microsoft-edge-stable-bin waveterm-bin visual-studio-code-bin carapace-bin ollama

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
