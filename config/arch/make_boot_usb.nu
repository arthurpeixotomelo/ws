def main [device: string] {
    http get https://mirrors.ic.unicamp.br/archlinux/iso/latest/archlinux-x86_64.iso | save -fp arch.iso
    dd if=arch.iso of=$"/dev/($device)" bs=4M status=progress oflag=sync; sync
}