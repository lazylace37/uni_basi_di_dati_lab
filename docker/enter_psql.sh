if [ $(uname) = "Darwin" ]; then
        DOCKER=container
else
        DOCKER=docker
fi

$DOCKER exec -it -i industria_cinematografica-db psql -U postgres -d industria_cinematografica
