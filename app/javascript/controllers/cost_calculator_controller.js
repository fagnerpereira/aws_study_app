import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "costInput", "modal", "modalTitle", "modalMessage", "modalScore", "modalCorrect" ]

  checkCost() {
    const userAnswer = parseFloat(this.costInputTarget.value)
    const correctTotal = 52.35 // Hardcoded for this scenario

    fetch('/games/cost-calculator/check', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_total: userAnswer,
        scenario_title: "Startup Web Application"
      })
    })
    .then(response => response.json())
    .then(data => {
      this.modalTitleTarget.innerText = data.message
      this.modalMessageTarget.innerText = `You were off by $${data.difference.toFixed(2)}.`
      this.modalScoreTarget.innerText = `$${userAnswer.toFixed(2)}`
      this.modalCorrectTarget.innerText = `$${correctTotal.toFixed(2)}`
      this.modalTarget.classList.remove('hidden')
    })
  }
}
