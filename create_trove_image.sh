#!/bin/bash

set -e

err() {
    echo "${0##*/}: $@" >&2
}

print_usage() {
    echo "Usage: ${0##*/} [-d distro] [-s datastore] [-i | -u | -p | -o | -h]"
    echo "Options:"
    echo " -d | --distro: name of the system to use. Possible options are fedora, centos or rhel."
    echo " -s | --datastore: name of the storage backend to use. Possible options are mysql or mongodb."
    echo " -i | --local-image: path to the local image. Defaults to diskimage-builder location."
    echo " -u | --rh-user: subscription user for rhel."
    echo " -p | --rh-password: subcription password for rhel."
    echo " -o | --rh-pool-id: pool id to attach to in rhel."
    echo " -h | --help: print this usage message and exit"
    echo ""
    echo "Usage example: create_trove_image -d fedora -s mysql"
}

check_root() {
    local user=$(/usr/bin/id -u)
    if [ ${user} -ne 0 ]; then
        err "You need to be root (uid 0) to run this script."
        exit 1
    fi
}

parse_arguments() {
    while [[ $# > 0 ]]; do
        case "$1" in
            -d|--distro)
		export DISTRO=$2
                valid_distro_control
		shift 2
            ;;
            -s|--datastore)
                export DATASTORE=$2
		shift 2
            ;;
            -i|--local-image)
		# TODO(vkmc): Add option to use image in Glance
                export DIB_LOCAL_IMAGE=$2
		shift 2
            ;;
            -u|--rh-user)
                export REG_USER=$2
		shift 2
            ;;
            -p|--rh-password)
                export REG_PASSWORD=$2
		shift 2
            ;;
            -o|--rh-pool-id)
		export REG_POOL_ID=$2
		shift 2
            ;;
            -h|--help)
                print_usage
                exit 0
            ;;
            -*)
                err "Error: Unknown option: $1."
                exit 1
            ;;
            *)
                break
            ;;
         esac
    done
}

init_variables() {
    export DIB_REPO_PATH="/usr/share/diskimage-builder"
    export ELEMENTS_PATH="$DIB_REPO_PATH/elements:./elements"

    # TODO(vkmc): Make REG_METHOD configurable
    export REG_METHOD=portal
    export REG_MACHINE_NAME=trove

    export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive,EC2"
}

install_requirements() {
    sudo yum install -y diskimage-builder
}

valid_distro_control() {
    if [ "${DISTRO}" != "fedora" ] && [ "${DISTRO}" != "centos" ] && [ "${DISTRO}" != "rhel" ]; then
	err "Distro ${DISTRO} not supported. Valid options are fedora, centos or rhel."
        exit 1
    fi
}

required_params_control() {
    : ${DISTRO:?"Name of the system to use is required. Possible options are fedora, centos or rhel."}
    : ${DATASTORE:?"Name of the datastore to use required. Possible options are mysql or mongodb."}
}

rhel_subscription_control() {
    if [ "${DISTRO}" = "rhel" ]; then
        : ${REG_USER:?"You need to set RHEL subscription user."}
        : ${REG_PASSWORD:?"You need to set RHEL subscription password."}
        : ${REG_POOL_ID:?"You need to set RHEL pool ID."}
    fi
}

main() {
    check_root
    parse_arguments "$@"
    required_params_control
    rhel_subscription_control
    install_requirements
    init_variables
    disk-image-create -a amd64 -o ${DISTRO}-${DATASTORE}-guest-image -x --qemu-img-options compat=0.10  ${DISTRO}-${DATASTORE}-guest-image
    exit 0
}

main "$@"
