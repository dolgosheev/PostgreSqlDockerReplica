#!/bin/bash
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass

echo "host    replication     replicator      0.0.0.0/0               md5" >> "$PGDATA/pg_hba.conf"
echo "host    all             all             all                     md5" >> "$PGDATA/pg_hba.conf"

set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $PG_REP_USER WITH REPLICATION ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
    SELECT * FROM pg_create_physical_replication_slot('$SLAVE_SLOT');
    select pg_reload_conf();
EOSQL

pg_basebackup -D /tmp/backup -S $SLAVE_SLOT -X stream -P -U $POSTGRES_USER -Fp -R -W

echo "primary_conninfo = 'host=$HOST_MASTER port=$PORT user=$PG_REP_USER password=$PG_REP_PASSWORD'" > /tmp/backup/postgresql.auto.conf
echo "primary_slot_name = '$SLAVE_SLOT'" >> /tmp/backup/postgresql.auto.conf
echo "restore_command = 'cp /var/lib/postgresql/data/pg_wal/%f \"%p\"'" >> /tmp/backup/postgresql.auto.conf