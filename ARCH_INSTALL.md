# Arch Linux installation

## Simple VM config
Check if you have internet access
``` shell
ping google.com
```

#### Virtual Box port forwarding

##### Guest Machine

Check what is the guest ip
``` shell
ip addr # Look for the inet addr
        # We will enabe port forwarding to this io
```

##### VirtualBox settings
In virtual-box, setup port forwarding by going in
General > Networg > Port Forwarding 
And setup values as follow
```
| Rule  | Protocol |  Host IP  | Host Port |  Guest IP | Guest Port |
 -------------------------------------------------------------------
| Rule1 |      tcp | 127.0.0.1 |      2222 | 10.0.2.15 |         22 |

```
Validate settings

#### Connect throught ssh

##### Guest machine config

In the VM shell change the permit root login to yes
``` shell
sed -i 's/^#\(PermitRootLogin\).*/\1 yes/' /etc/ssh/sshd_config
```

Reload sshd agent
``` shell
systemctl reload sshd
```

Set a root password
``` shell
passwd
(your password here)
(your password here)
```

##### Host machine conection
Open a terminal and connect throught ssh
``` shell
ssh root@127.0.0.1 -p 2222
```

### Installation

Partition Disk
``` shell
fdisk -l # To list disk and partition
fdisk /dev/sda
# p : Print partition table
# n : Create new partition
# t : Set partition type
# w : write partition table
# 
# We will make only one 'primary' partition of 'linux' type
# Which take all the available space
```

Format partition
``` shell
mkfs.ext4 /dev/sda1
```

Mount partition
``` shell
mount /dev/sda1 /mnt
```

Install base package
``` shell
pacstrap /mnt base linux base-devel
```

Generate fstab file
``` shell
genfstab -U /mnt >> /mnt/etc/fstab
```

### Configuration

Log into the new system
``` shell
arch-chroot /mnt
```

Install package
``` shell
pacman -S  grub man man-db texinfo openssh dhcpcd ufw neovim zsh git sudo
```

##### Localization
``` shell
sed -i '/en_US.UTF-8/s/^.//' /etc/locale.gen
locale-gen
```

``` shell
echo 'LANG=en_US.UTF-8
LANGUAGE=en_US
LC_ALL=C' >> /etc/locale.conf
```

``` shell
echo 'KEYMAP=us' >> /etc/vconsole.conf
```

##### Timezone
``` shell
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
```

#### Network and ssh configuration


##### Start services
``` shell
systemctl enable sshd
systemctl enable dhcpcp
systemctl enable ufw
ufw enable
```

##### Configure firewall
``` shell
ufw allow 22/tcp
```

##### Set Host
Set machine hostname
``` shell
echo "archVM" > /etc/hostname
```

Set hosts
``` sell
echo '127.0.0.1    localhost.localdomain   localhost
::1          localhost.localdomain   localhost
127.0.0.1    archVM.localdomain      archVM' >> /etc/hosts
```

##### Update Root passwd
``` shell
passwd
(your password here)
(your password here)
```

#### Install Bootloader
``` shell
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Reboot the machine
``` shell
exit
umount -R /mnt
reboot
```

### Post install setup
When rebooting the machine, select 'Boot existing OS'

Then login as 'root'

#### Create new user
``` shell
useradd -m -g users -G wheel -s /usr/bin/zsh john
```
Set password for newly created user
``` shell
passwd john
(your password here)
(your password here)
```

Edit the visudo file
``` shell
EDITOR=nvim visudo
```
Uncomment
```
%wheel ALL=(ALL) ALL
```

Log into the new user
``` shell
su john
```

#### Install AUR package manager
``` shell
mkdir Sources
cd Sources
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### Final config
Lazy style

##### Clone the dotfile repo
Be sure that you are logged as your new user
``` shell
cd ~
git clone https://github.com/salamientark/dotfiles.git
cd dotfiles
./arch_install.sh
```
