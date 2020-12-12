import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["switch", "value"]
  static values = { element: Boolean }

  connect () {
    this.valueTarget.value = this.elementValue
  }

  toggleElement () {
    this.elementValue = !this.elementValue

    if (this.elementValue) this.switchTarget.classList.add("selected")
    else this.switchTarget.classList.remove("selected")
    this.valueTarget.value = this.elementValue
  }
}
