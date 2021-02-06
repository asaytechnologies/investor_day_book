import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  submitForm (event) {
    event.preventDefault()

    this.stimulate(
      'Portfolios::CashesReflex#create',
      {
        portfolio_id:   document.getElementById('portfolio_id').value,
        locale:         document.getElementById('current_locale').value
      }
    )
  }
}
