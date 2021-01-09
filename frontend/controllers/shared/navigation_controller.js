import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["list"]

  toggle () {
    this.listTarget.classList.toggle("open")
  }
}
