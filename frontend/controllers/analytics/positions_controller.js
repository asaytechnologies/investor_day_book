import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  filterByPortfolio (event) {
    event.preventDefault()

    this.stimulate(
      'PositionsReflex#index',
      {
        portfolio_id: document.getElementById('portfolio_id').value,
        show_plans:   document.getElementById('show_plans').value,
        locale:       document.getElementById('current_locale').value
      }
    )
  }
}
