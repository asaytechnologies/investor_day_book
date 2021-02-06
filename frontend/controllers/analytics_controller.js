import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  destroyPlan (event) {
    const positionIndex = event.target.dataset.valueIndex

    this.stimulate(
      'PositionsReflex#destroy',
      {
        position_id:  positionIndex,
        portfolio_id: document.getElementById('portfolio_id').value,
        locale:       document.getElementById('current_locale').value
      }
    )
  }
}
