CREATE DATABASE development;
CREATE DATABASE test;

\c development;

CREATE TABLE IF NOT EXISTS patients (
  patient_id SERIAL NOT NULL,
  patient_cpf VARCHAR NOT NULL UNIQUE,
  patient_name VARCHAR NOT NULL,
  patient_email VARCHAR NOT NULL,
  patient_birthdate DATE NOT NULL,
  patient_address VARCHAR NOT NULL,
  patient_city VARCHAR NOT NULL,
  patient_state VARCHAR NOT NULL,
  PRIMARY KEY (patient_id)
);

CREATE TABLE IF NOT EXISTS doctors (
  doctor_id SERIAL NOT NULL,
  doctor_crm VARCHAR NOT NULL,
  doctor_crm_state VARCHAR NOT NULL,
  doctor_name VARCHAR NOT NULL,
  doctor_email VARCHAR NOT NULL,
  PRIMARY KEY (doctor_id),
  UNIQUE (doctor_crm, doctor_crm_state)
);

CREATE TABLE IF NOT EXISTS lab_exams (
  exam_id SERIAL NOT NULL,
  exam_patient_id INT NOT NULL,
  exam_doctor_id INT NULL,
  exam_result_token VARCHAR NOT NULL UNIQUE,
  exam_result_date VARCHAR,
  PRIMARY KEY (exam_id),
  FOREIGN KEY (exam_patient_id) REFERENCES patients (patient_id),
  FOREIGN KEY (exam_doctor_id) REFERENCES doctors (doctor_id)
);

CREATE TABLE IF NOT EXISTS tests (
  test_id SERIAL NOT NULL,
  test_lab_exam_id INT NOT NULL,
  test_type VARCHAR NOT NULL,
  test_type_limits VARCHAR NOT NULL,
  test_type_results VARCHAR,
  PRIMARY KEY (test_id),
  FOREIGN KEY (test_lab_exam_id) REFERENCES lab_exams (exam_id)
);

\c test;

CREATE TABLE IF NOT EXISTS patients (
  patient_id SERIAL NOT NULL,
  patient_cpf VARCHAR NOT NULL UNIQUE,
  patient_name VARCHAR NOT NULL,
  patient_email VARCHAR NOT NULL,
  patient_birthdate DATE NOT NULL,
  patient_address VARCHAR NOT NULL,
  patient_city VARCHAR NOT NULL,
  patient_state VARCHAR NOT NULL,
  PRIMARY KEY (patient_id)
);

CREATE TABLE IF NOT EXISTS doctors (
  doctor_id SERIAL NOT NULL,
  doctor_crm VARCHAR NOT NULL,
  doctor_crm_state VARCHAR NOT NULL,
  doctor_name VARCHAR NOT NULL,
  doctor_email VARCHAR NOT NULL,
  PRIMARY KEY (doctor_id),
  UNIQUE (doctor_crm, doctor_crm_state)
);

CREATE TABLE IF NOT EXISTS lab_exams (
  exam_id SERIAL NOT NULL,
  exam_patient_id INT NOT NULL,
  exam_doctor_id INT NULL,
  exam_result_token VARCHAR NOT NULL UNIQUE,
  exam_result_date VARCHAR,
  PRIMARY KEY (exam_id),
  FOREIGN KEY (exam_patient_id) REFERENCES patients (patient_id),
  FOREIGN KEY (exam_doctor_id) REFERENCES doctors (doctor_id)
);

CREATE TABLE IF NOT EXISTS tests (
  test_id SERIAL NOT NULL,
  test_lab_exam_id INT NOT NULL,
  test_type VARCHAR NOT NULL,
  test_type_limits VARCHAR NOT NULL,
  test_type_results VARCHAR,
  PRIMARY KEY (test_id),
  FOREIGN KEY (test_lab_exam_id) REFERENCES lab_exams (exam_id)
);

\q