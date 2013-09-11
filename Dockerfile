FROM ubuntu:12.04
MAINTAINER Arcus "http://arcus.io"
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive apt-get install -y wget apache2 libapache2-mod-wsgi python-setuptools memcached build-essential python-dev supervisor python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 collectd
RUN easy_install pip
RUN pip install whisper carbon graphite-web bucky django-tagging

ADD supervisor.conf /etc/supervisor/supervisor.conf
ADD bucky.cfg /etc/bucky.cfg
ADD carbon.conf /opt/graphite/conf/carbon.conf
ADD graphite.wsgi /opt/graphite/conf/graphite.wsgi
ADD local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD vhost-graphite.conf /etc/apache2/sites-available/default

RUN (cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput)
RUN (cd /opt/graphite && chown -R www-data:www-data storage)

ADD apache_start.sh /usr/local/bin/apache_start
ADD run.sh /usr/local/bin/run

EXPOSE 80
EXPOSE 2003
EXPOSE 2004
EXPOSE 2013
EXPOSE 2014
EXPOSE 2023
EXPOSE 2024
EXPOSE 7002
EXPOSE 8125
EXPOSE 23632
EXPOSE 25826
CMD ["/usr/local/bin/run"]