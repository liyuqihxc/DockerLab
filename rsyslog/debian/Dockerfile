FROM debian:9

# https://www.linuxprobe.com/centos-rsyslogloganalyzer-mysql.html
# https://www.cnblogs.com/mchina/p/linux-centos-rsyslog-loganalyzer-mysql-log-server.html
# https://blog.csdn.net/qq_37187976/article/details/79231854
# https://www.cnblogs.com/Eivll0m/p/6700828.html

ARG RUNTIME_DEPS="rsyslog httpd php php-mysql php-gd rsyslog-mysql"
ARG BUILD_DEPS="wget"

ARG LOGANALYZER_VERSION="4.1.7"

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
    && wget -O- http://download.adiscon.com/loganalyzer/loganalyzer-${LOGANALYZER_VERSION}.tar.gz | tar xz \
    && cp -a loganalyzer-${LOGANALYZER_VERSION}/src /var/www/html/loganalyzer \
    && cd /var/www/html/loganalyzer \
    && touch config.php \
    && chmod 666 config.php \
    \
    && apt-get remove --purge -y ${BUILD_DEPS} \
    && apt-get install -y ${RUNTIME_DEPS} \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/data" ]

CMD ["rsyslog"]