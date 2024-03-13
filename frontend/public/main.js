const path = '/load-exams'

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
  
  fetch(importPath, fetchOptions);
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
  fetch(path).
  then((response) => response.json()).
  then((data) => {  
    if (data.length === 0) {
      console.log('sem nada cadastrado')
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
  <div class="import-form-group">
    <label for="file">Selecione o CSV</label>
    <input name="file" id="file" type="file" accept="text/csv, application/vnd.ms-excel">
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

  fetch(path + `/${token}`)
    .then(response => response.json())
    .then(exam => {
      if (exam.length === 0) {
        filter.textContent = token;
        examDetails.innerHTML = `
          <p class="no-results-msg">Não localizado exame com token
                                    <strong>"${token}"</strong>
          </p>
        `
        examDetails.appendChild(createBackButton());
        return;
      }

      examDetails.innerHTML = examHTML(exam);
      examDetails.appendChild(createBackButton());

      filter.innerHTML = `${token}`;
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

