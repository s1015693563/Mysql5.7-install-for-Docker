#!/bin/bash
#This script is initalize docker,mysql5.7 image and runner for Centos7
#author=lxh
#date 2021/7/20/10:45:07

. /etc/init.d/functions

DATADIR="/data/mysql/data"     #/var/lib/mysql
TMPDIR="/data/mysql/tmp"       #/tmp
ETCDIR="/data/mysql/conf.d"    #/etc/mysql/conf.d
LOGDIR="/data/mysql/logs"	   #/logs

if [ ! -d ${DATADIR} -a ! -d ${TMPDIR} -a ! -d ${ETCDIR} ]; then
	mkdir -m 777 -p ${DATADIR}
	mkdir -m 777 -p ${LOGDIR}
	mkdir -p ${TMPDIR}
	mkdir -p ${ETCDIR};
fi

function mysql_conf () {
cat >> ${ETCDIR}/mysql.cnf << EOF
[mysql]

[mysqld]
skip-host-cache
skip-name-resolve
lower_case_table_names = 1
sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

[mysqldump]
quick
quote-names
max_allowed_packet	= 16M
EOF

}

function mysql_set_root () {
cat >>${ETCDIR}/root.sql <<EOF
grant all privileges on *.* to root@'%' identified by '123456' with grant option;
flush privileges;
EOF

}

if [ ! -e ${ETCDIR}/mysql.cnf ];then
	mysql_conf
	[ $? -eq 0 ] && action "create mysql.conf is done" /bin/true
fi

if [ ! -e ${ETCDIR}/root.sql  ];then
	mysql_set_root
	[ $? -eq 0 ] && action "create root.sql is done" /bin/true
fi

docker container rm -f mysql_5.7 >> /dev/null 2>&1

if docker load -i ./mysql_5.7.tar;then

docker container run -d --restart=always --privileged=true -p 3306:3306 \
--name="mysql_5.7" -v ${DATADIR}:/var/lib/mysql -v ${ETCDIR}:/etc/mysql/conf.d/ \
-v ${LOGDIR}:/logs \
-e MYSQL_ROOT_PASSWORD=root1234 -e MYSQL_USER=test -e MYSQL_PASSWORD=test1234 \
mysql:5.7
[ $? -eq 0 ] && action "docker run is done" /bin/true \
|| action "docker run is failed" /bin/false

fi

/bin/cp -a ./root.sh ${ETCDIR}

docker exec -it mysql_5.7 /bin/bash -c '/etc/mysql/conf.d/root.sh'

#END
