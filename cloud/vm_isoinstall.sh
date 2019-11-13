DISK_DIR='/zfs01/vms'
DISK_SIZE='25G'

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

if (( $# < 1 )) ; then
	echo "usage script [vm_name] [iso file (if not specify, then assuming import)]"
	return	
fi

resFile="$DISK_DIR/$1.qcow2"
echo $resFile

echo 'installing system now'

ISO=0

if (( $# < 2 )); then

	#name of the new vm
	cp -v $1 $resFile
	qemu-img resize $resFile $DISK_SIZE
else
	qemu-img create -f qcow2 $resFile $DISK_SIZE
	ISO=1
fi

virt-install \
--connect qemu:///system \
--virt-type kvm \
--os-variant=linux \
--name $1 \
--ram 8192 \
--vcpus 4 \
--network bridge=wan_uplink,virtualport_type=openvswitch \
--graphics=vnc,listen=0.0.0.0 \
--disk $resFile,format=qcow2,bus=virtio \
--disk $2,device=cdrom,bus=ide,target=hda

