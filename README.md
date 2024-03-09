# Rebase Labs

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
API: http://localhost:3000

Frontend: http://localhost:4000

## Testes

Utilizar o comando abaixo para executar a suite de testes:
```bash
docker exec labs-backend rspec
```

## Importar dados do CSV para o banco de dados

Para importar manualmente os dados do arquivo `data.csv` para o banco de dados, execute:
```bash
docker exec labs-backend bash -c "ruby import_from_csv.rb"
```

## Banco de dados

Foram criadas 4 tabelas a partir dos dados brutos do CSV.
[Aqui](https://dbdiagram.io/d/65e7c7eccd45b569fb9edec6) tem o diagrama com as tabelas e as relações.

## Backend

### Endpoints

```bash
GET /tests
```
Retorna uma lista com todos os exames cadastrados

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
      },
      {
        "test_type": "plaquetas",
        "test_type_limits": "11-93",
        "test_type_results": "97"
      },
      {
        "test_type": "hdl",
        "test_type_limits": "19-75",
        "test_type_results": "0"
      },
      {
        "test_type": "ldl",
        "test_type_limits": "45-54",
        "test_type_results": "80"
      },
      {
        "test_type": "vldl",
        "test_type_limits": "48-72",
        "test_type_results": "82"
      },
      {
        "test_type": "glicemia",
        "test_type_limits": "25-83",
        "test_type_results": "98"
      },
      {
        "test_type": "tgo",
        "test_type_limits": "50-84",
        "test_type_results": "87"
      },
      {
        "test_type": "tgp",
        "test_type_limits": "38-63",
        "test_type_results": "9"
      },
      {
        "test_type": "eletrólitos",
        "test_type_limits": "2-68",
        "test_type_results": "85"
      },
      {
        "test_type": "tsh",
        "test_type_limits": "25-80",
        "test_type_results": "65"
      },
      {
        "test_type": "t4-livre",
        "test_type_limits": "34-60",
        "test_type_results": "94"
      },
      {
        "test_type": "ácido úrico",
        "test_type_limits": "15-61",
        "test_type_results": "2"
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
      },
      {
        "test_type": "ldl",
        "test_type_limits": "45-54",
        "test_type_results": "66"
      },
      {
        "test_type": "vldl",
        "test_type_limits": "48-72",
        "test_type_results": "41"
      },
      {
        "test_type": "glicemia",
        "test_type_limits": "25-83",
        "test_type_results": "6"
      },
      {
        "test_type": "tgo",
        "test_type_limits": "50-84",
        "test_type_results": "32"
      },
      {
        "test_type": "tgp",
        "test_type_limits": "38-63",
        "test_type_results": "16"
      },
      {
        "test_type": "eletrólitos",
        "test_type_limits": "2-68",
        "test_type_results": "61"
      },
      {
        "test_type": "tsh",
        "test_type_limits": "25-80",
        "test_type_results": "13"
      },
      {
        "test_type": "t4-livre",
        "test_type_limits": "34-60",
        "test_type_results": "9"
      },
      {
        "test_type": "ácido úrico",
        "test_type_limits": "15-61",
        "test_type_results": "78"
      }
    ]
  }
]
```

```bash
/tests/:token
```

Retorna um objeto JSON de acordo com token passado

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
    },
    {
      "test_type": "plaquetas",
      "test_type_limits": "11-93",
      "test_type_results": "26"
    },
    {
      "test_type": "hdl",
      "test_type_limits": "19-75",
      "test_type_results": "87"
    },
    {
      "test_type": "ldl",
      "test_type_limits": "45-54",
      "test_type_results": "21"
    },
    {
      "test_type": "vldl",
      "test_type_limits": "48-72",
      "test_type_results": "76"
    },
    {
      "test_type": "glicemia",
      "test_type_limits": "25-83",
      "test_type_results": "86"
    },
    {
      "test_type": "tgo",
      "test_type_limits": "50-84",
      "test_type_results": "2"
    },
    {
      "test_type": "tgp",
      "test_type_limits": "38-63",
      "test_type_results": "84"
    },
    {
      "test_type": "eletrólitos",
      "test_type_limits": "2-68",
      "test_type_results": "90"
    },
    {
      "test_type": "tsh",
      "test_type_limits": "25-80",
      "test_type_results": "94"
    },
    {
      "test_type": "t4-livre",
      "test_type_limits": "34-60",
      "test_type_results": "35"
    },
    {
      "test_type": "ácido úrico",
      "test_type_limits": "15-61",
      "test_type_results": "94"
    }
  ]
}
```
## Frontend

TODO

