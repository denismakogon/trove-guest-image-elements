Image elements for building Trove guest images
==============================================

Building prerequisites
----------------------

Each image for datastore should include next mandatory elements:

    ${DISTRO}-${DATASTORE}-guest-image (for example ubuntu-mysql-guest-image, ubuntu-cassandra-guest-image, etc.)


Instructions
------------

Checkout this source tree and also the diskimage builder, export an
ELEMENTS\PATH to add elements from this tree, and build any disk images you
need.

    sudo apt-get install qemu-utils python-virtualenv -qy
    virtualenv .venv
    source .venv/bin/activate
    pip install dib-utils pyyaml
    pip install git+https://github.com/openstack/diskimage-builder.git
    git clone https://github.com/openstack/tripleo-image-elements.git
    git clone https://github.com/denismakogon/trove-guest-image-elements.git
    export ELEMENTS_PATH=tripleo-image-elements/elements:trove-guest-image-elements/elements:diskimage-builder/elements

Building images
---------------

To build an image please run this commands:


    export TROVE_REMOTE_REPO="https://github.com/openstack/trove"
    export TROVE_REMOTE_REPO_BRANCH=master
    export DISTRO=ubuntu
    export DATASTORE=...
    export DATASTORE_VERSION=...
    export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive"
    disk-image-create -a amd64 \
        -o ${DISTRO}-${DATASTORE}-${DATASTORE_VERSION}-guest-image \
        -x --qemu-img-options compat=0.10 \
        ${DISTRO}-${DATASTORE}-guest-image

    Note. Only anonymous HTTP(S) accessable Git repos are allowed.

    For example:

        Cassandra datastore:

            export DATASTORE="cassandra"
            export DATASTORE_VERSION="2.1.1"

    If DATASTORE VERSION wasn't mentioned each datastore image element would use its own default version.
    For example:

        PostgreSQL datastore:

            export DATASTORE="postgresql"
            default datastore version 9.3 would be picked


If you want to build image for development purposes please add next elements into previos command:

    openssh-server

If you want to build image for vCenter please add next elements:

    ${DISTOR}-vmware-tools

Note: this elements are orientied to work with Debian/Ubuntu 14.04 Trusty Tahr
