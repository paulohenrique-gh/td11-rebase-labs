# Rebase Labs

## Informações gerais

Aplicação para listagem de exames médicos. Parte do Rebase Labs na turma 11 do TreinaDev.

**Linguagem de programação**: Ruby

**Banco de dados**: Postgres

**Gems**:
- puma
- rackup
- sinatra
- faraday
- faraday-multipart
- rspec
- rack-test
- sidekiq

A aplicação foi dividida em backend,

## Pré-requisitos

É necessário ter o [Docker](https://www.docker.com/get-started/) instalado antes de realizar a configuração no próximo passo.

## Configuração

Execute os comandos abaixo para clonar o repositório e entrar no diretório da aplicação:

```bash
git clone git@github.com:paulohenrique-gh/td11-rebase-labs.git
```
```bash
cd td11-rebase-labs
```

Com o Docker instalado, execute o comando abaixo para subir as aplicações:

```bash
docker compose up
```
URL base da API: http://localhost:3000

Frontend: http://localhost:4000

## Testes

Utilizar o comando abaixo para executar a suite de testes do backend:
```bash
docker exec labs-backend rspec
```

## Importar dados do CSV para o banco de dados

Aplicação inicia sem dados cadastrados.

Para importar manualmente os dados do arquivo `data.csv` para o banco de dados, execute:
```bash
docker exec labs-backend bash -c "ruby import_from_csv.rb"
```

## Banco de dados

Foram criados dois bancos de dados, um para desenvolvimento e outro para testes. A aplicação no backend foi configurada de forma que a cada teste os dados do banco de testes sejam excluídos.

Foram criadas 4 tabelas a partir dos dados brutos do CSV.
[Aqui](https://dbdiagram.io/d/65e7c7eccd45b569fb9edec6) tem o diagrama com as tabelas e as relações.

[![labs-database.png](https://i.postimg.cc/0yrCqCMH/labs-database.png)](https://postimg.cc/VJQtqnFj)

## Backend

### Endpoints

### `/tests`

Retorna uma lista com todos os exames cadastrados

Exemplo de requisição:

```bash
GET /tests
```
---

Exemplo de resposta:

```json
[
  {
    "exam_result_token": "IQCZ17",
    "exam_result_date": "2021-08-05",
    "patient": {
      "patient_cpf": "048.973.170-88",
      "patient_name": "Emilly Batista Neto",
      "patient_email": "gerald.crona@ebert-quigley.com",
      "patient_birthdate": "2001-03-11",
      "patient_address": "165 Rua Rafaela",
      "patient_city": "Ituverava",
      "patient_state": "Alagoas"
    },
    "doctor": {
      "doctor_crm": "B000BJ20J4",
      "doctor_crm_state": "PI",
      "doctor_name": "Maria Luiza Pires",
      "doctor_email": "denna@wisozk.biz"
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_type_limits": "45-52",
        "test_type_results": "97"
      },
      {
        "test_type": "leucócitos",
        "test_type_limits": "9-61",
        "test_type_results": "89"
      }
    ]
  },
  {
    "exam_result_token": "0W9I67",
    "exam_result_date": "2021-07-09",
    "patient": {
      "patient_cpf": "048.108.026-04",
      "patient_name": "Juliana dos Reis Filho",
      "patient_email": "mariana_crist@kutch-torp.com",
      "patient_birthdate": "1995-07-03",
      "patient_address": "527 Rodovia Júlio",
      "patient_city": "Lagoa da Canoa",
      "patient_state": "Paraíba"
    },
    "doctor": {
      "doctor_crm": "B0002IQM66",
      "doctor_crm_state": "SC",
      "doctor_name": "Maria Helena Ramalho",
      "doctor_email": "rayford@kemmer-kunze.info"
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_type_limits": "45-52",
        "test_type_results": "28"
      },
      {
        "test_type": "leucócitos",
        "test_type_limits": "9-61",
        "test_type_results": "91"
      },
      {
        "test_type": "plaquetas",
        "test_type_limits": "11-93",
        "test_type_results": "18"
      },
      {
        "test_type": "hdl",
        "test_type_limits": "19-75",
        "test_type_results": "74"
      }
    ]
  }
]
```

### `/tests/:token`

Retorna um objeto JSON de acordo com token passado

Exemplo de requisição

```bash
GET /tests/TJUXC2
```
---

Exemplo de resposta

```json
{
  "exam_result_token": "TJUXC2",
  "exam_result_date": "2021-10-05",
  "patient": {
    "patient_cpf": "089.034.562-70",
    "patient_name": "Patricia Gentil",
    "patient_email": "herta_wehner@krajcik.name",
    "patient_birthdate": "1998-02-25",
    "patient_address": "5334 Rodovia Thiago Bittencourt",
    "patient_city": "Jequitibá",
    "patient_state": "Paraná"
  },
  "doctor": {
    "doctor_crm": "B0002W2RBG",
    "doctor_crm_state": "CE",
    "doctor_name": "Dra. Isabelly Rêgo",
    "doctor_email": "diann_klein@schinner.org"
  },
  "tests": [
    {
      "test_type": "hemácias",
      "test_type_limits": "45-52",
      "test_type_results": "75"
    },
    {
      "test_type": "leucócitos",
      "test_type_limits": "9-61",
      "test_type_results": "24"
    }
  ]
}
```

### `/import`

Permite o envio de um arquivo .csv para importação para o banco de dados

Exemplo de requisição:

```shell
curl -X POST -H "Content-Type: multipart/form-data" \
     -F "file=@data.csv;type=text/csv" \
     http://localhost:3000/import
```
---

Exemplo de resposta quando não é enviado arquivo na requisição:

```json
{ "error": "The request does not contain any file."}
```
---

Exemplo de resposta quando formato do arquivo não é suportado:

```json
{ "error": "File type is not CSV." }
```
---

Exemplo de requisição em cenário de sucesso:

```json
{ "message": "Processing file." }
```

## Frontend

### Funcionalidades

No frontend, é possível importar dados de um arquivo CSV. A importação é feita de forma assíncrona e o usuário pode continuar usando a aplicação. 

[![labs-upload.png](https://i.postimg.cc/J4Z4TsQD/labs-upload.png)](https://postimg.cc/PPfjJr9T)
---

As requisições no frontend não vão diretamente para o backend. Elas passam primeiro por rotas implementadas no front, que então direcionam para o backend.
Por exemplo, para importar um arquivo, a requisição vai para uma rota no frontend que valida o formato do arquivo antes de fazer a requisição para o backend, e renderiza uma mensagem de erro.
Isso permitiu também praticar um conceito passado na Vivência em Time, que orienta a não expor o endpoint da API externa nas ferramentas de desenvolvedor do navegador do cliente.

[![labs-formato-errado.png](https://i.postimg.cc/mrxNFXSz/labs-formato-errado.png)](https://postimg.cc/K1Ng65wx)
---

Ao enviar um arquivo válido, o usuário tem um feedback informando que o arquivo está em processamento.

[![labs-import.png](https://i.postimg.cc/43PzYJ2y/labs-import.png)](https://postimg.cc/VSSSTc8P)
---

Após a importação ser executada em background, as informações ficam disponíveis no frontend quando o usuário recarrega a página. 

[![labs-list.png](https://i.postimg.cc/B6MG6wKH/labs-list.png)](https://postimg.cc/fttPqC5R)
---

O usuário também pode informar um token na barra de pesquisa. Caso exista um exame com um token informado, é exibido na página apenas o exame correspondente.

[![labs-detail.png](https://i.postimg.cc/9MtNF4sk/labs-detail.png)](https://postimg.cc/9R0BLfmP)


### Testes

Foram escritos testes de requisição para as rotas internas do frontend.

Para executar os testes, excute o comando abaixo:
```shell
docker exec -it labs-frontend rspec
```

## Fechando a aplicação

Para encerrar a aplicação e remover os volumes associados aos containers, execute o comando abaixo:

```shell
docker compose down -v
```
