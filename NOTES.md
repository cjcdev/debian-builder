# Solid-Run debian-builder Notes

## debian-builder
User **packages** branch.
https://github.com/SolidRun/debian-builder/tree/packages

Moved a lot of setup into Dockerfile (debootstrap without mirror)

Build docker image
```
./docker.sh -b
```

Drop into container shell
```
./docker.sh
```

### What I've tried..
Build some packages:
```
./packages.py -c sr-imx8-debian-11 -r bullseye -a arm64 -b amd64
```
Result:
```
dpkg-architecture: warning: specified GNU system type aarch64-linux-gnu does not match CC system type x86_64-linux-gnu, try setting a correct CC environment variable
Fetching: 100% (6/6), done in 1.765s
repo sync has finished successfully.
/work/build/sources-sr-imx8-debian-11/0010-keyring
Building /work/build/sources-sr-imx8-debian-11/0010-keyring/pkgsrc!
dh clean
dh: warning: Compatibility levels before 10 are deprecated (level 9 in use)
   debian/rules override_dh_auto_clean
make[1]: Entering directory '/work/build/sources-sr-imx8-debian-11/0010-keyring/pkgsrc'
rm -fr /work/build/sources-sr-imx8-debian-11/0010-keyring/pkgsrc/build
make[1]: Leaving directory '/work/build/sources-sr-imx8-debian-11/0010-keyring/pkgsrc'
   dh_clean
dh_clean: warning: Compatibility levels before 10 are deprecated (level 9 in use)
dpkg-source: info: using source format '3.0 (native)'
dpkg-source: info: building solidrun-keyring in solidrun-keyring_2022.07.04.tar.xz
dpkg-source: info: building solidrun-keyring in solidrun-keyring_2022.07.04.dsc
sbuild (Debian sbuild) 0.85.0 (04 January 2023) on c3b7789526aa

+==============================================================================+
| solidrun-keyring 2022.07.04 (arm64)          Fri, 08 Dec 2023 23:24:43 +0000 |
+==============================================================================+

Package: solidrun-keyring
Version: 2022.07.04
Source Version: 2022.07.04
Distribution: bullseye
Machine Architecture: amd64
Host Architecture: arm64
Build Architecture: amd64
Build Profiles: cross nocheck
Build Type: binary

E: Chroot for distribution bullseye, architecture amd64 not found
E: Error creating chroot

+------------------------------------------------------------------------------+
| Summary                                                                      |
+------------------------------------------------------------------------------+

Build Architecture: amd64
Build Profiles: cross nocheck
Build Type: binary
Build-Space: 0
Build-Time: 0
Distribution: bullseye
Fail-Stage: create-session
Host Architecture: arm64
Install-Time: 0
Job: /work/build/sources-sr-imx8-debian-11/0010-keyring/solidrun-keyring_2022.07.04.dsc
Machine Architecture: amd64
Package: solidrun-keyring
Package-Time: 0
Source-Version: 2022.07.04
Space: 0
Status: failed
Version: 2022.07.04
--------------------------------------------------------------------------------
Finished at 2023-12-08T23:24:43Z
Build needed 00:00:00, 0k disk space
E: Error creating chroot
sbuild returned 1 for /work/build/sources-sr-imx8-debian-11/0010-keyring!
```

Build image:
```
sudo python3 ./images.py sr-imx8-debian-bullseye-imx8mp
```
Result:
```
FileNotFoundError: [Errno 2] No such file or directory: 'u-boot-imx8mp.bin'
```



