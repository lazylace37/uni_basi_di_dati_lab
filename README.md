Per compilare:

`typst watch progetto.typ`

Setup database:

```bash
psql -d $USER \
    -c "DROP DATABASE industria_cinematografica WITH (FORCE);" \
    -c "CREATE DATABASE industria_cinematografica;"

psql -d industria_cinematografica \
    -c "\i setup/create.sql"    \
    -c "\i setup/trigger_1.sql" \
    -c "\i setup/trigger_2.sql" \
    -c "\i setup/trigger_3.sql" \
    -c "\i setup/trigger_4.sql" \
    -c "\i seed/seed.sql"       \
    -c "\i setup/query_1.sql"   \
    -c "\i setup/query_2.sql"   \
    -c "\i setup/query_3.sql"   \
    -c "\i setup/query_4.sql"
```
