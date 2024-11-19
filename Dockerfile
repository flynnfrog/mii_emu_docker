FROM debian:stable-slim AS builder

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
        libpixman-1-dev \
        pkg-config \
        xxd \
    && rm -rf /var/lib/apt/lists/* 

COPY . /tmp/build

ADD https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIe/ROM%20Images/Apple%20IIe%20Enhanced%20ROM%20Pages%20C0-FF%20-%20342-0349-B%20-%201985.bin /tmp/build/contrib/mii_rom_iiee_3420349b.bin

ADD https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIe/ROM%20Images/Apple%20IIe%20Enhanced%20Video%20ROM%20-%20342-0265-A%20-%20US%201983.bin /tmp/build/contrib/mii_rom_iiee_video_3420265a.bin

ADD https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIc/ROM%20Images/Apple%20IIc%20ROM%2000%20-%20342-0033-A%20-%201985.bin /tmp/build/contrib/mii_rom_iic_3420033a.bin

ADD https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Interface%20Cards/Serial/Apple%20II%20Super%20Serial%20Card/ROM%20Images/Apple%20II%20Super%20Serial%20Card%20ROM%20-%20341-0065-A.bin /tmp/build/contrib/mii_rom_ssc_3410065a.bin

ADD https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIc/ROM%20Images/Apple%20IIe%20Video%20ROM%20-%20341-0265-A.bin /tmp/build/contrib/mii_rom_iic_video_3410265a.bin

WORKDIR /tmp/build

RUN make all

# FROM lasuillard/freerdp-novnc

# COPY --from=builder /tmp/build/build-x86_64-linux-gnu/bin/mii_emu_gl /usr/local/bin/

# # RUN apt-get update \
# #     && apt-get install -y --no-install-recommends \ 
# #         xterm \
# #     && rm -rf /var/lib/apt/lists/* 

# RUN chmod +x /usr/local/bin/mii_emu_gl \
#     && echo "[program:mii_emu]" > /app/conf.d/mii_emu.conf \
#     && echo "command = /usr/local/bin/mii_emu_gl" >> /app/conf.d/mii_emu.conf \
#     && echo "autorestart = true" >> /app/conf.d/mii_emu.conf 

#FROM ilichevns/docker-remote-desktop-debian
FROM docker-remote-desktop

COPY --from=builder /tmp/build/build-x86_64-linux-gnu/bin/mii_emu_gl /usr/local/bin/

RUN chmod +x /usr/local/bin/mii_emu_gl

