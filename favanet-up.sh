#!/bin/bash
echo '----------------'
echo 'Updating and installing: apt and apt-get'
echo '----------------'

### apt
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common net-tools openssh-server vim gcc python3-dev python3-pip -y

### apt-get
sudo apt-get update
sudo apt-get install python3-setuptools python3 libffi-dev libssl-dev nfs-common -y
# sudo python3 -m easy_install install pip
python3 -m pip --version

echo '----------------'
echo 'Updating and installing: docker'
echo '----------------'
## Installing Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker jimmy
pip3 install docker-compose
mkdir /home/jimmy/docker

echo '----------------'
echo 'Updating and installing: vscode'
echo '----------------'

### get vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code -y

echo '----------------'
echo 'Installing and Mounting NFS'
echo '----------------'
sudo systemctl enable systemd-networkd-wait-online.service

sudo echo "Wants=network-online.target" >> /lib/systemd/system/remote-fs-pre.target
sudo echo "After=network-online.target" >> /lib/systemd/system/remote-fs-pre.target

sudo mkdir /media/bigfundamental
sudo mkdir /media/duncan
sudo mkdir /media/nvr
sudo mkdir /media/backups

echo '----------------'
echo 'Updating fstab'
echo '----------------'

sudo echo "192.168.1.98:/volume1/movies /media/bigfundamental nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/family /media/duncan nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/nvr /media/nvr nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/backups /media/backups nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab

echo '----------------'
echo 'Adding Authorized Keys'
echo '----------------'
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDh4cvbaC+wQlkY2pvaIvbOKSTmbwH6mS5+tTFDJ5QhoNlQ2mcq7FpnV9XQ/ROq5PX1LizCUz6RHiu0hlVrte1/OsV0MoornHtNHDbfBv5g+xhVAYpz+O7iK2cgSFamA6aB6ut2MBZzN7hAuxor6/pznXP6mQM8hwhFkjwIcLZIA0xim2WQ58SsNiGzF+iVcj0pA7MP2CSSydJwDmglyAhHdLA0VNbTQzTm8M9Lj5SNw/XWEcSL3Izv7qSnM40IxwexsRkSB4tghpZHJACyeK61yKr/73BwvXlDk6C2tdSXurkhjuAs+eseHp0F8XS/xl0lpOKCbjUBqavxuKR7zPXJqw4zkuEgykaVCQQ0hDtfCdCpJ0EjNF5u8zcez5Dzy1fPh2zNRJFB3m3MCx9Z+de9aRuD/XsTCzGR5vfqzz/O7d/PB7f0y+XsDyalGnZydqtbvbgLXICxGeXTlCxmwkI/K8NLYeJm8wjaNkd8tEgXuhson85BQFFLhKEISuu/t3M= jimmy@yoga" >> /home/jimmy/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP6T4PozkuLw/dwkNH7YbHsd/RBh+s8bCy+ftOSmpkF72znmwHOu4UubX5zlDq1tziqkFpxr08d+sBWgchJSH/i606oWbweVMjWG4qyipV4p+R4fhiety1GVv60HHywUMDo6yiMOEIq5MkPPOp1ygIE3EuEZ12+BKVyN32HUUyfvXfUm9FN2oee3DA5ghQZSF/OhX5fgz3Mesd2Y3MWOr1TnflC6U70qaMCJdkNGoPjPE2AM7qPKXIu76pdCUvORtJyndFLfrV2cGPJXO88YVQyPK4IOXNCL0zAALSPymsFTdx2VIrM87xhGNPuBl6D25zp4g0NcYQ4rt87FZBS7SrFOngqd1/cP84Fdh91DogNx7BPSLEzPIQAgQvKfaHTljrMc/rQx9duYy56zFEFkg8eIPjRyUG9Ky8Ov8fArPF15R+u2tQernIkVWzhRzNuSU2NMQMzNH+3AlA2fF33A+Fsz2iYYyQLjTcb0KIHqEPRbZQgkou3EV7dg53SYQQDys= jimmy@favanet" >> /home/jimmy/.ssh/authorized_keys

rsync -av --update --exclude 'plex/Library/Application Support/Plex Media Server/Cache/' /media/backups/ryzen/docker/uptime-kuma /home/jimmy/docker/
rsync -av --update --exclude 'plex/Library/Application Support/Plex Media Server/Cache/' /media/backups/ryzen/docker/dashy /home/jimmy/docker/
cp /media/backups/ryzen/docker/docker-compose.yml /home/jimmy/docker/docker-compose.yml
cp /media/backups/ryzen/docker/.env /home/jimmy/docker/.env