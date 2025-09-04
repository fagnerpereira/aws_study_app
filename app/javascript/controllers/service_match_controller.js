import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "service", "dropzone", "modal", "modalTitle", "modalMessage", "modalScore", "modalXp" ]

  connect() {
    this.draggedItem = null
  }

  dragstart(event) {
    this.draggedItem = event.target.closest('.service-card')
    setTimeout(() => {
      event.target.style.display = 'none'
    }, 0)
  }

  dragend(event) {
    setTimeout(() => {
      if (this.draggedItem) {
        this.draggedItem.style.display = 'block'
        this.draggedItem = null
      }
    }, 0)
  }

  dragover(event) {
    event.preventDefault()
  }

  dragenter(event) {
    event.preventDefault()
    event.target.style.backgroundColor = 'rgba(0,0,0,0.3)'
  }

  dragleave(event) {
    event.target.style.backgroundColor = 'rgba(0,0,0,0.2)'
  }

  drop(event) {
    event.preventDefault()
    if (this.draggedItem) {
      event.target.appendChild(this.draggedItem)
      this.draggedItem.style.display = 'block'
    }
    event.target.style.backgroundColor = 'rgba(0,0,0,0.2)'
  }

  checkAnswers() {
    const matches = {}
    let totalMatches = 0
    this.dropzoneTargets.forEach(zone => {
      const category = zone.dataset.categoryName
      const servicesInZone = zone.querySelectorAll('.service-card')
      servicesInZone.forEach(service => {
        matches[service.dataset.serviceName] = category
        totalMatches++
      })
    })

    fetch('/games/service-match/check', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ service_matches: matches, matches: totalMatches })
    })
    .then(response => response.json())
    .then(data => {
      this.modalTitleTarget.innerText = data.message
      this.modalMessageTarget.innerText = `You correctly matched ${data.correct} out of ${data.total} services.`
      this.modalScoreTarget.innerText = `${data.score}%`
      this.modalXpTarget.innerText = `+${data.xp_earned}`
      this.modalTarget.classList.remove('hidden')
    })
  }
}
