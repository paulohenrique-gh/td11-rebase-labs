import Patient from './models/patient.js';
import Doctor from './models/doctor.js';
import ExamTest from './models/examTest.js';
import Exam from './models/exam.js';

const path = '/load-exams'

const flashMsg = document.querySelector('.flash-msg');
const closeMsgButton = document.querySelector('.close-btn');
closeMsgButton.addEventListener('click', () => {
  flashMsg.classList.add('hidden');
});

const searchForm = document.querySelector('.search-form');

let filter = document.querySelector('.filter-value');

const examList = document.querySelector('.exam-list');
const examDetails = document.createElement('div');
examDetails.classList.add('exam-details-section');

const importForm = document.createElement('form');

let currentContent = examList;

function backToHomePage() {
  currentContent.replaceWith(examList);
  filter.innerHTML = 'Todos';
  currentContent = examList;
}

function createBackButton() {
  const backButton = document.createElement('button');
  backButton.classList.add('back-button');
  backButton.innerHTML = `
    <ion-icon name="arrow-back-circle-outline" class="back-icon"></ion-icon>
  `
  backButton.addEventListener('click', backToHomePage);

  return backButton;
}

function handleSubmit(event) {
  event.preventDefault();

  uploadCsv();
};

function uploadCsv() {
  const importPath = '/import';
  const formData = new FormData(importForm);

  const fetchOptions = {
    method: 'post',
    body: formData
  };

  let message = document.querySelector('.message');

  flashMsg.classList.remove('hidden');
  message.textContent = 'Enviando arquivo...';

  fetch(importPath, fetchOptions).
    then((response) => {
      if (response.status === 422) {
        flashMsg.classList.remove('hidden');
        message.textContent = 'Formato não compatível. Selecione um arquivo CSV.';
        importForm.reset();
        return;
      }

      if (!response.ok) {
        flashMsg.classList.remove('hidden');
        message.textContent = 'Ocorreu um erro ao processar requisição. Tente mais tarde.';
        importForm.reset();
        return;
      }

      flashMsg.classList.remove('hidden');
      message.innerHTML = "Arquivo em processamento.<br />Caso sejam válidos, os dados estarão disponíveis em breve.";

      currentContent.replaceWith(examList);
      currentContent = examList;
      importForm.reset();
    }).
    catch((error) => {
      console.log(error);

      flashMsg.classList.remove('hidden');
      message.innerHTML = 'Ocorreu um erro ao inesperado. Tente mais tarde.';
      importForm.reset();
    });

};

function examHTML(exam) {
  const patient = new Patient(
    exam.patient.patient_cpf, exam.patient.patient_name, exam.patient.patient_email,
    exam.patient.patient_birthdate, exam.patient.patient_address, exam.patient.patient_city,
    exam.patient.patient_state
  );

  console.log('Paciente' + patient);

  const doctor = new Doctor(
    exam.doctor.doctor_crm, exam.doctor.doctor_crm_state,
    exam.doctor.doctor_name, exam.doctor.doctor_email
  );

  console.log('Doutor' + doctor);

  const tests = [];

  exam.tests.forEach((test) => {
    const newTest = new ExamTest(test.test_type, test.test_type_limits, test.test_type_results)
    tests.push(newTest);
    console.log('Test' + newTest);
  });

  const newExam = new Exam(
    exam.exam_result_token, exam.exam_result_date, patient, doctor, tests
  );

  console.log('Exame' + newExam);

  return newExam.examHTML();
};

function loadExamList() {
  fetch(path).
  then((response) => response.json()).
  then((data) => {  
    if (data.length === 0) {
      const li = document.createElement('li');

      li.innerHTML = 'Nenhum registro encontrado.';
      li.classList.add('no-results-msg');
      examList.appendChild(li);

      return;
    }

    data.forEach((exam) => {
      const li = document.createElement('li');

      li.innerHTML = examHTML(exam);
      examList.appendChild(li);
    });
  }).
  catch(error => {
    console.log(error);

    const li = document.createElement('li');

    li.innerHTML = 'Não foi possível carregar as informações. Tente mais tarde.';
    li.classList.add('no-results-msg');
    examList.appendChild(li);

    return;
  });

  currentContent = examList;
};

const importLink = document.querySelector('.import-link');
importLink.addEventListener('click', (event) => {
  event.preventDefault();
  
  currentContent.replaceWith(importFormSession);
  currentContent = importFormSession;
  document.querySelector('.filter-value').textContent = 'Nenhum';
});

importForm.setAttribute('class', 'import-form');
importForm.setAttribute('method', 'post');
importForm.setAttribute('enctype', 'multipart/form-data');
importForm.innerHTML = `
    < div class= "import-form-group" >
    <label for="file">Selecione o CSV</label>
    <input name="file" id="file" type="file" accept="text/csv, application/vnd.ms-excel" required>
  </div>
  <button type="submit">Enviar
    <ion-icon name="cloud-upload-outline" class="upload-icon"></ion-icon>
  </button>
`
importForm.addEventListener('submit', handleSubmit);

const importFormSession = document.createElement('div');
importFormSession.classList.add('import-form-session');
importFormSession.appendChild(importForm);
importFormSession.appendChild(createBackButton());

window.onload = loadExamList();

searchForm.onsubmit = function(event) {
  event.preventDefault();

  const token = event.target[0].value;

  if (!token) {
    filter.textContent = 'Todos';
    currentContent.replaceWith(examList);
    currentContent = examList;
    return;
  }

  fetch(path + `/${ token }`)
    .then(response => response.json())
    .then(exam => {
      if (exam.length === 0) {
        filter.textContent = token;
        examDetails.innerHTML = `
          <p class= "no-results-msg" > Não localizado exame com token
            <strong>"${token}"</strong>
          </p>
        `
        examDetails.appendChild(createBackButton());
        return;
      }

      examDetails.innerHTML = examHTML(exam);
      examDetails.appendChild(createBackButton());

      filter.innerHTML = `${ token }`;
    }).
    catch(error => {
      console.log(error);

      const p = document.createElement('p');

      p.innerHTML = 'Não foi possível carregar as informações. Tente mais tarde.';
      p.classList.add('no-results-msg');
      examDetails.appendChild(p);

      return;
    });

  currentContent.replaceWith(examDetails);
  currentContent = examDetails;
};

document.querySelector('.home-link').addEventListener('click', backToHomePage);

