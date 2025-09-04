import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "scenarioContainer", "modal", "modalTitle", "modalMessage", "modalScore", "modalXp" ]

  selectOption(event) {
    const nextScenarioId = event.currentTarget.dataset.nextScenarioId
    const points = event.currentTarget.dataset.points
    
    fetch('/games/scenario-tree/check', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        next_scenario_id: nextScenarioId,
        points: points
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.game_over) {
        this.modalTitleTarget.innerText = "Scenario Complete!"
        this.modalMessageTarget.innerText = `You navigated the scenario and earned a total score of ${data.total_score}.`
        this.modalScoreTarget.innerText = `${data.score}%`
        this.modalXpTarget.innerText = `+${data.xp_earned}`
        this.modalTarget.classList.remove('hidden')
      } else {
        this.scenarioContainerTarget.innerHTML = data.next_scenario_html
      }
    })
  }
}
