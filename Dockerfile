ARG ROS_DISTRO
FROM brean/ros-gazebo-colcon:${ROS_DISTRO}

SHELL ["/bin/bash", "-c"]

ARG COLCON_WS=/root/ws/src/

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