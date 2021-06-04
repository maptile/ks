# ks

ks is short for Kill Server which means if you use it without enough care, you may kill your server.

# Usage

You can append the following scripts to ~/.profile, it let you run shell commands from ks dir.

`
if [ -d "$HOME/.ks/" ] ; then
    PATH="$HOME/.ks:$PATH"
fi
`

## Do a full system upgrade

`ks u`

which is equal to:

`sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh`

## Pull the latest docker images with the same version

`ks pi`

Explaination:

It will read all images names and tags from system, and then pull the latest images with the same version.

If you have an image `postgres:12` the script will pull the latest `postgres:12`.

If you have an image `postgres:latest` the script will pull the latest `postgres:latest`.

After that, it will run `docker system prune && docker container prune && docker image prune` to save disk space.

## Pull git repository recursively

`git pullrecursive`

It will visit all immediate child directories and run `git pull` in it.

## Check git repository status recursively

`git statusrecursive`

It will visit all immediate child directories and run `git status` in it.
