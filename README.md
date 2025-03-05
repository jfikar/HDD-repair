# HDD-repair
A shell script to remap bad blocks on a HDD using hdparm --read-sector and --write-sector. They unfortunately work only with 512B sectors and most of the HDD use 4kB sectors.

Don't run the script on the whole disk as it is very slow (0.3 MB/s). Insted do

```sudo dd if=/dev/sdd bs=1M of=/dev/null conv=noerror status=progress```

This is much faster (>200 MB/s) and the LBA of the bad blocks are then easily found in dmesg using
```dmesg | grep error | grep sector | sort -n -k 9```

You'll get for example

```
[  +0.000002] critical medium error, dev sdd, sector 28331176 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28331176 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28331176 op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 28331176 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 28331176 op 0x0:(READ) flags 0x80700 phys_seg 7 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28343904 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28343904 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28343904 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28343904 op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 28343904 op 0x0:(READ) flags 0x80700 phys_seg 5 prio class 2
[  +0.000001] critical medium error, dev sdd, sector 1707599560 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599560 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599560 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 1707599560 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 1707599560 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000001] critical medium error, dev sdd, sector 1707599568 op 0x0:(READ) flags 0x80700 phys_seg 2 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599568 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599592 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 1707599592 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599608 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 1707599608 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465957888 op 0x0:(READ) flags 0x84700 phys_seg 168 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959024 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959040 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959040 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959040 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465959040 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465959040 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959048 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465959080 op 0x0:(READ) flags 0x80700 phys_seg 2 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465963464 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000002] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  +0.000003] critical medium error, dev sdd, sector 6465972816 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
```

In this case I'd search the bad blocks in the scipt in the range 28330176-28332176, 28342904-28345904, 1707598560-1707600560, etc. You get the range from the LBA error in dmesg -1000 and +1000, so it is just 1MB long.

Example of the script output:

```
6465972784 : OK
6465972792 : OK
6465972800 : OK
6465972808 : OK
6465972816 : ERROR........
6465972824 : OK
6465972832 : OK
6465972840 : OK
6465972848 : OK
6465972856 : OK
6465972864 : OK
6465972872 : OK
6465972880 : OK
6465972888 : OK
6465972896 : OK
6465972904 : OK
6465972912 : OK
6465972920 : OK
6465972928 : OK
6465972936 : OK
6465972944 : OK
6465972952 : OK
6465972960 : OK
6465972968 : OK
6465972976 : OK
6465972984 : OK
6465972992 : OK
6465973000 : OK
6465973008 : OK
6465973016 : OK
6465973024 : OK
6465973032 : OK
6465973040 : OK
6465973048 : OK
6465973056 : ERROR........
6465973064 : ERROR........
6465973072 : OK
6465973080 : ERROR........
6465973088 : ERROR........
6465973096 : OK
6465973104 : OK
6465973112 : OK
6465973120 : OK
6465973128 : OK
6465973136 : OK
TOTAL ERRORS  5
```
