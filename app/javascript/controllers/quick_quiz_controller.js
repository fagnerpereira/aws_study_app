import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "questionContainer", "modal", "modalTitle", "modalMessage", "modalScore", "modalXp" ]

  selectAnswer(event) {
    const selectedOption = event.currentTarget.dataset.option
    
    fetch('/games/quick-quiz/check', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        selected_answer: selectedOption
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.game_over) {
        this.modalTitleTarget.innerText = "Quiz Complete!"
        this.modalMessageTarget.innerText = `You answered ${data.correct_answers} out of ${data.total_questions} questions correctly.`
        this.modalScoreTarget.innerText = `${data.score}%`
        this.modalXpTarget.innerText = `+${data.xp_earned}`
        this.modalTarget.classList.remove('hidden')
      } else {
        this.questionContainerTarget.innerHTML = data.next_question_html
      }
    })
  }
}
