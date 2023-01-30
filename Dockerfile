FROM ubuntu:jammy

WORKDIR /ws

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y \
        sudo \
        libgl1-mesa-glx libgl1-mesa-dri \
        bash-completion \
        spyder \
        vim \
        gdb \
        net-tools \
        iputils-ping \
        htop \
        curl \
        gnupg2 \
        lsb-release \
        python3-pip \
        cmake \
    && pip3 install -U colcon-common-extensions \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt update \
    && echo -e "y\n6\n73\n" | apt install -y ros-humble-desktop python3-rosdep ros-humble-turtlebot3* \
    && rosdep init \
    && rosdep update \ 
    && useradd -ms /bin/bash -G sudo -u 1000 gnap \
    && echo 'gnap ALL=NOPASSWD:ALL' > /etc/sudoers.d/NO_PASSWORD \
    && echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[0;36m\]\u\[\033[1;33m\]@\[\033[0;36m\]\h\[\033[00m\]:\[\033[1;35m\]\w\[\033[00m\]\n\$ '" >> /home/gnap/.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> /home/gnap/.bashrc \
    && rm -rf /var/lib/apt/lists/*

CMD /bin/bash