#Step 3
pvcreate /dev/nvme1n1
pvcreate /dev/nvme2n1
pvcreate /dev/nvme3n1
 
#Step 4:  Note, the volumes may differ depending on host but I think
vgcreate svr /dev/nvme1n1
vgcreate els /dev/nvme2n1
vgcreate data /dev/nvme3n1
 
#Step 5
lvcreate -L 25G -n bin data
lvcreate -L 25G -n data data
lvcreate -l 100%FREE -n cas data
lvcreate -l 100%FREE -n svr svr
lvcreate -l 100%FREE -n els els
 
#Step 6
mkfs.xfs /dev/data/bin
mkfs.xfs /dev/data/data
mkfs.xfs /dev/data/cas
mkfs.xfs /dev/svr/svr
mkfs.xfs /dev/els/els
 
#Step 7
mkdir -p /opt/dynatrace-managed
mkdir -p /var/opt/dynatrace-managed
mkdir -p /mnt/dynatrace/els
mkdir -p /mnt/dynatrace/svr
mkdir -p /mnt/dynatrace/cas
 
#Destinations for Step 8:
#data/bin mounts to /opt/dynatrace-managed
#data/data mounts to /var/opt/dynatrace-managed
#els/els mounts to /mnt/dynatrace/els
#svr/svr mounts to /mnt/dynatrace/svr
#data/cas mounts to /mnt/dynatrace/cas
 
#Step 8
echo -e "/dev/data/bin\t/opt/dynatrace-managed\txfs\tdefaults\t0 0" >> /etc/fstab
echo -e "/dev/data/data\t/var/opt/dynatrace-managed\txfs\tdefaults\t0 0" >> /etc/fstab
echo -e "/dev/els/els\t/mnt/dynatrace/els\txfs\tdefaults\t0 0" >> /etc/fstab
echo -e "/dev/svr/svr\t/mnt/dynatrace/svr\txfs\tdefaults\t0 0" >> /etc/fstab
echo -e "/dev/data/cas\t/mnt/dynatrace/cas\txfs\tdefaults\t0 0" >> /etc/fstab
 
#Step 9
mount -a

wget -O dynatrace-managed.sh "https://mcsvc.dynatrace.com/downloads/installer/get/latest?token=AQECAHgWRMdElTYfhZCupuE7ykwW1JOgVOWYNXb8u4pNcPM3owAAAIQwgYEGCSqGSIb3DQEHBqB0MHICAQAwbQYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAweUME8waFek7pXIXcCARCAQIC9IOHeOaRhRnjSTsG5k8azftKWmvB7lIxWg5BR6oHhrOTD3oA9gLHffi-F5ETAHDlfpAKcgUm696RQwTBL0Oc"
sudo /bin/sh dynatrace-managed.sh --install-silent --license o5TN3EuMt6c2gODz --cas-datastore-dir /mnt/dynatrace/cas --els-datastore-dir /mnt/dynatrace/els --svr-datastore-dir /mnt/dynatrace/svr