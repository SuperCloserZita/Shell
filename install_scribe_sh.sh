#!/bin/bash
#Use to install Scribe
# Author feixiang

#mkdir /tmp/deps
cd /tmp/deps
if [ -e /tmp/deps/Scribe.zip ]
then 
 echo "=================================="    
 echo "Now begin to unzip softpackage...."
 echo "=================================="
 sleep 5
       unzip Scribe.zip 
else
      echo "Please confirm that softpackage exits£¡"
     exit 1
fi

yum -y install automake libtool flex bison pkgconfig gcc-c++ boost-devel libevent-devel zlib-devel python-devel ruby-devel libxml2 libxml2-devel byacc libevent

#install m4
cd /tmp/deps/Scribe
tar xzvf m4-1.4.15.tar.gz
cd m4-1.4.15/
./configure --prefix=/usr/local/services/m4
make
make install
export PATH=/usr/local/services/m4/bin/:$PATH

#install autoconf
cd /tmp/deps/Scribe
tar xzvf autoconf-2.68.tar.gz
cd autoconf-2.68/
./configure --prefix=/usr/local/services/autoconf/
make
make install
export PATH=/usr/local/services/autoconf/bin/:$PATH

#install automake
cd /tmp/deps/Scribe
tar xvf automake-1.11.tar.gz
cd automake-1.11/
./configure --prefix=/usr/local/services/automake/
make
make install

#install boost
cd /tmp/deps/Scribe
tar xvf boost_1_44_0.tar.bz2
cd boost_1_44_0/
./bootstrap.sh --with-python=/usr/local/services/python/lib/python2.7 \
 --with-python=2.7.2 \
 --with-icu=/usr/local/lib/icu \
 --prefix=/usr/local/services/boost
./bjam --prefix=/usr/local/services/boost install
echo "/usr/local/services/boost/lib" >> /etc/ld.so.conf
echo "/usr/local/services/boost/include" >> /etc/ld.so.conf
ldconfig

#install libtool
cd /tmp/deps/Scribe
tar xzvf libtool-2.4.tar.gz
cd libtool-2.4/
./configure --prefix=/usr/local/services/libtool
make install
export PATH=/usr/local/services/libtool/bin/:$PATH

#install thrift
cd /tmp/deps/Scribe
tar xzvf thrift-0.8.0.tar.gz
cd thrift-0.8.0/
export PY_PREFIX=/usr/local/services/python/
./configure --prefix=/usr/local/services/thrift \
 --with-csharp=no \
 --with-java=no \
 --with-erlang=no \
 --with-perl=no \
 --with-php=no \
 --with-ruby=no \
 --with-boost=/usr/local/services/boost/
make
make install
echo "/usr/local/services/thrift/lib" >> /etc/ld.so.conf
ldconfig

sed -i '1i\#include <arpa/inet.h>' /usr/local/services/thrift/include/thrift/protocol/TBinaryProtocol.tcc
sed -i '1i\#include <netinet/in.h>' /usr/local/services/thrift/include/thrift/transport/TSocket.h

#install fb303
cd contrib/fb303/
export CPPFLAGS= "-DHAVE_NETDB_H=1 -fpermissive"
./bootstrap.sh
CXXFLAGS="-Wall -O3 -fpermissive" \
./configure --prefix=/usr/local/services/fb303 \
 --with-boost=/usr/local/services/boost/ \
 --with-thriftpath=/usr/local/services/thrift/ 
make
make install

#install facebook_scribe
cd /tmp/deps/Scribe
tar xvf facebook-scribe-63e4824.tar.gz
cd facebook-scribe-63e4824/
./bootstrap.sh --prefix=/usr/local/services/scribe \
 --with-thriftpath=/usr/local/services/thrift/ \
 --with-fb303path=/usr/local/services/fb303/ \
 --with-boost=/usr/local/services/boost/
make
make install

echo "====================================================="
echo "Congratulation£¬Install process complete successfully"
echo "====================================================="