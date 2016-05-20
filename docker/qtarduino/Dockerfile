FROM debian:jessie
MAINTAINER Ali Diouri <alidiouri@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_ANDROID ${QT_PATH}/5.6/android_armv7
ENV ANDROID_HOME /opt/android_sdk
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}
ENV ANDROID_NDK_ROOT /opt/android_ndk
ENV ANDROID_NDK_TOOLCHAIN_PREFIX arm-linux-androideabi
ENV ANDROID_NDK_TOOLCHAIN_VERSION 4.9
ENV ANDROID_NDK_HOST linux-x86_64
ENV ANDROID_NDK_PLATFORM android-21
ENV ANDROID_NDK_TOOLS_PREFIX ${ANDROID_NDK_TOOLCHAIN_PREFIX}
ENV QMAKESPEC android-g++
ENV PATH ${PATH}:${QT_ANDROID}/bin:${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * curl, p7zip - to download & unpack Qt bundle
#  * make, default-jdk, ant - basic build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1 - dependencies of Qt bundle run-file
#  * libc6:i386, libncurses5:i386, libstdc++6:i386, libz1:i386 - dependencides of android sdk binaries
RUN dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    make \
    default-jdk \
    ant \
    curl \
    p7zip \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    unzip \
    && apt-get -qq clean

# copy unpack Qt 5.6
COPY Qt5.6.0.7z /tmp/qt/
RUN 7zr x -o$QT_PATH /tmp/qt/Qt5.6.0.7z \
    && rm -rf /tmp/qt

# Download & unpack android SDK
RUN mkdir /tmp/android && curl -Lo /tmp/android/sdk.tgz 'http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz' \
    && tar --no-same-owner -xf /tmp/android/sdk.tgz -C /opt && mv /opt/android-sdk-linux ${ANDROID_HOME}\
    && rm -rf /tmp/android && echo "y" | android update sdk -u -a -t tools,platform-tools,build-tools-21.1.2,$ANDROID_NDK_PLATFORM

# Download & unpack android NDK
RUN mkdir /tmp/android && cd /tmp/android && curl -Lo ndk.zip 'http://dl.google.com/android/repository/android-ndk-r11b-linux-x86_64.zip' \
    && unzip ndk.zip  && mv android-ndk-r11b $ANDROID_NDK_ROOT && chmod -R +rX $ANDROID_NDK_ROOT \
    && rm -rf /tmp/android

RUN mkdir /app
WORKDIR /app

CMD if [ ! -d /app/build ]; then mkdir -p /app/build; else rm -rf /app/build/*; fi && cd build && qmake -r -spec android-g++ .. && make -j