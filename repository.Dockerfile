FROM ruby:slim-stretch

RUN set -x \
        && apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            wget \
            cron \
            supervisor \
            subversion \
            apache2 \
            libapache2-mod-svn libapache-dbi-perl \
            libapache2-mod-perl2 libdbd-pg-perl libdigest-sha-perl \
            libauthen-simple-ldap-perl \
        && rm -rf /var/lib/apt/lists/* \
        && sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

RUN set -x \
        && wget -O /usr/share/perl5/Apache/Redmine.pm "https://raw.githubusercontent.com/redmine/redmine/master/extra/svn/Redmine.pm" \
        && wget -O /usr/local/bin/reposman.rb "https://raw.githubusercontent.com/redmine/redmine/master/extra/svn/reposman.rb" \
        && chmod +x /usr/local/bin/reposman.rb

RUN set -x \
        && a2enmod dav \
        && a2enmod dav_svn \
        && a2enmod dav_fs \
        && a2enmod perl \
        && a2enmod authz_host

RUN set -x \
        && mkdir /etc/apache2/conf.d/ \
        && echo "IncludeOptional conf.d/*.conf" >> /etc/apache2/apache2.conf

RUN set -x \
        && gem install activeresource

WORKDIR /var/svn
RUN set -x \
        && chown -R www-data:www-data ./

VOLUME /var/svn
VOLUME /etc/apache2/conf.d
VOLUME /etc/cron.d

EXPOSE 80

COPY apache2.conf /etc/supervisor/conf.d/apache2.conf
COPY cron.conf /etc/supervisor/conf.d/cron.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
