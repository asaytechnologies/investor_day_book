import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  submitForm (event) {
    event.preventDefault()

    this.stimulate(
      'Portfolios::CashesReflex#update_balance',
      {
        portfolio_id:   document.getElementById('portfolio_id').value,
        show_plans:     document.getElementById('show_plans').value,
        show_dividents: document.getElementById('show_dividents').value,
        locale:         document.getElementById('current_locale').value
      }
    )
  }
}
