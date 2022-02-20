ARG ROS_DISTRO
FROM ros:${ROS_DISTRO}

SHELL ["/bin/bash", "-c"]

ARG COLCON_WS=/root/ws/src/

RUN apt-get update &&\
    if test $ROS_DISTRO = 'noetic'; then \
        apt-get install --no-install-recommends \
            python3-pip \
            python3-colcon-common-extensions \
            python3-rospkg \
            -y; \
    else \
        apt-get install --no-install-recommends \
            python-pip \
            install python-colcon-common-extensions \
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

# install the environment first, it should be static so it will probably not change much so the docker cache can store it
COPY ./ros_ws/src/aws-robomaker-hospital-world/ ${COLCON_WS}/aws-robomaker-hospital-world

RUN cd /root/ws/ \
  && source /opt/ros/${ROS_DISTRO}/setup.bash \
  && colcon build

RUN /entrypoint.bash \
  && cd ${COLCON_WS}aws-robomaker-hospital-world/ \
  && ${COLCON_WS}aws-robomaker-hospital-world/setup.sh

# and now the actor, which might change more often so we install it after the hospital
COPY ./ros_ws/src/gazebo-actor-in-hospital/ ${COLCON_WS}/gazebo-actor-in-hospital

RUN cd /root/ws/ \
  && source /opt/ros/${ROS_DISTRO}/setup.bash \
  && colcon build