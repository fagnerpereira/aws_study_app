import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["xpDisplay"]

  connect() {
    this.showXPCelebration()
  }

  showXPCelebration() {
    const xpEarned = parseInt(this.element.dataset.xpEarned)
    const xpCelebrationDiv = document.getElementById('xp-celebration')
    const xpDisplay = xpCelebrationDiv.querySelector('.font-black.text-lg')

    if (xpDisplay) {
      xpDisplay.textContent = `+${xpEarned} XP`
    }

    if (xpCelebrationDiv) {
      xpCelebrationDiv.classList.remove('hidden')
      xpCelebrationDiv.classList.add('xp-celebration')

      xpCelebrationDiv.addEventListener('animationend', () => {
        xpCelebrationDiv.classList.add('hidden')
        xpCelebrationDiv.classList.remove('xp-celebration')
        this.element.remove() // Remove the temporary element
      }, { once: true })
    }
  }
}