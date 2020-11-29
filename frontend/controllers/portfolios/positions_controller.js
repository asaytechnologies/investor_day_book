import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  filterPortfolios (event) {
    event.preventDefault()

    this.stimulate('PositionsReflex#index', document.getElementById('portfolio_id').value, document.getElementById('current_locale').value)
  }
}
