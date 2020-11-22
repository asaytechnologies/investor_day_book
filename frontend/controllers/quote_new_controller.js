import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ["security", "dropdown", "price"]

  selectQuote(event) {
    this.securityTarget.innerHTML = "<span class='text-label'>Security</span>" + "<span class='text-value'>" + event.target.getAttribute("data-quote-name") + "</span>"
    this.priceTarget.value = event.target.getAttribute("data-quote-price")

    this.securityTarget.classList.add("selected")
    this.dropdownTarget.classList.add("hidden")
  }
}
