# Rebase Labs

## Criar network no Docker
```shell
docker network create labs
```

## Iniciar banco de dados Postgres
```shell
docker run --rm --name db -d -v $(pwd)/db:/var/lib/postgresql/data -e POSTGRES_PASSWORD=password --network labs -p 5432:5432 postgres
```

## Rodar a aplicação em um container Docker

### Instalar dependências e iniciar servidor
```shell
docker run --rm --name labs -it -v $(pwd):/app -w /app --network labs -p 3000:3000 ruby:3.2.2 sh -c "bundle install && ruby app/lab_server.rb -o 0.0.0.0"
```

### Rodar os testes em outro terminal
```shell
docker exec labs rspec
```

