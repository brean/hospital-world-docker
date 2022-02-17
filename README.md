# Hospital World Docker
Load the aws-robomaker-hospital-world environment from a docker-container.

# Installation
just run `docker-compose build`

# Running
1. You need to install docker-nvidia2 if you have an nvidia graphics card and probably also set the default-environment to nvidia in your deamon.json file. See [DGX Systems Documentation](https://docs.nvidia.com/dgx/nvidia-container-runtime-upgrade/index.html) for details.
1. You need to call `xhost +local:root` before you can run `docker-compose up`, there is a handy `up.bash`-script that does just that for you, so just run the up-script and wait a few seconds (or even minutes depending on your hardware).

Note that this starts only the hospital-environment without any robot, actor or bed in it.