import { t } from "ttag"

import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  clearPortfolio (event) {
    var result = confirm(t`Do you really want to delete all operations in portfolio?`)
    if (result) {
      this.stimulate(
        'PortfoliosReflex#clear',
        {
          portfolio_id: event.target.dataset.valueIndex,
          locale:       document.getElementById('current_locale').value
        }
      )
    }
  }

  destroyPortfolio (event) {
    var result = confirm(t`Do you really want to delete portfolio?`)
    if (result) {
      this.stimulate(
        'PortfoliosReflex#destroy',
        {
          portfolio_id: event.target.dataset.valueIndex,
          locale:       document.getElementById('current_locale').value
        }
      )
    }
  }
}
