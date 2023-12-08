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
Downloading Repo source from https://gerrit.googlesource.com/git-repo
repo: Updating release signing keys to keyset ver 2.3

repo has been initialized in /work/build/sources-sr-imx8-debian-11
Fetching: 100% (5/5), done in 53.883s
Fetching: 100% (1/1), done in 5m0.102s
Updating files: 100% (72299/72299), done.
Checking out: 100% (6/6), done in 6.471s
repo sync has finished successfully.
/work/build/sources-sr-imx8-debian-11/0010-keyring
pkgsource: None, sourcedir: /work/build/sources-sr-imx8-debian-11/0010-keyring
Error: Found no source package in /work/build/sources-sr-imx8-debian-11/0010-keyring!
/work/build/sources-sr-imx8-debian-11/0020-linux
pkgsource: None, sourcedir: /work/build/sources-sr-imx8-debian-11/0020-linux
Error: Found no source package in /work/build/sources-sr-imx8-debian-11/0020-linux!
/work/build/sources-sr-imx8-debian-11/0030-bsp
pkgsource: None, sourcedir: /work/build/sources-sr-imx8-debian-11/0030-bsp
Error: Found no source package in /work/build/sources-sr-imx8-debian-11/0030-bsp!
/work/build/sources-sr-imx8-debian-11/0040-runonce
pkgsource: None, sourcedir: /work/build/sources-sr-imx8-debian-11/0040-runonce
Error: Found no source package in /work/build/sources-sr-imx8-debian-11/0040-runonce!
/work/build/sources-sr-imx8-debian-11/0050-expand-fs
pkgsource: None, sourcedir: /work/build/sources-sr-imx8-debian-11/0050-expand-fs
Error: Found no source package in /work/build/sources-sr-imx8-debian-11/0050-expand-fs!
```

Build image:
```
sudo python3 ./images.py sr-imx8-debian-bullseye-imx8mp
```
Result:
```
FileNotFoundError: [Errno 2] No such file or directory: 'u-boot-imx8mp.bin'
```



