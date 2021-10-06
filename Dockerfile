ARG ROS_VERISON=melodic
FROM aica-technology/ros-ws:${ROS_VERISON}

RUN sudo apt-get update && sudo apt-get install -y \
  python3-vcstool \
  ros-${ROS_DISTRO}-gazebo-ros-pkgs \
  ros-${ROS_DISTRO}-gazebo-ros-control \
  ros-${ROS_DISTRO}-joint-state-publisher-gui \
  ros-${ROS_DISTRO}-joint-state-controller \
  ros-${ROS_DISTRO}-joint-trajectory-controller \
  ros-${ROS_DISTRO}-position-controllers \
  ros-${ROS_DISTRO}-velocity-controllers \
  ros-${ROS_DISTRO}-effort-controllers \
  ros-${ROS_DISTRO}-robot-localization \
  ros-${ROS_DISTRO}-mavros-msgs \
  ros-${ROS_DISTRO}-gmapping \
  ros-${ROS_DISTRO}-map-server \
  ros-${ROS_DISTRO}-amcl \
  ros-${ROS_DISTRO}-moveit \
  ros-${ROS_DISTRO}-tf-conversions \
  ros-${ROS_DISTRO}-twist-mux \
  ros-${ROS_DISTRO}-diff-drive-controller \
  ros-${ROS_DISTRO}-joy \
  ros-${ROS_DISTRO}-move-base \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ${HOME}/ros_ws/src
RUN git clone -b melodic-devel --single-branch https://github.com/RobotnikAutomation/robotnik_msgs.git

WORKDIR ${HOME}/ros_ws
RUN vcs import --input https://raw.githubusercontent.com/RobotnikAutomation/rbkairos_sim/melodic-devel/repos/rbkairos_sim.repos
RUN su ${USER} -c /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; catkin_make"

RUN mkdir -p ${HOME}/.ignition/fuel
RUN ( \
    echo '---'; \
    echo '# The list of servers.'; \
    echo 'servers:'; \
    echo '  -'; \
    echo '    name: osrf'; \
    echo '    url: https://api.ignitionrobotics.org'; \
  ) > ${HOME}/.ignition/fuel/config.yaml

RUN rm -rf ./src/rbkairos_common
COPY --chown=${USER} ./rbkairos_common ./src/rbkairos_common
COPY --chown=${USER} ./franka_panda_description ./src/franka_panda_description
RUN su ${USER} -c /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; catkin_make"
