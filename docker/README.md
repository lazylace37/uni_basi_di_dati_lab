# Steps:

Start the postgres container:
```sh
cd docker
docker compose up
```

Login into the postgres console:
```sh
./enter_psql.sh
```

Inside the postgres console, create the database and run the queries:
```sh
\i db/create.sql
\i db/trigger_1.sql
\i db/trigger_2.sql
\i db/trigger_3.sql
\i db/trigger_4.sql
\i db/trigger_5.sql
\i db/seed.sql
\i db/operation_1__query_1.sql
\i db/operation_2__query_2.sql
\i db/operation_3__query_3.sql
\i db/operation_4__query_4.sql
\i db/operation_6__query_5.sql
\i db/operation_8__query_6.sql

\i db/operation_5__insertion_1_instanced.sql
\i db/operation_7__insertion_2_instanced.sql
\i db/operation_9__deletion_1_instanced.sql
```

Shutdown:
```sh
docker compose down
```
