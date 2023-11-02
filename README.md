## Shairport-Sync Setup Notes

Starting from a fresh install of Raspbian Bookworm (Debian 12)

## Disable password-less sudo, makes me feel more safe :)
```
sudo rm /etc/sudoers.d/010_pi-nopasswd
```

## Update all packages
```
sudo apt update 
sudo apt upgrade
```

## Install podman
```
sudo apt install podman
```

## Set podman max log size
```
vi /etc/containers/libpod.conf

change:
  max_log_size = -1
to
  max_log_size = 10485670
```

## Enable podman restart service for autostart
```
sudo systemctl enable podman-restart
```


## fix apple usb-c to 3.5mm adapter to support 44100 sample rate
from: https://github.com/mikebrady/shairport-sync/issues/1504#issuecomment-1646363350

```
cat /etc/udev/rules.d/85-apple-dac-config.rules 
ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="110a", RUN+="/usr/sbin/usb_modeswitch -v 05ac -p 110a -u 3"
```

## Create config: ~/containers/shairport-sync/shairport-sync.conf
```
general = {
	name = "Airplay Speakers";
};

alsa = {
	output_device = "hw:A";
	mixer_control_name = "PCM";
};
```

## Create Run File: ~/containers/shairport-sync/run.sh
```
#!/bin/sh

UID=$(id -u)

if [ $UID != 0 ]; then
    echo "must be run as root(ful)"
    exit 1
fi

podman run \
	-d \
	--restart always \
	--name shairport-sync \
	--net host \
	--device /dev/snd \
	-v /home/slynn1324/containers/shairport-sync/shairport-sync.conf:/etc/shairport-sync.conf:ro \
	docker.io/mikebrady/shairport-sync:latest -v --statistics
```

## Create Container
```
cd ~/containers/shairport-sync
sudo ./run.sh
```


