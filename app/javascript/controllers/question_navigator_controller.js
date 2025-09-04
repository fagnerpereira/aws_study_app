import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { currentQuestionIndex: Number }

  connect() {
    this.showCurrentQuestion()
  }

  showCurrentQuestion() {
    const questionCards = document.querySelectorAll('.question-card')
    questionCards.forEach((card, index) => {
      if (index === this.currentQuestionIndexValue) {
        card.classList.remove('hidden')
      } else {
        card.classList.add('hidden')
      }
    })
  }

  nextQuestion() {
    this.currentQuestionIndexValue++
    this.showCurrentQuestion()
  }

  submitForm(event) {
    const form = event.target.closest('label').querySelector('input[type="radio"]').form
    form.requestSubmit()
  }
}