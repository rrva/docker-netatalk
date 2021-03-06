#!/bin/bash
if [ ! -z "${AFP_USER}" ]; then
    if [ ! -z "${AFP_UID}" ]; then
        cmd="$cmd --uid ${AFP_UID}"
    fi
    if [ ! -z "${AFP_GID}" ]; then
        cmd="$cmd --gid ${AFP_GID}"
    fi
    adduser $cmd --no-create-home --disabled-password --gecos '' "${AFP_USER}"
    if [ ! -z "${AFP_PASSWORD}" ]; then
        echo "${AFP_USER}:${AFP_PASSWORD}" | chpasswd
    fi
fi
[ ! -d /media/share ] && mkdir /media/share && chown "${AFP_USER}" /media/share && echo "use -v /my/dir/to/share:/media/share" > readme.txt
sed -i'' -e "s,%USER%,${AFP_USER:-},g" /etc/afp.conf
echo ---begin-afp.conf--
cat /etc/afp.conf
echo ---end---afp.conf--
mkdir /var/run/dbus
dbus-daemon --system
avahi-daemon -D
exec netatalk -d
