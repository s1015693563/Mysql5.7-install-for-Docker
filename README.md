
0、确定解压目录下存有docker.sh、mysql_5.7.tar、root.sh

1、给予*.sh 700权限,chmod 777 *.sh

2、确定宿主机下的3306端口未被占用

3、关闭firewall，systemctl stop firewall，或者firewall-cmd --add-port=3306/tcp --permanent，firewall-cmd --reload

4、执行setenforce 0,sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config

5、解压docker.tar.gz包安装docker：rpm -ivh --nodeps --force *.rpm

6、设置docker开机自起,systemctl daemon-reload，systemctl enable docker，systemct start docker

6、执行./docker.sh

7、执行docker container ls,查看运行状态是否为UP，port是否为0.0.0.0:3306-->172.17.0.2:3306

8、可以执行安装mysql客户端测试 mysql -u root -proot1234 -h [本机ip]

9、进入mysql容器查看，docker container exec -it mysql_5.7 /bin/bash

10、mysql的Voleme映射：-v，可以根据脚本三个传参修改↓

DATADIR="/data/mysql/data"     #对应mysql容器的/var/lib/mysql，用于存放mysql的data数据库文件

TMPDIR="/data/mysql/tmp"       #对应mysql容器的/tmp，用于存放mysql运行时生成的socket文件

ETCDIR="/data/mysql/conf.d"    #对应mysql/etc/mysql/conf.d，用于存放mysql配置文件

11、Mysql5.7镜像（百度云）：https://pan.baidu.com/s/1DPdKtyJZKtMbBe5Ae3UrtQ 提取码：1234
