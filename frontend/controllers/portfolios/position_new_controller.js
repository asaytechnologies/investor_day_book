import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["security", "dropdown", "quoteId", "price", "amount", "totalPrice", "selectInput"]

  selectQuote (event) {
    this.securityTarget.innerHTML = "<span class='form-label'>Security</span>" + "<span class='form-value'>" + event.target.getAttribute("data-quote-name") + "</span>"
    this.priceTarget.value = event.target.getAttribute("data-quote-price")
    this.quoteIdTarget.value = event.target.getAttribute("data-quote-id")

    this.securityTarget.classList.add("selected")
    this.dropdownTarget.classList.add("hidden")

    this.refreshTotalPrice()
  }

  refreshTotalPrice () {
    this.totalPriceTarget.value = parseFloat(this.priceTarget.value) * parseFloat(this.amountTarget.value)
  }

  afterCreate () {
    this.securityTarget.classList.remove("selected")
    this.dropdownTarget.classList.remove("hidden")
    this.priceTarget.value = ""
    this.amountTarget.value = ""
    this.totalPriceTarget.value = ""
    this.selectInputTarget.value = ""
  }
}
