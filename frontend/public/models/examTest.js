class ExamTest {
  constructor(type, limits, results) {
    this.type = type;
    this.limits = limits;
    this.results = results;
  }

  testLi() {
    return `
      <li class="test-listing--item">
        <span>${this.type}</span>
        <span>${this.limits}</span>
        <span>${this.results}</span>
      </li>
    `
  }

  toString() {
    return JSON.stringify(this, null, 4);
  }
};

export default ExamTest;
