#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER=${USER:-${DEFAULT_USER}}
GROUP=${GROUP:-${USER}}
PASSWD=${PASSWD:-${DEFAULT_PASSWD}}
NeW_USER=false

unset DEFAULT_USER DEFAULT_PASSWD

# is creating continar ?
if [ -e /tmp/uninitilze ]; then

    # Add group
    if [[ $GROUP_ID != "0" && ! $(getent group $GROUP) ]]; then
        echo "Create New Group GROUP_ID: $GROUP_ID GROUP: $GROUP"
        groupadd -g $GROUP_ID $GROUP
    fi

    # Add user
    if [[ $USER_ID != "0" && ! $(getent passwd $USER) ]]; then
        echo "Create New User USER_ID: $USER_ID USER: $USER"
        export HOME=/home/$USER
        useradd -d ${HOME} -m -s /bin/bash -u $USER_ID -g $GROUP_ID -G 27 $USER
    fi

    # Set login user name
    USER=$(whoami)

    # Set login password
    echo ${USER}:${PASSWD} | sudo chpasswd

    # Revert permissions
    sudo chmod u-s /usr/sbin/useradd
    sudo chmod u-s /usr/sbin/groupadd
    sudo chmod u-s /usr/sbin/chpasswd
    sudo rm -f /tmp/uninitilze 
    sudo rm -f /etc/sudoers.d/ALL
fi
        
# Set login user name
USER=$(whoami)
echo "USER: $USER"

# Set login password
echo "PASSWD: $PASSWD"

unset PASSWD
if [[ "$@" = "" ]]; then
    exec /bin/bash
else 
    exec "$@"
fi
