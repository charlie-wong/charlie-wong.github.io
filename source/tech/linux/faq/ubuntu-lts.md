# Ubuntu 24.04 LTS Essential

- change APT source for speed up
  * `sudo apt update && sudo apt upgrade`

- install [XanMod](https://xanmod.org) Kernel [LTS](https://www.kernel.org) version
  * `apt depends linux-generic`
  * `apt search "linux-image-6\\.1\\..*-x64v3-xanmod"`
  * `sudo apt install linux-image-6.1.77-x64v3-xanmod1 linux-headers-6.1.77-x64v3-xanmod1`

  * `sudo apt remove linux-image-6.8.0-31-generic`
  * [Kernel 6.8 - Shutdown/Reboot hangs on Noble 24.04](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2059738)

- install [Nvidia](https://www.nvidia.com/en-us/drivers/unix) graphic card driver
  * `apt search ^nvidia-dkms-`
  * `apt search ^nvidia-driver-`
    1 -> first install nvidia kernel modules
         => linux-modules-nvidia-
         => nvidia-dkms-
    2 -> then install nvidia graphic driver
         => nvidia-driver-

- install favorites development/management toools and remove unused software
  ```bash
  sudo apt install apt-show-versions
  sudo apt install apt-file
  sudo apt-file update

  sudo apt install 7zip 7zip-rar
  sudo apt install gdisk
  sudo apt install bcompare
  sudo apt install microsoft-edge-stable

  sudo snap remove firefox
  ```
