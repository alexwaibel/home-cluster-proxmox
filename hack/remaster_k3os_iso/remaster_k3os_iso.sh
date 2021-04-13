#!/bin/bash
# Ubuntu: apt install grub-efi grub-pc-bin mtools xorriso
# CentOS: dnf install grub2-efi grub2-pc mtools xorriso
# Alpine: apk add grub-bios grub-efi mtools xorriso
K3OS_RELEASE_URL="https://github.com/rancher/k3os/releases/latest/download/k3os-amd64.iso"
K3OS_FILENAME="k3os-amd64.iso"
K3OS_REMASTERED_FILENAME="k3os-custom.iso"

main () {
    echo -e "Downloading latest k3os ISO"

    TEMP_DIR=$(mktemp -d)

    wget -q --show-progress "$K3OS_RELEASE_URL" -O "$TEMP_DIR"/"$K3OS_FILENAME"

    if [[ ! -f "$TEMP_DIR"/"$K3OS_FILENAME" ]]; then
        echo -e "Download failed"
        exit 1
    fi

    create_iso "$TEMP_DIR"

    rm -R "$TEMP_DIR"
}

create_iso () {
    echo -e "Remastering ISO file"

    TEMP_MOUNT_DIR=$(< /dev/urandom tr -cd 'a-f0-9' | head -c 16)
    mkdir -p /mnt/"$TEMP_MOUNT_DIR"
    sudo mount -o loop "$1"/"$K3OS_FILENAME" /mnt/"$TEMP_MOUNT_DIR"

    TEMP_OUT_DIR=$(mktemp -d)
    CURRENT_DIR="$(dirname "$(which "$0")")"

    cp -fr /mnt/"$TEMP_MOUNT_DIR"/k3os "$TEMP_OUT_DIR"
    sudo cp -f "$CURRENT_DIR"/config.yaml "$TEMP_OUT_DIR"/k3os/system/config.yaml
    mkdir -p "$TEMP_OUT_DIR"/boot/grub
    cp -f "$CURRENT_DIR"/grub.cfg "$TEMP_OUT_DIR"/boot/grub/grub.cfg

    grub-mkrescue -o "$K3OS_REMASTERED_FILENAME" "$TEMP_OUT_DIR" -- -volid K3OS
    sudo umount /mnt/"$TEMP_MOUNT_DIR"
    rm -R /mnt/"${TEMP_MOUNT_DIR:?}"

    if [[ ! -f ./${K3OS_REMASTERED_FILENAME} ]]; then
        echo -e "Failed to create remastered ISO."
        exit 1
    fi

    echo -e "Remastered k3os ISO file ${K3OS_REMASTERED_FILENAME} successfully created."
}

main "$@"; exit
