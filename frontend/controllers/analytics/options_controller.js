import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static values = { plan: Boolean }

  togglePlan () {
    this.planValue = !this.planValue

    this.stimulate(
      'PositionsReflex#index',
      document.getElementById('portfolio_id').value,
      document.getElementById('current_locale').value,
      this.planValue
    )
  }
}
