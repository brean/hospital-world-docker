ARG ROS_DISTRO
FROM ros:${ROS_DISTRO}

SHELL ["/bin/bash", "-c"]

ARG CATKIN_WS=/root/ws/src/

RUN apt-get update &&\
    if test $ROS_DISTRO = 'noetic'; then \
        apt-get install --no-install-recommends \
            python3-pip \
            python3-catkin-tools \
            python3-rospkg \
            -y; \
    else \
        apt-get install --no-install-recommends \
            python-pip \
            python-catkin-tools \
            python-rospkg \
            -y; \
    fi && \
    apt-get install --no-install-recommends \
      ros-${ROS_DISTRO}-gazebo-ros-pkgs \
      ros-${ROS_DISTRO}-gazebo-ros-control \
      -y && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.bash /entrypoint.bash
RUN chmod a+x /entrypoint.bash

ENTRYPOINT [ "/entrypoint.bash" ]

COPY ./ros_ws/src/aws-robomaker-hospital-world/ ${CATKIN_WS}/aws-robomaker-hospital-world

RUN cd /root/ws/ \
  && source /opt/ros/${ROS_DISTRO}/setup.bash \
  && catkin build

RUN /entrypoint.bash \
  && cd ${CATKIN_WS}aws-robomaker-hospital-world/ \
  && ${CATKIN_WS}aws-robomaker-hospital-world/setup.sh