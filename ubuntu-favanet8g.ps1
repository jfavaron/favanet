Write-Host 'Preparing to deploy Favanet Ubuntu virtual machine.'
Write-Host 'Building VM now'

# $name="iso-builder"
# $name="ubuntu-favanet-1"
# $name="ubuntu-favanet-2"
$name="ubuntu-favanet-3"
$vcpu=1
$RAMGB=4
$diskGB=20
# $iso="C:\Users\jimmy\Downloads\ubuntu-desktop.iso"
# $iso="C:\Users\jimmy\Downloads\first-test.iso"
$iso="C:\Users\jimmy\Downloads\no-interactive.iso"
# $iso="C:\Users\jimmy\Downloads\ubuntu-desktop.iso"

# Convert GB to MB
$disksize = $diskGB * 1024
$memory = $RAMGB * 1024

# Step one create VM
cd "C:\Program Files\Oracle\VirtualBox\"
.\VBoxManage createvm --name "$name" --register

# modify the vm ram and network
.\VBoxManage modifyvm "$name" --memory $memory --acpi on --boot1 dvd --cpus $vcpu --vram 20
.\VBoxManage modifyvm "$name" --nic1 bridged --nicpromisc1 allow-all --nictype1 82540EM --bridgeadapter1 "Intel(R) Ethernet Connection (2) I219-V"
.\VBoxManage modifyvm "$name" --ostype Ubuntu_64

# create storage
.\VBoxManage createhd --filename D:\vms\$name.vdi --size $disksize --format VDI
.\VBoxManage storagectl "$name" --name "IDE Controller" --add ide

# attach storage
.\VBoxManage storagectl "$name" --add sata --controller IntelAHCI --name "SATA Controller"
.\VBoxManage storageattach "$name" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium D:\vms\$name.vdi

# unattending install aka user name and computer name
.\VBoxManage unattended install "$name" --iso=$iso --user=jimmy --password=password --time-zone=MST --post-install-template="C:\Users\jimmy\Documents\code\favanet\ubuntu-post-installer.sh"

# start VM
.\VBoxManage startvm "$name" 

Write-Host 'Done Building VM - sending back to vmscripts folder'
cd "C:\Users\jimmy\Documents\code\favanet"