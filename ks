#!/usr/bin/env bash

fullupgrade(){
    echo 'Full system upgrade'
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    sudo snap refresh
}

pullimagerecursive(){
    local dockerps=`docker ps -aq`

    if [ -n "$dockerps" ]; then
        echo 'please remove all containers then try again'
        exit 1
    fi

    echo 'Pulling new images'
    docker images | tail -n +2 | awk '{print $1":"$2}' | xargs -L1 docker pull

    echo 'Remove untagged images'
    docker image prune -f
}

case $1 in
    u )
        fullupgrade;;
    pi )
        pullimagerecursive;;
esac

