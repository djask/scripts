# Scripts
Scripts repository to organise various bash (and maybe powershell) scripts.

**linux_utils**: general purpose scripts for linux, works on mostly any linux system  
**xenserver_utils**: scripts designed for the xenapi command line interface

# some useful one-liners
  
**change hostname (run once, 18.04)**  
`sudo sed -i '/preserve_hostname: false/c\preserve_hostname: true' /etc/cloud/cloud.cfg && sudo hostnamectl set-hostname HOSTNAMEHERE`

**mount a ramdisk(replace 1024 with disk size)**  
`mount -t tmpfs tmpfs /mnt -o size=1024m`

**close shell, keep all subprocesses running**  
`disown -a && exit`

**kill process using a file**  
`fuser -k filename`


**//todo**  
powershell and batch for MSYS2  
vm backup script, xenserver  
