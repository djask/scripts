VM_NAME=fedora-01
VM_DIR=/vms

if [ -e $VM_DIR/$VM_NAME.qcow2 ]; then
	printf "Overwrite existing $VM_NAME? [Y/N]"
	read c

	if [ $c == "Y"  ]; then
		sudo virsh destroy $VM_NAME
		sudo virsh undefine $VM_NAME
		rm $VM_DIR/$VM_NAME.qcow2
	fi
fi

#copy the drive
cp /home/admin/iso/Fedora-Cloud-Base-33-1.2.x86_64.qcow2 $VM_DIR/$VM_NAME.qcow2
qemu-img resize $VM_DIR/$VM_NAME.qcow2 20G

#gen cloud init file
cat > meta-data << EOF
instance-id: fedora-01
local-hostname: fedora-01
EOF

cat > user-data << EOF
#cloud-config
# Set the default user
password: password
chpasswd: {expire: True}
ssh_pw_auth: True

#add stuff here if you want keys
# ssh_authorized_keys:

# Other settings
resize_rootfs: true
timezone: Australia/Sydney
EOF

genisoimage -output tmp.iso -volid cidata -joliet -rock user-data meta-data
rm meta-data
rm user-data
mv tmp.iso $VM_DIR/

sudo virt-install \
--connect qemu:///system \
--virt-type kvm \
--name fedora-01 \
--ram 8192 \
--vcpus 8 \
--network bridge=ext-br \
--graphics=vnc,listen=0.0.0.0,password='labpassword' \
--check all=off \
--disk $VM_DIR/$VM_NAME.qcow2,format=qcow2,bus=virtio \
--disk $VM_DIR/tmp.iso,device=cdrom,bus=ide \
--import
