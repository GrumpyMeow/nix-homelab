# Commons NixOS installation

Boot from NixOS live cd

```
##########################################################
# From NixOS LiveCD installation
##########################################################

sudo -i

# [Optional] Change keymap
# loadkeys fr
# [Optional[ Default keymap
# loadkeys --default

# Change root password
passwd
  > <password>  (This password needs to be provided to connect via SSH)

# [Optional] WI-FI to allow other computer to connect
systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "ssid_name"
set_network 0 psk "password"
enable_network 0

# Get LiveCD nixos installation IP
ip a
    > This IP will be used as TARGETIP
hostname
    > This hostname will be used TARGETHOME

##########################################################
# From other computer with NIX-installed, enter to deploy environment
##########################################################

# Git clone yout nix-homelab repo
git clone https://github.com/GrumpyMeow/nix-homelab
cd nix-homelab 

# NOTE: Use <SPACE> before command for not storing command in bash history (for secure your passwords)
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
export TARGETIP=<hostip>
export TARGETNAME=<hostname>

# [Optional] Generate private key
ssh-keygen
   > Enter
   > Enter
   > Enter

ssh-copy-id root@${TARGETIP}
   > Fingerprint: Yes
   > Password: Root password as provided in step above

# Disk initialisation (some examples)
inv init.disk-format --hosts ${TARGETIP} --disk /dev/sda --mirror /dev/sdb --mode MBR --password <PASSWORD> # encrypt ZFS
inv init.disk-format --hosts ${TARGETIP} --disk /dev/sda --mirror /dev/sdb --mode MBR
inv init.disk-format --hosts ${TARGETIP} --disk /dev/nvme0n1  --mode EFI
inv init.disk-format --hosts ${TARGETIP} --disk /dev/sda  --mode EFI
or mount existing
inv init.disk-mount --hosts ${TARGETIP} --password "<zfspassword>" [--mirror /dev/sdb]


inv init.ssh-init-host-key --hosts ${TARGETIP} --hostnames ${TARGETNAME}
inv init.nixos-generate-config --hosts ${TARGETIP} --hostnames ${TARGETNAME}

# Add hosts/${TARGETNAME}/ssh-to-age.txt in &hosts section in the .sops.yaml file
echo "Add to (hidden) .sops.yaml file: &"${TARGETNAME} $(cat hosts/${TARGETNAME}/ssh-to-age.txt)
nano .sops.yaml
#  - path_regex: hosts/nixos/${TARGETNAME}.yml$
#    key_groups:
#      - age:
#        - *${TARGETNAME} ?

# Add root password key to ./hosts/${TARGETNAME}/secrets.yml (replace yourpassword with given root-password )
echo '<yourpassword>' | mkpasswd -m sha-512 -s
#system:
#    user:
#        root-hash: <generated hash>
nano ./hosts/${TARGETNAME}/secrets.yml

# Re-encrypt all keys for the previous host
sops ./hosts/${TARGETNAME}/secrets.yml
[Optional] sops updatekeys ./hosts/${TARGETNAME}/secrets.yml

####################################################
# Execute some specific host installation
# - ex: nix-server cache installation (bootstore)
####################################################

####################################################
# Execute your custom task here, exemple:
# - Restore persist borgbackup
# - Configure some program (private key generation)
####################################################

# Add hostname in configurations.nix with minimalModules
# Configure hosts/<hostname>/default.nix and hosts/<hostname>/hardware-configuration.nix 

# NixOS installation
inv init.nixos-install --hostnames ${TARGETIP} --flakeattr ${TARGETNAME}
```

## Update nixos & home-manager

```
inv nixos.deploy --hosts <hostname>
inv home.deploy --hosts <username@hostname>
```
