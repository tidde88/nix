## Links
[Awesome Nix](https://github.com/nix-community/awesome-nix)

[Nix Package Search](https://search.nixos.org/packages)

[NixLang Wiki](https://nixlang.wiki/)

[https://nix.dev/](https://nix.dev/)

[Nix Starter Config](https://github.com/Misterio77/nix-starter-configs)

[NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/introduction/)


## Create Proxmox VM
copy and paste the following into a proxmox terminal and run it:

```bash
URL="https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso"
FILENAME="${URL##*/}"
LOCAL_IMAGE=/var/lib/vz/template/iso/$FILENAME
if [[ ! -f $LOCAL_IMAGE ]]; then 
   echo "downloading nixos iso..."
   curl -s $URL > $LOCAL_IMAGE
fi

if [[ $(qm list | grep -v grep | grep -ci ${VM_ID:-8000}) > 0 ]]; then
  qm stop ${VM_ID:-8000} --skiplock && qm destroy ${VM_ID:-8000} --destroy-unreferenced-disks --purge
fi
qm create ${VM_ID:-8000} --name nixos-23.11 --memory 2048 --cores 4 --cpu cputype=host
qm set ${VM_ID:-8000} --agent 1 --machine q35 --ostype l26 --onboot 1 --scsihw virtio-scsi-pci 
qm set ${VM_ID:-8000} --net0 virtio,bridge=vmbr0 --ipconfig0 ip=dhcp
# media=cdrom is SUPER important to boot order, DO NOT remove it or your life will be pain!
qm set ${VM_ID:-8000} --scsi0 ${VM_STORAGE:-local-lvm}:32 --ide2 local:iso/$FILENAME,media=cdrom
qm set ${VM_ID:-8000} --bios ovmf --boot order='scsi0;ide2' --efidisk0 ${VM_STORAGE:-local-lvm}:0,pre-enrolled-keys=0,efitype=4m,size=528K 

```

## Go to the VM console
Run the following two commands in the VM console (you'll have to type them in, since you can't copy and paste in the console)
```bash
# install curl

nix-shell -p curl

# https://t.ly/_c10E redirects to https://raw.githubusercontent.com/ilude/nix/main/setup.sh
# download file and save as setup

curl -Ls https://t.ly/_c10E > setup && bash setup

```

- You will be prompted to provide a password for the default user 'anvil'.
- Followed by two prompts to set the root password.
- Nix will then build the system and you will be prompted to reboot. 

### After reboot
```bash
# edit configuration as you like
sudo nano /etc/nixos/configuration.nix

# apply configuration changes
sudo nixos-rebuild switch
```


