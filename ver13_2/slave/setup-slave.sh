#!/bin/bash
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass

echo "host    replication     replicator      0.0.0.0/0               md5" >> "$PGDATA/pg_hba.conf"
echo "host    all             all             all                     md5" >> "$PGDATA/pg_hba.conf"
