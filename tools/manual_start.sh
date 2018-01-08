#!/bin/bash
set -x
usage() {
    cat << EoU
Usage: $0 [options] <docker image>
Options:
    -h or --help                    This help menu
    -c or --configuration           Local directory for configuration
    -i or --installation            Local directory for installation
    -p or --port                    Local port to be mapped for web ui
    <docker image>                  Docker image name for confluence
EoU
}

docker_vcreate() {
    NAME="$1"
    if ! docker volume ls | grep $NAME; then
        docker volume create $NAME
    fi
}

docker_config() {
    PORT=${LOCAL_PORT:=8090}
    CONFIG=${LOCAL_CONFIG:="var_confluence"} && docker_vcreate $CONFIG
    INSTALL=${LOCAL_INSTALL:="opt_confluence"} && docker_vcreate $CONFIG

    DOCKER_ARGS="--interactive -t --detach"
    DOCKER_ARGS="${DOCKER_ARGS} -p $PORT:8090"
    DOCKER_ARGS="${DOCKER_ARGS} -v $CONFIG:/var/atlassian/confluence"
    DOCKER_ARGS="${DOCKER_ARGS} -v $INSTALL:/opt/atlassian/confluence"
    DOCKER_ARGS="${DOCKER_ARGS} ${DOCKER_IMG}"
}

main() {
    docker_config
    docker run $DOCKER_ARGS
}

while [ -n "$1" ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
        ;;
        -c|--configuration)
            LOCAL_CONFIG="$2"
            shift
        ;;
        -i|--installation)
            LOCAL_INSTALL="$2"
            shift
        ;;
        -p|--port)
            LOCAL_PORT="$2"
            shift
        ;;
        *)
            DOCKER_IMG="$1"
        ;;
    esac
    shift
done

main
