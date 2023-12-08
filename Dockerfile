FROM debian:12.2

# Use DEBIAN_FRONTEND=noninteractive, to avoid image build hang waiting
# for a default confirmation [Y/n] at some configurations.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt clean
RUN apt update
RUN apt upgrade -yq
RUN apt install -yq apt-utils
# basic packages
RUN apt install -yq --fix-missing gawk wget git-core diffstat unzip tar locales \
    net-tools sudo vim curl tree pip ca-certificates curl gnupg lsb-release zip

# Use bash
RUN rm /bin/sh && ln -s bash /bin/sh

# Add your user to sudoers to be able to install other packages in the container.
ARG USER
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# Set the arguments for host_id and user_id to be able to save the build artifacts
# outside the container, on host directories, as docker volumes.
ARG host_uid \
    host_gid
RUN groupadd -g $host_gid build && \
    useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER

# create work dir that is owned by normal user
WORKDIR /work
#RUN chown $host_uid:$host_gid /work

# Required by SolidRun debian-builder
RUN apt-get install -yq sbuild schroot debootstrap apt-cacher-ng devscripts debarchiver qemu-user-static software-properties-common
RUN apt-add-repository contrib
#RUN apt-get -y install repo
RUN apt-get install -yq kernel-wedge python3-jinja2

# repo assumes python is python3
RUN apt-get install -yq python-is-python3

# Add $USER to sbuild group
RUN sbuild-adduser ${USER}

# For Image Builder
RUN apt-get -yq install debootstrap fdisk kpartx libxml2-dev libxslt1-dev python3-pip python3-venv qemu-utils rsync zlib1g-dev
RUN pip3 install --break-system-packages wheel xmlschema
RUN pip3 install --break-system-packages kiwi==v9.23.22
RUN mkdir -p /root/.gnupg

# for kernel build
RUN apt-get -yq install libncurses-dev bison flex libssl-dev libelf-dev bc
RUN cd /opt && \
    wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz && \
    tar xf gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz && \
    rm -fr gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz

# Setup chroot env for Debian 11 arm64 (leave off local repo)
RUN debootstrap --variant=buildd --include=eatmydata --arch=arm64 --components=main --foreign bullseye /srv/chroot/bullseye-arm64-sbuild/
RUN cp /usr/bin/qemu-aarch64-static /usr/bin/qemu-arm-static /srv/chroot/bullseye-arm64-sbuild/usr/bin/
RUN chroot /srv/chroot/bullseye-arm64-sbuild /debootstrap/debootstrap --second-stage
COPY ./container-files/bullseye-arm64-sbuild /etc/schroot/chroot.d/bullseye-arm64-sbuild

# Switch to normal user.
USER $USER

COPY ./container-files/sbuildrc ~/.sbuildrc

RUN mkdir ~/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo
ENV PATH="${PATH}:/home/$USER/bin"

RUN git config --global user.email "no@email.com"
RUN git config --global user.name "No Name"

