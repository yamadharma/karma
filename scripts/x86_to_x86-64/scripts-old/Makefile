
#default mount point
mount_point=/mnt/gentoo
#default stage
stage_name=stage3-amd64-2006.0.tar.bz2

all:

01:
	./step01 $(stage_name)
	touch 01 

02: 01
	./step02 $(mount_point)
	touch 02 

03: 02
	./step03 $(mount_point)
	touch 03 

04: 03
	./step04 $(mount_point)
	touch 04 





