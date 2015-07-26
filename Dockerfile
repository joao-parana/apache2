FROM ubuntu:14.04 

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2015-07-25

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y apache2

# acertando o Ambiente
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

# criando os diretórios
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# enviando access log para stdout e ErrorLog para stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
  s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
  s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' '{}' ';'

VOLUME ["/var/www/html"]

EXPOSE 80

CMD ["apache2", "-D", "FOREGROUND"]