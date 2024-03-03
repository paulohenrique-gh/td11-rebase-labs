CREATE DATABASE development;
CREATE DATABASE test;

\c development;

CREATE TABLE IF NOT EXISTS exames (
  id SERIAL,
  cpf VARCHAR,
  nome_paciente VARCHAR,
  email_paciente VARCHAR,
  data_nascimento_paciente DATE,
  endereco_rua_paciente VARCHAR,
  cidade_paciente VARCHAR,
  estado_paciente VARCHAR,
  crm_medico VARCHAR,
  crm_medico_estado VARCHAR,
  nome_medico VARCHAR,
  email_medico VARCHAR,
  token_resultado_exame VARCHAR,
  data_exame DATE,
  tipo_exame VARCHAR,
  limites_tipo_exame VARCHAR,
  resultado_tipo_exame VARCHAR
);

\c test;

CREATE TABLE IF NOT EXISTS exames (
  id SERIAL,
  cpf VARCHAR,
  nome_paciente VARCHAR,
  email_paciente VARCHAR,
  data_nascimento_paciente DATE,
  endereco_rua_paciente VARCHAR,
  cidade_paciente VARCHAR,
  estado_paciente VARCHAR,
  crm_medico VARCHAR,
  crm_medico_estado VARCHAR,
  nome_medico VARCHAR,
  email_medico VARCHAR,
  token_resultado_exame VARCHAR,
  data_exame DATE,
  tipo_exame VARCHAR,
  limites_tipo_exame VARCHAR,
  resultado_tipo_exame VARCHAR
);

\q