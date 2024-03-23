class Patient {
  constructor(cpf, name, email, birthdate, address, city, state) {
    this.cpf = cpf;
    this.name = name;
    this.email = email;
    this.birthdate = birthdate;
    this.address = address;
    this.city = city;
    this.state = state;
  }

  toString() {
    return JSON.stringify(this, null, 4);
  }
}

  export default Patient;
