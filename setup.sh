#!/bin/bash
ROS_VERSION=melodic

IMAGE_NAME=rbkairos-sim:"${ROS_VERSION}"

BUILD_FLAGS=()
while getopts 'r' opt; do
  case $opt in
  r) BUILD_FLAGS+=(--no-cache) ;;
  *)
    echo 'Error in command line parsing' >&2
    exit 1
    ;;
  esac
done
shift "$((OPTIND - 1))"

BUILD_FLAGS+=(--build-arg ROS_VERSION="${ROS_VERSION}")
BUILD_FLAGS+=(-t "${IMAGE_NAME}")

DOCKER_BUILDKIT=1 docker build "${BUILD_FLAGS[@]}" . || exit 1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
aica-docker interactive rbkairos-sim:melodic -u ros --volume=${SCRIPT_DIR}/rbkairos_common:/home/ros/ros_ws/src/rbkairos_common:rw
