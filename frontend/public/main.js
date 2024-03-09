//const url = 'http://localhost:3000/tests'

fetch(url).
then((response) => response.json()).
then((data) => {
    const ul = document.querySelector('ul');

    data.forEach((exam) => {
      const li = document.createElement('li');
      let tests = ''

      exam.tests.forEach((test) => {
        tests += `
          <li class="test-listing--item">
            <span>${test.test_type}</span>
            <span>${test.test_type_limits}</span>
            <span>${test.test_type_results}</span>
          </li>
        `
      });

      li.innerHTML = `
        <div class="exam-section">
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
        </div>
      ` 
      ul.appendChild(li);
    });
  }).
  catch(error => console.log(error));
