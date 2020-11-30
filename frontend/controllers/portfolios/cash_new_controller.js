import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  submitForm (event) {
    event.preventDefault()

    this.stimulate('Portfolios::CashesReflex#create', document.getElementById('current_locale').value)
  }
}
