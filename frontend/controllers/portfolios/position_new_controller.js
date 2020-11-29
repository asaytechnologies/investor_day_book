import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["securityValue", "securityBlock", "dropdown", "quoteId", "price", "amount", "totalPrice", "selectInput", "operation"]

  searchQuotes (event) {
    event.preventDefault()

    this.stimulate('QuotesReflex#search', this.selectInputTarget.value, document.getElementById('current_locale').value)
  }

  selectQuote (event) {
    event.preventDefault()

    this.securityValueTarget.innerHTML = event.target.dataset.quoteName
    this.priceTarget.value             = event.target.dataset.quotePrice
    this.quoteIdTarget.value           = event.target.dataset.quoteId

    this.securityBlockTarget.classList.add("selected")
    this.dropdownTarget.classList.add("hidden")

    this.refreshTotalPrice()
  }

  refreshTotalPrice () {
    this.totalPriceTarget.value = parseFloat(this.priceTarget.value) * parseFloat(this.amountTarget.value)
  }

  submitForm (event) {
    event.preventDefault()

    this.stimulate('PositionsReflex#create', document.getElementById('portfolio_id').value, document.getElementById('current_locale').value)
  }

  afterCreate () {
    this.securityBlockTarget.classList.remove("selected")
    this.dropdownTarget.classList.remove("hidden")
    this.priceTarget.value = ""
    this.amountTarget.value = ""
    this.totalPriceTarget.value = ""
    this.selectInputTarget.value = ""
    this.securityValueTarget.innerHTML = ""
  }
}
