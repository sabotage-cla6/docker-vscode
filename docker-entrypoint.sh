#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER=${USER}
GROUP=${GROUP:-${USER}}
PASSWD=${PASSWD}
NeW_USER=false

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

    # Set login password
    USER=$(whoami)
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
echo "PASSWD: $PASSWD"

unset PASSWD
if [[ "$@" = "" ]]; then
    exec /bin/bash
else 
    exec "$@"
fi
