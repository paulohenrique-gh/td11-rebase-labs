const url = 'http://localhost:3000/tests'

fetch(url).
then((response) => response.json()).
then((data) => {
    const ul = document.querySelector('ul');

    data.forEach((exam) => {
      const li = document.createElement('li');
      li.innerHTML = `
        <div class="exam-info">
          <div>Token: ${exam.exam_result_token}</div>
          <div>Paciente: ${exam.patient.patient_name}</div>
          <div>Médico: ${exam.doctor.doctor_name}</div>
        </div>
      ` 
      ul.appendChild(li);
      console.log(exam)
    });
    
    console.log(data);
  });
