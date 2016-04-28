# Disable IPV6

To disable ipv6, you have to open `/etc/sysctl.conf` using any text editor and insert the following lines at the end:

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

Activate it

```
sudo sysctl -p
```

To verify the result

```
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```

If you see `1`, ipv6 has been successfully disabled.

# Change HostName

Edit `/etc/hostname` with following content

```
abc.xyz.com
```

Edit `/ect/hosts` with the following content

```
127.0.0.1       localhost.localdomain   localhost
xxx.xxx.xxx.xxx abc.xyz.com             abc
```

Activate the new hostname

```
service hostname restart
```

Verify it

```
hostname
ping abc
ping abc.xyz.com
```

You also need to change reversed DNS in (https://panel.cloudatcost.com/index.php)
```
host -t PTR xxx.xxx.xxx.xxx
```
If it gives you something different than your expected, something is wrong.
# Install NTP service

```
sudo apt-get install ntp
```

# Install Cloudera Manager

```
wget https://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
./cloudera-manager-installer.bin
```

Wait couples of minutes for the server to starting up and verify the status
```
netstat | grep 7180
telnet abc.xyz.com 7180
python -c 'import socket; import sys; s = socket.socket(socket.AF_INET); s.settimeout(5.0); s.connect((sys.argv[1], int(sys.argv[2]))); s.close();' abc.xyz.com 7182
```

# Enhance

It is suggested to modify the swapness of the server from 60 to 10, which can be done by 

```
sysctl vm.swappiness=10
```

To save this modification after rebooting, edit `/etc/sysctl.conf` to append a new line:

```
vm.swappiness = 10
```
