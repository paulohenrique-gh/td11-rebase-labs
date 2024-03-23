class Doctor {
  constructor(crm, crm_state, name, email) {
    this.crm = crm;
    this.crm_state = crm_state;
    this.name = name;
    this.email = email;
  }

  toString() {
    return JSON.stringify(this, null, 4);
  }
};

export default Doctor;
