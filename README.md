# Rebase Labs

## Criar network no Docker
```shell
docker network create labs
```
## Iniciar banco de dados Postgres
```shell
docker run \
  --rm \
  --name db \
  -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql \
  -v $(pwd)/db/data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=password \
  --network labs \
  -d \
  -p 5432:5432 \
  postgres
```
## Iniciar servidor
```shell
docker run \
  --rm \
  --name labs \
  -it \
  -d \
  -v $(pwd):/app \
  -w /app \
  --network labs \
  -p 3000:3000 \
  ruby:3.2.2 \
  sh -c "bundle install && ruby app/lab_server.rb -o 0.0.0.0"
```
## Rodar testes
```shell
docker exec labs rspec
```
## Importar dados do CSV para o banco de dados
```shel
docker exec labs sh -c "ruby import_from_csv.rb"
```
## [Diagrama do banco de dados](https://dbdiagram.io/d/65e7c7eccd45b569fb9edec6)

# Endpoints

## /tests

Retorna uma lista com todos os exames cadastrados

Exemplo de resposta:

```json
[
  {
    "id": "1",
    "cpf": "048.973.170-88",
    "nome_paciente": "Emilly Batista Neto",
    "email_paciente": "gerald.crona@ebert-quigley.com",
    "data_nascimento_paciente": "2001-03-11",
    "endereco_rua_paciente": "165 Rua Rafaela",
    "cidade_paciente": "Ituverava",
    "estado_paciente": "Alagoas",
    "crm_medico": "B000BJ20J4",
    "crm_medico_estado": "PI",
    "nome_medico": "Maria Luiza Pires",
    "email_medico": "denna@wisozk.biz",
    "token_resultado_exame": "IQCZ17",
    "data_exame": "2021-08-05",
    "tipo_exame": "hemácias",
    "limites_tipo_exame": "45-52",
    "resultado_tipo_exame": "97"
  },
  {
    "id": "2",
    "cpf": "048.973.170-88",
    "nome_paciente": "Emilly Batista Neto",
    "email_paciente": "gerald.crona@ebert-quigley.com",
    "data_nascimento_paciente": "2001-03-11",
    "endereco_rua_paciente": "165 Rua Rafaela",
    "cidade_paciente": "Ituverava",
    "estado_paciente": "Alagoas",
    "crm_medico": "B000BJ20J4",
    "crm_medico_estado": "PI",
    "nome_medico": "Maria Luiza Pires",
    "email_medico": "denna@wisozk.biz",
    "token_resultado_exame": "IQCZ17",
    "data_exame": "2021-08-05",
    "tipo_exame": "leucócitos",
    "limites_tipo_exame": "9-61",
    "resultado_tipo_exame": "89"
  }
]
```
