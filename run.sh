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

# if there needs to be a custom alsa config, e.g., to resample to 48khz
# -v /etc/asound.conf:/etc/asound.conf:ro \
#
# to resample to 48000khz:
# /etc/asound.conf
#pcm_slave.mine
#{
#	pcm "hw:1,0"
#	rate 48000
#}
#
#pcm.mine_44k1 {
#	type rate
#	slave mine
#}
