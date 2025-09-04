import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "front", "back"]

  connect() {
    this.currentIndex = 0
    this.showCurrentCard()
  }

  showCurrentCard() {
    this.cardTargets.forEach((card, index) => {
      if (index === this.currentIndex) {
        card.style.zIndex = 10
        card.style.opacity = 1
        card.style.transform = "translateX(0)"
      } else if (index < this.currentIndex) {
        card.style.zIndex = 0
        card.style.opacity = 0
        card.style.transform = "translateX(-100%)"
      } else {
        card.style.zIndex = 0
        card.style.opacity = 0
        card.style.transform = "translateX(100%)"
      }
      this.frontTargets[index].classList.remove("hidden")
      this.backTargets[index].classList.add("hidden")
    })
  }

  flipCard() {
    const currentCardFront = this.frontTargets[this.currentIndex]
    const currentCardBack = this.backTargets[this.currentIndex]

    currentCardFront.classList.toggle("hidden")
    currentCardBack.classList.toggle("hidden")
  }

  nextCard() {
    if (this.currentIndex < this.cardTargets.length - 1) {
      this.currentIndex++
      this.showCurrentCard()
    }
  }

  prevCard() {
    if (this.currentIndex > 0) {
      this.currentIndex--
      this.showCurrentCard()
    }
  }
}