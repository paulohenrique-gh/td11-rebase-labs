const url = 'http://localhost:3000/tests'

fetch(url).
then((response) => response.json()).
then((data) => {
    const ul = document.querySelector('ul');

    data.forEach((exam) => {
      const li = document.createElement('li');
      let tests = ''

      exam.tests.forEach((test) => {
        tests += `
          <li class="test-list-item>
            <div>Tipo: ${test.test_type}</div>
            <div>Limites: ${test.test_type_limits}</div>
            <div>Resultado: ${test.test_type_results}</div>
          </li>
        `
      });

      console.log(tests);

      li.innerHTML = `
        <div class="exam-info">
          <div class="general-data">
            <div>Token: ${exam.exam_result_token}</div>
            <div>Data do resultado: ${exam.exam_result_date}</div>
          </div>
          <div class="patient-data">
            <div class="patient-data--header">
              <div class="title">Paciente</div>
              <div class="name">${exam.patient.patient_name}</div>
            </div>
            <div class="patient-data--info">
              <div>CPF: ${exam.patient.patient_cpf}</div>
              <div>E-mail: ${exam.patient.patient_email}</div>
              <div>Data de nascimento: ${exam.patient.patient_birthdate}</div>
              <div>Endereço: ${exam.patient.patient_address}</div>
              <div>Cidade: ${exam.patient.patient_city}</div>
              <div>Estado: ${exam.patient.patient_state}</div>
            </div>
          </div>
          <div class="doctor-data">
            <div>CRM: ${exam.doctor.doctor_crm}</div>
            <div>Estado CRM: ${exam.doctor.doctor_crm_state}</div>
            <div>Nome: ${exam.doctor.doctor_name}</div>
            <div>Email: ${exam.doctor.doctor_email}</div>
          </div>
          <ul class="test-data-list">
            ${tests}
          </ul>
        </div>
      ` 
      ul.appendChild(li);
    });
  });
