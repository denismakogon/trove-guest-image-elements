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
    git clone https://github.com/denismakogon/trove-guest-image-elements.git
    git clone https://git.openstack.org/openstack/diskimage-builder.git
    git clone https://git.openstack.org/openstack/tripleo-image-elements.git
    export ELEMENTS_PATH=tripleo-image-elements/elements:trove-guest-image-elements/elements:diskimage-builder/elements


