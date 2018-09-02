# some useful one-liners
  
**change hostname (run once, 18.04)**  
`sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg && sudo hostnamectl set-hostname HOSTNAMEHERE`

**mount a ramdisk(replace 1024 with disk size)**  
`mount -t tmpfs tmpfs /mnt -o size=1024m`

**close shell, keep all subprocesses running**  
`disown -a && exit`

**kill process using a file**  
`fuser -k filename`
