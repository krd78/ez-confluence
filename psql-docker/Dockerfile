FROM debian:stretch

WORKDIR /opt

# Required packages
RUN apt-get update && apt-get -y install \
  postgresql postgresql-contrib postgresql-client libpq-dev

RUN echo "host confluencedb dbadmin 0.0.0.0/0 trust" >> /etc/postgresql/9.6/main/pg_hba.conf

# Install PostgreSQL
USER postgres
# Change the password if necessary
RUN sh /etc/init.d/postgresql start && \
    psql -c "create user dbadmin;" && \
    psql -c "alter user dbadmin with encrypted password 'db4dm1npa55w0rd'" && \
    psql -c "alter user dbadmin CREATEDB;" && \
    psql -c "create database confluencedb;"

# Change listen_addresses if necessary
CMD exec /usr/lib/postgresql/9.6/bin/postgres \
    -D /var/lib/postgresql/9.6/main \
    -c "config_file=/etc/postgresql/9.6/main/postgresql.conf" \
    -c "listen_addresses=*"
