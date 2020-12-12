import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["switch"]
  static values = { element: Boolean }

  toggleElement () {
    this.elementValue = !this.elementValue

    if (this.elementValue) this.switchTarget.classList.add("selected")
    else this.switchTarget.classList.remove("selected")
  }
}
