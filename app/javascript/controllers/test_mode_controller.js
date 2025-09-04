import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["questionCard", "submitButton", "quizContainer", "scoreDisplay", "score", "correctCount", "totalCount"]

  connect() {
    this.currentQuestionIndex = 0
    this.correctAnswers = 0
    this.userAnswers = {}
    this.showCurrentQuestion()
  }

  showCurrentQuestion() {
    this.questionCardTargets.forEach((card, index) => {
      if (index === this.currentQuestionIndex) {
        card.style.display = "block"
      } else {
        card.style.display = "none"
      }
    })
    this.submitButtonTarget.disabled = true // Disable submit until an answer is selected
  }

  selectAnswer(event) {
    const questionId = event.target.name.replace('question_', '')
    const selectedAnswer = event.target.value
    this.userAnswers[questionId] = selectedAnswer
    this.submitButtonTarget.disabled = false // Enable submit
  }

  submitAnswer() {
    const currentQuestionCard = this.questionCardTargets[this.currentQuestionIndex]
    const questionId = currentQuestionCard.dataset.index // Using index as questionId for simplicity in this example
    const correctAnswer = currentQuestionCard.dataset.correctAnswer
    const selectedAnswer = this.userAnswers[`question_${questionId}`]

    if (selectedAnswer === correctAnswer) {
      this.correctAnswers++
      // Optional: Add visual feedback for correct answer
      currentQuestionCard.querySelector(`input[value="${selectedAnswer}"]`).closest('label').classList.add('correct')
    } else {
      // Optional: Add visual feedback for incorrect answer
      currentQuestionCard.querySelector(`input[value="${selectedAnswer}"]`).closest('label').classList.add('incorrect')
      currentQuestionCard.querySelector(`input[value="${correctAnswer}"]`).closest('label').classList.add('correct') // Show correct answer
    }

    // Disable all options after submission
    currentQuestionCard.querySelectorAll('input[type="radio"]').forEach(radio => radio.disabled = true)
    this.submitButtonTarget.disabled = true // Disable submit button

    // Move to next question or show score
    setTimeout(() => {
      this.currentQuestionIndex++
      if (this.currentQuestionIndex < this.questionCardTargets.length) {
        this.showCurrentQuestion()
      } else {
        this.showScore()
      }
    }, 1500) // Delay to show feedback
  }

  showScore() {
    this.quizContainerTarget.style.display = "none"
    this.scoreDisplayTarget.style.display = "block"

    const totalQuestions = this.questionCardTargets.length
    const scorePercentage = (this.correctAnswers / totalQuestions * 100).toFixed(0)

    this.scoreTarget.textContent = scorePercentage
    this.correctCountTarget.textContent = this.correctAnswers
    this.totalCountTarget.textContent = totalQuestions
  }
}