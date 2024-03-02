# Rebase Labs

## Rodar a aplicação em um container Docker
```shell
docker run --rm --name labs -it -v $(pwd):/app -w /app -p 3000:3000 ruby:3.2.2 sh -c "bundle install && ruby app/lab_server.rb -o 0.0.0.0"
```
