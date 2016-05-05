if [ "$#" -ne 1 ]
then
	echo 'type: datanode'
	type=datanode
else
	if [ "$1" = namenode ]
	then
		echo 'type: namenode'
		type=namenode
	else
		echo 'type: datanode'
		type=datanode
	fi
fi

echo 'install java'
apt-get update
apt-get install -y openjdk-7-jdk
java -version

echo 'install hadoop'
wget http://www.carfab.com/apachesoftware/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
tar xvf hadoop-* -C /usr/local
mv /usr/local/hadoop-* /usr/local/hadoop

echo 'obtain conf.tar'
scp root@45.62.236.40:/root/conf.tar .

echo 'configure hadoop'
# apt-get install vim
tar -xf conf.tar
cp -f conf/.profile .profile
cp -f conf/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh
cp -f conf/core-site.xml $HADOOP_CONF_DIR/core-site.xml
cp -f conf/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml
cp -f conf/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
cp -f conf/hosts /etc/hosts
# only required for namenode
if [ "$type" = namenode ]
then
	cp -f conf/slaves $HADOOP_CONF_DIR/slaves
	cp -f conf/masters $HADOOP_CONF_DIR/masters
	cp -f conf/hdfs-site-namenode.xml $HADOOP_CONF_DIR/hdfs-site.xml
	mkdir -p $HADOOP_HOME/hadoop_data/hdfs/namenode
else
	cp -f conf/hdfs-site-datanode.xml $HADOOP_CONF_DIR/hdfs-site.xml
	mkdir -p $HADOOP_HOME/hadoop_data/hdfs/datanode
fi
rm -rf conf

echo 'change password of root'
passwd

echo 'add new user'
adduser zhangtemplar

echo 'change permission of hadoop home user'
chown -R zhangtemplar $HADOOP_HOME

echo 'one more thing: please change your hostname according to'
cat /etc/hosts
