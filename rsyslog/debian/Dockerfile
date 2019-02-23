FROM debian:9

# https://www.linuxprobe.com/centos-rsyslogloganalyzer-mysql.html
# https://www.cnblogs.com/mchina/p/linux-centos-rsyslog-loganalyzer-mysql-log-server.html
# https://blog.csdn.net/qq_37187976/article/details/79231854
# https://www.cnblogs.com/Eivll0m/p/6700828.html

ARG LOGANALYZER_VERSION="4.1.7"
ARG RSYSLOG_VERSION="8.24.0"

ARG RUNTIME_DEPS="rsyslog=${RSYSLOG_VERSION} rsyslog-mysql apache2 php php-mysql php-gd"
ARG BUILD_DEPS="wget expect"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
  && echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib"                       >> /etc/apt/sources.list \
  && echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib"               >> /etc/apt/sources.list \
  && echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib"             >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib"                   >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib"           >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib"         >> /etc/apt/sources.list \
  && echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib"      >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib"  >> /etc/apt/sources.list

RUN apt-get update -y && apt-get update \
  && apt-get install -y ${BUILD_DEPS} \
  && wget -O- "http://192.168.100.70:8080/loganalyzer-${LOGANALYZER_VERSION}.tar.gz" | tar xz \
  && mkdir -p /var/www/html/loganalyzer \
  && cp -a loganalyzer-${LOGANALYZER_VERSION}/src /var/www/html/loganalyzer \
  && rm -rf /loganalyzer-${LOGANALYZER_VERSION} \
  && rm -rf /pax_global_header \
  && cd /var/www/html/loganalyzer \
  && touch config.php \
  && chmod 666 config.php \
  && apt-get remove --purge -y ${BUILD_DEPS} \
  && printf "\
  set timeout -1\n \
  spawn apt-get install -y ${RUNTIME_DEPS} \n \
  expect {\n \
    \"Configure database for rsyslog-mysql with dbconfig-common? \\\\\\\\\[yes/no\\\\\\\\\]\" { send \"no\\\n\" } \n \
  }\n \
  expect eof\n \
  " | expect \
  && apt-get autoclean && apt-get clean && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

VOLUME [ "/config" ]

CMD ["rsyslog"]
