FROM ubuntu

RUN apt-get update && \
	apt-get -y install \
		sudo \
		build-essential \
		wget \
		git \
		lzop \
		u-boot-tools \
		binfmt-support \
		qemu \
		qemu-user-static \
		debootstrap \
		parted \
		bc \
		udev \
		dosfstools

WORKDIR /build
ADD . /build

ENTRYPOINT ["/build/docker/entrypoint"]
