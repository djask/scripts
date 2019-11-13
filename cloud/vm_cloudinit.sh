DISK_DIR='/zfs01/vms'

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

if [ $# -ne 2 ] ; then
	echo "usage script [cloudinit.img] [vm_name] [cloudinit yaml file]"
	return	
fi

qemu-img info $1

#name of the new vm
resFile="$DISK_DIR/$2.img"
echo $resFile
cp -v $1 $resFile
qemu-img resize $resFile 20G


#create cloud init iso
confISO="$DISK_DIR/$2.iso"
cloud-localds $confISO $3

echo 'installing system now'
virt-install \
--connect qemu:///system \
--virt-type kvm \
--os-variant=linux \
--name $2 \
--ram 8192 \
--vcpus 4 \
--network bridge=wan_uplink,virtualport_type=openvswitch \
--disk $resFile,format=qcow2,bus=virtio \
--disk $confISO,device=cdrom,bus=ide \
--graphics=vnc,listen=0.0.0.0


