import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal", "modalTitle", "modalMessage", "modalScore", "modalXp" ]

  connect() {
    this.selectedComponents = new Set()
  }

  toggleComponent(event) {
    const componentCard = event.currentTarget
    const componentName = componentCard.dataset.componentName
    
    if (this.selectedComponents.has(componentName)) {
      this.selectedComponents.delete(componentName)
      componentCard.classList.remove("bg-blue-200", "border-blue-500", "border-2")
    } else {
      this.selectedComponents.add(componentName)
      componentCard.classList.add("bg-blue-200", "border-blue-500", "border-2")
    }
  }

  checkArchitecture() {
    const scenario = {
      components: [
        { name: "Application Load Balancer", required: true },
        { name: "Auto Scaling Group", required: true },
        { name: "Amazon RDS Multi-AZ", required: true },
        { name: "Amazon S3", required: false },
        { name: "Amazon CloudFront", required: false },
        { name: "Amazon ElastiCache", required: false }
      ]
    }

    const requiredComponents = scenario.components.filter(c => c.required).map(c => c.name)
    const selected = Array.from(this.selectedComponents)
    
    const correctSelections = selected.filter(c => requiredComponents.includes(c))
    const incorrectSelections = selected.filter(c => !requiredComponents.includes(c))
    
    const score = Math.max(0, (correctSelections.length - incorrectSelections.length) / requiredComponents.length * 100)

    fetch('/games/architecture-challenge/check', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        selected_components: selected,
        scenario_title: "High Availability Web Application"
      })
    })
    .then(response => response.json())
    .then(data => {
      this.modalTitleTarget.innerText = data.message
      this.modalMessageTarget.innerText = `You selected ${correctSelections.length} out of ${requiredComponents.length} required components correctly.`
      this.modalScoreTarget.innerText = `${data.score}%`
      this.modalXpTarget.innerText = `+${data.xp_earned}`
      this.modalTarget.classList.remove('hidden')
    })
  }
}
