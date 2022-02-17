#!/bin/bash
xhost +local:root
docker-compose up
xhost -local:root