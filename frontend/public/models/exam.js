import { formatDate } from "../helpers.js";

class Exam {
  constructor(token, date, patient, doctor, tests) {
    this.token = token;
    this.date = date;
    this.patient = patient;
    this.doctor = doctor;
    this.tests = tests;
  }

  toString() {
    return JSON.stringify(this, null, 4);
  }

  testsList() {
    let testsHTML = '';
    this.tests.forEach(test => {
      testsHTML += test.testLi();
    });

    return testsHTML;
  }

  examHTML() {
    return `<div class="exam-section">
              <div class="general-data">
                <div><strong>Token:</strong> ${this.token}</div>
                <div><strong>Data do resultado:</strong> ${formatDate(this.date)}</div>
              </div>
              <div class="patient-data">
                <div class="patient-data--header">
                  <div class="title">Paciente</div>
                  <div class="name">${this.patient.name}</div>
                </div>
                <div class="patient-data--info">
                  <div><strong>CPF:</strong> ${this.patient.cpf}</div>
                  <div><strong>E-mail:</strong> ${this.patient.email}</div>
                  <div><strong>Data de nascimento:</strong> ${formatDate(this.patient.birthdate)}</div>
                  <div><strong>Endereço:</strong> ${this.patient.address}</div>
                  <div><strong>Cidade:</strong> ${this.patient.city}</div>
                  <div><strong>Estado:</strong> ${this.patient.state}</div>
                </div>
              </div>
              <div class="doctor-data">
                <div class="doctor-data--header">
                  <div class="title">Médico</div>
                  <div class="name">${this.doctor.name}</div>
                </div>
                <div class="doctor-data--info">
                  <div><strong>CRM:</strong> ${this.doctor.crm}</div>
                  <div><strong>Estado CRM:</strong> ${this.doctor.crm_state}</div>
                  <div><strong>Email:</strong> ${this.doctor.email}</div>
                </div>
              </div>
              <div class="test-data">
                <div class="test-data--header">
                  <div class="title">Testes</div>
                </div>
                <div class="test-listing">
                  <div class="test-listing--headers">
                    <span>Tipo</span>
                    <span>Limites</span>
                    <span>Resultado</span>
                  </div>
                  <ul class="test-listing--info">
                    ${this.testsList()}
                  </ul>
                </div>
              </div>
            </div>`
  }
};

export default Exam;
