#!/bin/bash
echo '----------------'
echo 'Updating and installing: apt and apt-get'
echo '----------------'

### apt
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common net-tools openssh-server git vim gcc python3-dev python3-pip xorriso isolinux -y

### apt-get
sudo apt-get update
sudo apt-get install python3-setuptools python3 libffi-dev libssl-dev nfs-common cloud-init -y
sudo python3 -m easy_install install pip
# python3 -m pip --version

echo '----------------'
echo 'Updating and installing: docker'
echo '----------------'

# Check if Docker already exists
DOCKER=get-docker.sh
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
    ## Installing Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker jimmy
    pip3 install docker-compose
    mkdir /home/jimmy/docker
fi

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

sudo mount 192.168.1.98:/volume1/movies /media/bigfundamental
sudo mount 192.168.1.99:/volume1/family /media/duncan
sudo mount 192.168.1.99:/volume1/nvr /media/nvr
sudo mount 192.168.1.99:/volume1/backups /media/backups
df -h

echo '----------------'
echo 'Updating fstab'
echo '----------------'

sudo echo "192.168.1.98:/volume1/movies /media/bigfundamental nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/family /media/duncan nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/nvr /media/nvr nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab
sudo echo "192.168.1.99:/volume1/backups /media/backups nfs _netdev,x-systemd.automount,user,noauto,nolock,intr,nfsvers=3 0 0" >> /etc/fstab

# echo '----------------'
# echo 'Adding Authorized Keys'
# echo '----------------'
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDh4cvbaC+wQlkY2pvaIvbOKSTmbwH6mS5+tTFDJ5QhoNlQ2mcq7FpnV9XQ/ROq5PX1LizCUz6RHiu0hlVrte1/OsV0MoornHtNHDbfBv5g+xhVAYpz+O7iK2cgSFamA6aB6ut2MBZzN7hAuxor6/pznXP6mQM8hwhFkjwIcLZIA0xim2WQ58SsNiGzF+iVcj0pA7MP2CSSydJwDmglyAhHdLA0VNbTQzTm8M9Lj5SNw/XWEcSL3Izv7qSnM40IxwexsRkSB4tghpZHJACyeK61yKr/73BwvXlDk6C2tdSXurkhjuAs+eseHp0F8XS/xl0lpOKCbjUBqavxuKR7zPXJqw4zkuEgykaVCQQ0hDtfCdCpJ0EjNF5u8zcez5Dzy1fPh2zNRJFB3m3MCx9Z+de9aRuD/XsTCzGR5vfqzz/O7d/PB7f0y+XsDyalGnZydqtbvbgLXICxGeXTlCxmwkI/K8NLYeJm8wjaNkd8tEgXuhson85BQFFLhKEISuu/t3M= jimmy@yoga" >> /home/jimmy/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP6T4PozkuLw/dwkNH7YbHsd/RBh+s8bCy+ftOSmpkF72znmwHOu4UubX5zlDq1tziqkFpxr08d+sBWgchJSH/i606oWbweVMjWG4qyipV4p+R4fhiety1GVv60HHywUMDo6yiMOEIq5MkPPOp1ygIE3EuEZ12+BKVyN32HUUyfvXfUm9FN2oee3DA5ghQZSF/OhX5fgz3Mesd2Y3MWOr1TnflC6U70qaMCJdkNGoPjPE2AM7qPKXIu76pdCUvORtJyndFLfrV2cGPJXO88YVQyPK4IOXNCL0zAALSPymsFTdx2VIrM87xhGNPuBl6D25zp4g0NcYQ4rt87FZBS7SrFOngqd1/cP84Fdh91DogNx7BPSLEzPIQAgQvKfaHTljrMc/rQx9duYy56zFEFkg8eIPjRyUG9Ky8Ov8fArPF15R+u2tQernIkVWzhRzNuSU2NMQMzNH+3AlA2fF33A+Fsz2iYYyQLjTcb0KIHqEPRbZQgkou3EV7dg53SYQQDys= jimmy@favanet" >> /home/jimmy/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDG9elOO+pAJL4GAhPAoJK45tKwR2/BqPLcpa6axvA0UGPxrqJKFdAhwt44nKkjAUccTBHCvRV28GC8JsYslBYbxp8/r4woje8uYHZwlM4QGBZvucUWms2/2gGMvuor6kamEppGbLLtzwXAr5qS9c3tHR5aBkwnVv94VZVMZeXg5LSiCWvxx4UW11662Pon+SwDp3eTgZwxyzIF72dcBsCDlKHVSNsNfEPUxGU/euHJ9hFY1U7qpG/Q2Vns4AeKBbAeSaLa7b/e4aakV8cOHh59aWMw6L0z67LYjq391RyDlQrae3v4limIlLhQ8APuVmluDFl7k+Ibj12+/XQG/KiWItDJ9FI61ejwSckQ1lqYcNrFDENqUVNlTGgu2QnEu6w1ezMOYWp2yYXrDW8uMuvgFUrjIFOc+4ZRGLFnAm+ZNDUjaU2Ded6niD64/gglPvHn4iHI7SfEpVGSogRYGa1bi8gsJ5WreWWDGRv2UstfD5r41KPtbb9lUQxYo8L2pOs= jimmy@DESKTOP-SC83VLT" >> /home/jimmy/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoY+PlEa4DZYTJbWQzjewvogrfecr113PKCWNTjdrqpaaIyNZuoy4c+PQkZ6Q4UZGXq/G5QmoPQ8ynHk9KfnZQnZ88JGG/s6rZIt68oYJlWOi2C0luSEknxXctiJRItpbAya0bZtHvxkP2N7YoyZrXP2ICOyA3ZB74+GQA+z+khxpPcodYvjXc3Wl9a7y6jYUZ3sowODeJ5VB4Y4RYZZb4sZi3XLtflg3AQYRw34E89GsUcnq1zbLR6Jtxuh0VtNpG2WlCbjPlftGCBnfSg332+NOJJPBno7TShgAntMAiHhKeMAZc5LjxoMHIq5guhyAAGLS6F2/6I/YRlx0C/SkBbzKcTLfANadvFjcGzXCG3FMlqmcufqPpjWD77b5dYaHC+fPh3UKeC0jAnwmf/bB4myAfhwstPxPBInfLDXD6ETH4r8vsAgDS+idcaardPPE1CXY80jp4sjPu6ejxZrKm8GPXKSY2h81AVw089vqIlEOUNchS7rw345MoO9wJwzk= jimmy@tate.localdomain" >> /home/jimmy/.ssh/authorized_keys
sudo chown jimmy:jimmy /home/jimmy/.ssh/authorized_keys

rsync -av --update --exclude 'plex/Library/Application Support/Plex Media Server/Cache/' /media/backups/ryzen/docker/uptime-kuma /home/jimmy/docker/
rsync -av --update --exclude 'plex/Library/Application Support/Plex Media Server/Cache/' /media/backups/ryzen/docker/dashy /home/jimmy/docker/
cp /media/backups/ryzen/docker/docker-compose.yml /home/jimmy/docker/docker-compose.yml
cp /media/backups/ryzen/docker/.env /home/jimmy/docker/.env
sudo chown -Rf jimmy:jimmy /home/jimmy/docker/

adduser jimmy sudo
IP_ADDR=`ip addr show | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}' | grep 192`
echo $IP_ADDR


su root
adduser jimmy docker

### Examples ###
## image should have get-favanet.sh ready that runs the following command to get the newest config and deploy it
# wget -O /usr/local/bin/favanet.sh tinyurl.com/favanet && chmod +x /usr/local/bin/favanet.sh && favanet.sh
## in order to get any docker container's backup/current state 
# rsync -av --update /media/backups/ryzen/docker/<service> /home/jimmy/docker/
## in order to exclude a path
# rsync -av --update --exclude 'plex/Library/Application Support/Plex Media Server/Cache/' /media/backups/ryzen/docker/dashy /home/jimmy/docker/
## backing up
# rsync -av --update /home/jimmy/docker/ /media/backups/<host>/docker/