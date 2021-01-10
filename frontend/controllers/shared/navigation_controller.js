import ApplicationController from "../application_controller"

import { useClickOutside } from "stimulus-use"

export default class extends ApplicationController {
  static targets = ["list"]

  connect () {
    useClickOutside(this)
  }

  toggle () {
    this.listTarget.classList.toggle("open")
  }

  close (event) {
    event.preventDefault()

    this.listTarget.classList.remove("open")
  }
}
