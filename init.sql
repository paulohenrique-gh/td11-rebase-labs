CREATE DATABASE development;
CREATE DATABASE test;

\c development;

CREATE TABLE IF NOT EXISTS lab_tests (
  id SERIAL,
  patient_cpf VARCHAR,
  patient_name VARCHAR,
  patient_email VARCHAR,
  patient_birthdate DATE,
  patient_address VARCHAR,
  patient_city VARCHAR,
  patient_state VARCHAR,
  doctor_crm VARCHAR,
  doctor_crm_state VARCHAR,
  doctor_name VARCHAR,
  doctor_email VARCHAR,
  test_results_token VARCHAR,
  test_date DATE,
  test_type VARCHAR,
  test_type_limits VARCHAR,
  test_type_results VARCHAR,
  PRIMARY KEY (id)
);

\c test;

CREATE TABLE IF NOT EXISTS lab_tests (
  id SERIAL,
  patient_cpf VARCHAR,
  patient_name VARCHAR,
  patient_email VARCHAR,
  patient_birthdate DATE,
  patient_address VARCHAR,
  patient_city VARCHAR,
  patient_state VARCHAR,
  doctor_crm VARCHAR,
  doctor_crm_state VARCHAR,
  doctor_name VARCHAR,
  doctor_email VARCHAR,
  test_results_token VARCHAR,
  test_date DATE,
  test_type VARCHAR,
  test_type_limits VARCHAR,
  test_type_results VARCHAR,
  PRIMARY KEY (id)
);

\q