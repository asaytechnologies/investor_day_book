import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["window"]

  open () {
    this.windowTarget.classList.add("open")
  }

  close () {
    this.windowTarget.classList.remove("open")
  }
}
