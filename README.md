Image elements for building Trove guest images
==============================================

Building prerequisites
----------------------

Each image for datastore should include next mandatory elements:

    datastore (for example mysql, cassandra, etc.)
    trove-guest


Each image for datastore might include next optional elements:

    openssh_server
    ssh_key_injection


Instructions
------------

Checkout this source tree and also the diskimage builder, export an
ELEMENTS\PATH to add elements from this tree, and build any disk images you
need.

    virtualenv .
    source bin/activate
    pip install dib-utils pyyaml
    pip install git+https://github.com/openstack/diskimage-builder.git
    git clone https://github.com/openstack/tripleo-image-elements.git
    git clone https://github.com/denismakogon/trove-guest-image-elements.git
    export ELEMENTS_PATH=tripleo-image-elements/elements:trove-guest-image-elements/elements:diskimage-builder/elements

Building images
---------------

To build an image please run this commands:

    export DATASTORE="mysql"
    disk-image-create -a amd64 -o ${DATASTORE}_trove-5.5 -x --qemu-img-options compat=0.10 \
        ubuntu vm ${DATASTORE} trove-guest

If you want to build image for development purposes please add next elements into previos command:

    ssh_keys_injection
    openssh_server
