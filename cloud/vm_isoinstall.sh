DISK_DIR='/vms'
DISK_SIZE='32G'

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

#check number of arguments
if (( $# < 2 )) ; then
	echo "usage script [vm_name] [iso file]"
	return	
fi

resFile="$DISK_DIR/$1.qcow2"
echo $resFile


#detect if ISO install or qcow import
echo 'TASK: Creating Image...'
qemu-img create -f qcow2 $resFile $DISK_SIZE
ISO=1

echo 'RAM SIZE (KB): '
read ram_size

echo 'CPUS (min. 1): '
read cpus


virt-install \
--connect qemu:///system \
--virt-type kvm \
--name $1 \
--ram $ram_size \
--vcpus $cpus \
--network bridge=wan_uplink,virtualport_type=openvswitch \
--graphics=vnc,listen=0.0.0.0,password='labpassword' \
--check all=off \
--disk $resFile,format=qcow2,bus=virtio \
--disk $2,device=cdrom,bus=ide,target=hda
