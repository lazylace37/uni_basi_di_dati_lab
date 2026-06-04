# Steps

Ensure postgres is running and create the database:
```sh
psql -d $USER \
    -c "CREATE DATABASE industria_cinematografica;"
```

Seed and run queries:
```sh
psql -d industria_cinematografica -P pager \
    -c "\i db/create.sql"    \
    -c "\i db/trigger_1.sql" \
    -c "\i db/trigger_2.sql" \
    -c "\i db/trigger_3.sql" \
    -c "\i db/trigger_4.sql" \
    -c "\i db/trigger_5.sql" \
    -c "\i db/seed.sql"       \
    -c "\i db/operation_1__query_1.sql"   \
    -c "\i db/operation_2__query_2.sql"   \
    -c "\i db/operation_3__query_3.sql"   \
    -c "\i db/operation_4__query_4.sql"   \
    -c "\i db/operation_6__query_5.sql"   \
    -c "\i db/operation_8__query_6.sql"
```

Run insertion and deletion example queries:
```sh
psql -d industria_cinematografica -P pager \
    -c "\i db/operation_5__insertion_1_instanced.sql" \
    -c "\i db/operation_7__insertion_2_instanced.sql" \
    -c "\i db/operation_9__deletion_1_instanced.sql"
```
