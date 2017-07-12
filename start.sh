#!/bin/bash
if [ ! -f /vietcli-pw.txt ]; then
    #mysql has to be started this way as it doesn't work to call from /etc/init.d
    /usr/bin/mysqld_safe &
    sleep 10s
    # Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
    ROOT_PASSWORD=`pwgen -c -n -1 12`
    VIETCLI_PASSWORD="vietcli"
    # echo "vietcli:$MAGENTO_PASSWORD" | chpasswd
    echo "root:$ROOT_PASSWORD" | chpasswd

    #This is so the passwords show up in logs.
    echo root password: $ROOT_PASSWORD
    echo vietcli password: $VIETCLI_PASSWORD
    echo $ROOT_PASSWORD > /root-pw.txt
    echo $VIETCLI_PASSWORD > /vietcli-pw.txt

fi

if [ ! -f /home/vietcli/files/html/nginx.conf.sample ]; then
    touch /home/vietcli/files/html/nginx.conf.sample
    chown -R magento: /home/vietcli/files/html/
fi

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf