import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["securityValue", "securityBlock", "dropdown", "quoteId", "price", "amount", "totalPrice", "selectInput", "operation", "date", "clearSearch"]

  searchQuotes (event) {
    event.preventDefault()

    if (this.selectInputTarget.value.length > 0) {
      this.clearSearchTarget.classList.remove("hidden")
    } else {
      this.clearSearchTarget.classList.add("hidden")
    }

    this.stimulate("QuotesReflex#search", this.selectInputTarget.value, document.getElementById("current_locale").value)
  }

  clearSearch () {
    this.selectInputTarget.value = ""
    this.securityValueTarget.innerHTML = ""
    this.clearSearchTarget.classList.add("hidden")
    this.stimulate("QuotesReflex#search", "", document.getElementById("current_locale").value)
  }

  clearSecurity () {
    this.afterCreate()
  }

  selectQuote (event) {
    event.preventDefault()

    this.stimulate("QuotesReflex#search", "", document.getElementById("current_locale").value)
    this.securityValueTarget.innerHTML = event.target.dataset.quoteName
    this.priceTarget.value             = event.target.dataset.quotePrice
    this.quoteIdTarget.value           = event.target.dataset.quoteId

    this.securityBlockTarget.classList.add("selected")
    this.dropdownTarget.classList.add("hidden")

    this.refreshTotalPrice()
  }

  refreshTotalPrice () {
    if (Number.isNaN(parseFloat(this.priceTarget.value))) return
    if (Number.isNaN(parseFloat(this.amountTarget.value))) return

    this.totalPriceTarget.value = (parseFloat(this.priceTarget.value) * parseFloat(this.amountTarget.value)).toFixed(2)
  }

  submitForm (event) {
    event.preventDefault()

    if (Number.isNaN(parseFloat(this.priceTarget.value))) return
    if (Number.isNaN(parseFloat(this.amountTarget.value))) return
    if (this.quoteIdTarget.value.length === 0) return

    this.stimulate(
      'PositionsReflex#create',
      {
        portfolio_id:   document.getElementById("portfolio_id").value,
        show_plans:     document.getElementById("show_plans").value,
        show_dividents: document.getElementById("show_dividents").value,
        locale:         document.getElementById("current_locale").value
      }
    )
  }

  afterCreate () {
    this.clearSearchTarget.classList.add("hidden")
    this.securityBlockTarget.classList.remove("selected")
    this.dropdownTarget.classList.remove("hidden")
    this.priceTarget.value = ""
    this.amountTarget.value = ""
    this.quoteIdTarget.value = ""
    this.totalPriceTarget.value = ""
    this.selectInputTarget.value = ""
    this.securityValueTarget.innerHTML = ""
  }
}
