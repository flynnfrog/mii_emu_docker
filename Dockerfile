FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \ 
        ca-certificates \
        gcc \
        git \
        libc6-dev \
        make \
        mold \
        libasound2-dev \
        libgl-dev \
        libglu-dev \
        libx11-dev \
        libxcb-xkb-dev \
        libxcb-image0-dev \
        libxcb-shm0-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        libpixman-1-dev \
        pkg-config \
        xxd \
    && rm -rf /var/lib/apt/lists/* 

COPY . /tmp/build/

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIe/ROM%20Images/Apple%20IIe%20Enhanced%20ROM%20Pages%20C0-FF%20-%20342-0349-B%20-%201985.bin /tmp/build/contrib/mii_rom_iiee_3420349b.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIe/ROM%20Images/Apple%20IIe%20Enhanced%20Video%20ROM%20-%20342-0265-A%20-%20US%201983.bin /tmp/build/contrib/mii_rom_iiee_video_3420265a.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIc/ROM%20Images/Apple%20IIc%20ROM%2000%20-%20342-0033-A%20-%201985.bin /tmp/build/contrib/mii_rom_iic_3420033a.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Interface%20Cards/Serial/Apple%20II%20Super%20Serial%20Card/ROM%20Images/Apple%20II%20Super%20Serial%20Card%20ROM%20-%20341-0065-A.bin /tmp/build/contrib/mii_rom_ssc_3410065a.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIc/ROM%20Images/Apple%20IIe%20Video%20ROM%20-%20341-0265-A.bin /tmp/build/contrib/mii_rom_iic_video_3410265a.bin

ADD http://mirrors.apple2.org.za/ftp.apple.asimov.net/emulators/rom_images/VID-342-274A.bin /tmp/build/contrib/contrib/mii_rom_iiee_video_fr_342274a.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIe/ROM%20Images/Apple%20IIe%20Enhanced%20Video%20ROM%20-%20342-0273-A%20-%20US-UK.bin /tmp/build/contrib/mii_rom_iiee_video_uk_3420273a.bin

ADD http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Interface%20Cards/Disk%20Drive%20Controllers/Apple%20Disk%20II%20Interface%20Card/ROM%20Images/Apple%20Disk%20II%2016%20Sector%20Interface%20Card%20ROM%20P5%20-%20341-0027.bin /tmp/build/contrib/mii_rom_disk2_p5_3410037.bin

WORKDIR /tmp/build

RUN make all

FROM docker-remote-desktop

COPY --from=builder /tmp/build/build-x86_64-linux-gnu/bin/mii_emu_gl /usr/local/bin/

RUN chmod +x /usr/local/bin/mii_emu_gl

