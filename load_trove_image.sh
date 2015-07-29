#!/bin/bash

set -e

err() {
    echo "${0##*/}: $@" >&2
}

print_usage() {
    echo "Usage: ${0##*/} [-s datastore] [-v datastore_version] [-p packages] [-i image id]"
    echo "Options:"
    echo " -s | --datastore: name of the datastore. Possible options are mysql or mongodb."
    echo " -v | --datastore-version: name of the datastore version."
    echo " -p | --packages: packages required by the datastore version that are installed on the guest image."
    echo " -i | --image-id: ID of the image used to create an instance of the datastore version."
    echo " -h | --help: print this usage message and exit."
    echo ""
    echo "Usage example: load_trove_image -s mysql -v fedora-mysql5.5 -p mysql-server=5.5 -i cf82462a-956c-4609-8413-a1eba1ba9dbd"
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
            -s|--datastore)
		export DATASTORE=$2
                valid_datastore_control
		shift 2
            ;;
            -v|--datastore-version)
                export DATASTORE_VERSION=$2
		shift 2
            ;;
            -p|--packages)
                export PACKAGES=$2
		shift 2
            ;;
            -i|--image-id)
                export IMAGE_ID=$2
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

valid_datastore_control() {
    if [ "${DATASTORE}" != "mysql" ] && [ "${DATASTORE}" != "mongodb" ]; then
	err "Datastore ${DATASTORE} not supported. Valid options are mysql or mongodb."
        exit 1
    fi
}

required_params_control() {
    : ${DATASTORE:?"Name of the system to use is required. Possible options are fedora, centos or rhel."}
    : ${DATASTORE_VERSION:?"Version of the datastore to use required."}
    : ${PACKAGES:?"Packages required by the datastore version required."}
    : ${IMAGE_ID:?"ID of image to use required."}
}

main() {
    check_root
    parse_arguments "$@"
    required_params_control
    trove-manage datastore_update ${DATASTORE} ""
    trove-manage datastore_version_update ${DATASTORE} ${DATASTORE_VERSION} ${DATASTORE} ${IMAGE_ID} ${PACKAGES} 1
    trove-manage datastore_update ${DATASTORE} ${DATASTORE_VERSION}
    exit 0
}

main "$@"
