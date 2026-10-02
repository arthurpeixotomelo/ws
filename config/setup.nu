const sys_app_dir = "/usr/share/applications/"
const xdg_config_dir = "/home/arthy/ws/config/"
const autostart_dir = "/home/arthy/.config/autostart/"
const user_app_dir = "/home/arthy/.local/share/applications/"

# save xdg env vars
["", $"export XDG_CONFIG_HOME=($xdg_config_dir)"] | str join (char nl) | save -a .bashrc

# set git global conf
git config --global user.email "arthurpeixotomelo@gmail.com" | git config --global user.name "Arthur Peixoto Melo" | git config --global init.defaultBranch main

# app overrides
sys tailscale configure systray --enable-startup=systemd | systemctl --user daemon-reload
mkdir autostart_dir user_app_dir
cp /etc/xdg/autostart/nm-applet.desktop autostart_dir
"Hidden=true" | save -a $"($autostart_dir)nm-applet.desktop"
cp $"($sys_app_dir)org.wezfurlong.wezterm.desktop" $"($sys_app_dir)microsoft-edge.desktop" user_app_dir
$"($user_app_dir)org.wezfurlong.wezterm.desktop" | do {
    let file = $in
    open $file | str replace "wezterm start" $"env XDG_CONFIG_HOME=($xdg_config_dir) wezterm start" | save -f $file
}
$"($user_app_dir)microsoft-edge.desktop" | do {
    let file = $in
    open $file | str replace "/usr/bin/microsoft-edge-stable --inprivate" "env XDG_CONFIG_HOME=/home/arthy/.config /usr/bin/microsoft-edge-stable --inprivate" | save -f $file
}
update-desktop-database ($user_app_dir | str replace -r "/$" "")

# install paru (AUR helper) and then install AUR packages
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru; makepkg -si --noconfirm
cd /home/arthy; rm -rp /tmp/paru
paru -S --noconfirm microsoft-edge-stable-bin visual-studio-code-bin carapace-bin openlogi-bin rustdesk-bin

# uninstall unused packages
^sudo pacman --noconfirm -Rns vim
pacman -Qdtq | ^sudo pacman --noconfirm -Rns -

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
