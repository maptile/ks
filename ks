#!/usr/bin/env bash

fullupgrade(){
    echo 'Full system upgrade'
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    sudo snap refresh
}

dockerimagepull(){
    local dockerps=`docker ps -aq`

    if [ -n "$dockerps" ]; then
        echo 'please consider to remove all running containers'
        echo 'will wait for 5 seconds and continue'
        sleep 5
    fi

    echo 'Pulling new images'

    local images=`docker images | tail -n +2 | awk '{print $1 ":" $2}'`

    for i in $images
    do
        echo "Pulling $i"

        docker pull $i
    done

    echo 'Remove untagged images'
    docker image prune -f
}

dockerimagesave(){
    local images=`docker images | tail -n +2 | awk '{print $1 ":" $2}'`

    for i in $images
    do
        echo "Exporting $i"
        outputfilename=$i
        outputfilename=${outputfilename/\./\_}
        outputfilename=${outputfilename/:/\_}
        outputfilename=${outputfilename/\//\_}
        outputfilename=${outputfilename/\//\_}

        docker image save $i -o ./$outputfilename.tar
    done
}

dockerimageload(){
    for i in `ls *.tar`
    do
        echo "Loading $i"
        docker image load -i $i
    done
}

case $1 in
    u )
        fullupgrade;;
    dip )
	dockerimagepull;;
    dis )
	dockerimagesave;;
    dil )
	dockerimageload;;
esac

