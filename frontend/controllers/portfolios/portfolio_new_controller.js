import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["name"]

  submitForm (event) {
    event.preventDefault()

    this.stimulate('PortfoliosReflex#create', document.getElementById('current_locale').value)
  }

  afterCreate () {
    this.nameTarget.value = ""
  }
}
