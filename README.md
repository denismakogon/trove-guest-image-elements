Image elements for building Trove guest images
==============================================

Building prerequisites
----------------------

Ubuntu Distro: Each image for datastore should include next mandatory elements:

    ${DISTRO}-${DATASTORE}-guest-image (for example ubuntu-mysql-guest-image, ubuntu-cassandra-guest-image, etc.)

RHEL & CentOS: Each image for datastore should include next mandatory elements:

    ${DISTRO}-${DATASTORE}-guest-image (for example rhel-mysql-guest-image, rhel-mongodb-guest-image, etc.)

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

	export DISTRO=ubuntu 
	export DATASTORE=mysql
	export DATASTORE_VERSION=5.6
	export DIB_CLOUD_INIT_ETC_HOSTS=true
	export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive"
	export DIB_DEV_USER_USERNAME=ks
	export DIB_DEV_USER_PASSWORD=w8EmsJXTMaG0e97NK8lM
	export DIB_DEV_USER_SHELL=/bin/bash
	export DIB_DEV_USER_PWDLESS_SUDO=true
	export DIB_DEV_USER_AUTHORIZED_KEYS=/home/sa709c/.ssh/authorized_keys    
	
For Trove Guest agent config:

	export DIB_TROVE_RABBITMQ_HOSTS=172.24.4.18:5672
	export DIB_TROVE_RABBIT_USERID=guest
	export DIB_TROVE_RABBIT_PASSWORD=guest
	export DIB_TROVE_RABBIT_USE_SSL=false
	export DIB_TROVE_AUTH_URL=http://172.24.8.18:35357/v2.0
	export DIB_TROVE_NOVA_PROXY_ADMIN_USER=nova
	export DIB_TROVE_NOVA_PROXY_ADMIN_PASS=devstack
	export DIB_TROVE_NOVA_PROXY_ADMIN_TENANT_NAME=service
	export DIB_TROVE_SWIFT_URL=http://172.24.8.18:8080/v1/AUTH_
	export DIB_TROVE_SWIFT_SERVICE_TYPE=object-store
	export DIB_TROVE_BACKUP_SWIFT_CONTAINER=database_backups
  
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

    ${DISTRO}-vmware-tools

Note: this elements are orientied to work with Debian/Ubuntu 14.04 Trusty Tahr


RHEL without the script
-----------------------

To build an image without the script, make sure you have diskimage-builder installed (yum install -y diskimage-builder)
and run the following commands:

    # RHEL related required env
    export REG_METHOD=portal
    export REG_USER=<user>
    export REG_PASSWORD=<password>
    export REG_MACHINE_NAME=trove
    export REG_POOL_ID=<pool>

    # DIB related required env
    export DISTRO=<distro>
    export DATASTORE=<datastore>
    export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive"
    disk-image-create -a amd64 \
        -o ${DISTRO}-${DATASTORE}-guest-image \
        -x --qemu-img-options compat=0.10 \
        ${DISTRO}-${DATASTORE}-guest-image

    Note. Only anonymous HTTP(S) accessable Git repos are allowed.

RHEL with the script
---------------

Simply run 'sudo ./create-trove-image.sh -h' to see run instructions.



Based on
--------

https://github.com/denismakogon/trove-guest-image-elements

https://github.com/vkmc/trove-image-elements