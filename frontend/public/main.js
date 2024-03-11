const url = 'http://localhost:3000/tests'
const searchForm = document.querySelector('.search-form');
let filter = document.querySelector('.filter-value');
const examList = document.querySelector('.exam-list');
const examDetails = document.createElement('div');
examDetails.classList.add('exam-details-section');

function backToHomePage() {
  examDetails.replaceWith(examList);
  filter.innerHTML = 'Todos';
}

const form = document.querySelector('.import-form');
form.addEventListener('submit', handleSubmit);

function handleSubmit(event) {
  event.preventDefault();
  console.log('arquivo recebido no javascript');

  uploadCsv();
};

function uploadCsv() {
  const importUrl = 'http://localhost:3000/import';
  const formData = new FormData(form);

  const fetchOptions = {
    method: 'post',
    body: formData
  };

  fetch(importUrl, fetchOptions);
};

function examHTML(exam) {
  let tests = '';

  exam.tests.forEach((test) => {
    tests += `
      <li class="test-listing--item">
        <span>${test.test_type}</span>
        <span>${test.test_type_limits}</span>
        <span>${test.test_type_results}</span>
      </li>
    `
  });

  return `<div class="exam-section">
            <div class="general-data">
              <div><strong>Token:</strong> ${exam.exam_result_token}</div>
              <div><strong>Data do resultado:</strong> ${exam.exam_result_date}</div>
            </div>
            <div class="patient-data">
              <div class="patient-data--header">
                <div class="title">Paciente</div>
                <div class="name">${exam.patient.patient_name}</div>
              </div>
              <div class="patient-data--info">
                <div><strong>CPF:</strong> ${exam.patient.patient_cpf}</div>
                <div><strong>E-mail:</strong> ${exam.patient.patient_email}</div>
                <div><strong>Data de nascimento:</strong> ${exam.patient.patient_birthdate}</div>
                <div><strong>Endereço:</strong> ${exam.patient.patient_address}</div>
                <div><strong>Cidade:</strong> ${exam.patient.patient_city}</div>
                <div><strong>Estado:</strong> ${exam.patient.patient_state}</div>
              </div>
            </div>
            <div class="doctor-data">
              <div class="doctor-data--header">
                <div class="title">Médico</div>
                <div class="name">${exam.doctor.doctor_name}</div>
              </div>
              <div class="doctor-data--info">
                <div><strong>CRM:</strong> ${exam.doctor.doctor_crm}</div>
                <div><strong>Estado CRM:</strong> ${exam.doctor.doctor_crm_state}</div>
                <div><strong>Email:</strong> ${exam.doctor.doctor_email}</div>
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
                  ${tests}
                </ul>
              </div>
            </div>
          </div>`
};

function loadExamList() {
  fetch(url).
  then((response) => response.json()).
  then((data) => {  
    data.forEach((exam) => {
      const li = document.createElement('li');

      li.innerHTML = examHTML(exam);
      examList.appendChild(li);
    });
  }).
  catch(error => console.log(error));
};

window.onload = loadExamList();

searchForm.onsubmit = function(event) {
  event.preventDefault();

  const token = event.target[0].value;

  const backButton = document.createElement('button');
  backButton.classList.add('back-button');
  backButton.innerHTML = `
    <ion-icon name="arrow-back-circle-outline" class="back-icon"></ion-icon>
  `
  backButton.addEventListener('click', backToHomePage);

  if (!token) {
    filter.textContent = 'Todos';
    examDetails.replaceWith(examList);
    return;
  }

  fetch(url + `/${token}`)
    .then(response => response.json())
    .then(exam => {
      if (exam.length === 0) {
        filter.textContent = token;
        examDetails.innerHTML = `
          <p class="no-results-msg">Não localizado exame com token
                                    <strong>"${token}"</strong>
          </p>
        `
        examDetails.appendChild(backButton);
      }

      examDetails.innerHTML = examHTML(exam);
      examDetails.appendChild(backButton);

      filter.innerHTML = `${token}`;
    });

  examList.replaceWith(examDetails);
};

document.querySelector('.home-link').addEventListener('click', backToHomePage);

