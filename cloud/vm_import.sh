DISK_DIR='/zfs02/vms'
DISK_SIZE='32G'

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

#check number of arguments
if (( $# < 2 )) ; then
	echo "usage script [vm_name] [qcow image]"
	return	
fi

resFile="$DISK_DIR/$1.qcow2"
echo $resFile


#detect if ISO install or qcow import
echo 'TASK: Checking Image...'
if [ ! -f "$resfile" ]; then
	echo "No such qcow, please create first"
	exit 1
fi

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
--graphics=vnc,listen=0.0.0.0,password='123Cisco123' \
--check all=off \
--disk $resFile,format=qcow2,bus=virtio \
--import
