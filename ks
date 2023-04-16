#!/usr/bin/env bash

printcountdown(){
    echo "$1 after $2 seconds"

    for ((i = $2 ; i > 0 ; i--)); do
        echo "$i"
        sleep 1
    done
}

printmessage(){
    echo ''
    echo ''
    echo '================================================='
    echo "$1"
    echo '================================================='
}

fullupgrade(){
    echo 'Will do a full system upgrade, please type sudo password'
    sudo uname -a > /dev/null

    printcountdown 'Do after' 5

    printmessage 'Update list of available packages'
    sudo apt update

    printmessage 'Installing all upgradable packages'
    sudo apt upgrade -y

    printmessage 'Remove automatically all unused packages'
    sudo apt autoremove -y

    printmessage 'Refreshing snaps'
    sudo snap refresh
}

dockerimagepull(){
    local dockerps=`docker ps -aq`

    if [ -n "$dockerps" ]; then
        echo 'please consider to remove all running containers'
        printcountdown 'will continue' 5
    fi

    printmessage 'Pulling new images'

    local images=`docker images | tail -n +2 | awk '{print $1 ":" $2}'`

    for i in $images
    do
        echo "Pulling $i"

        docker pull $i
    done

    printmessage 'Remove untagged images'
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

printhelp(){
    echo "
Usage: ks [commands]

Available commands:
  u        Full system upgrade. Combines: apt update upgrade autoremove, snap refresh
  dip      Pull all docker images with the tag that existing on current system
  dis      Save all docker images to disk
  dil      Load all image files to docker
  dps     docker ps
  dpsa    docker ps -a
  drm     docker stop NAME; docker rm NAME
  dcu     docker compose up -d
  dcd     docker compose down
  dce     docker compose exec -it --privileged NAME COMMAND
"
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
    dps )
        docker ps;;
    dpsa )
        docker ps -a;;
    drm )
        docker stop $3
        docker rm $3;;
    dcu )
        docker compose up -d;;
    dcd )
        docker compose down;;
    dce )
        docker compose exec -it --privileged $3 $4;;
    *  )
	printhelp;;
esac

