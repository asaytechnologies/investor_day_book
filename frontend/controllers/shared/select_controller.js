import ApplicationController from "../application_controller"

import { useClickOutside } from "stimulus-use"

export default class extends ApplicationController {
  static targets = ["list", "value", "valueIndex"]

  connect () {
    this.valueTarget.innerHTML = this.data.get("value")
    this.valueIndexTarget.value = this.data.get("valueIndex")

    useClickOutside(this)
  }

  toggle () {
    this.listTarget.classList.toggle("open")
  }

  close (event) {
    event.preventDefault()

    this.listTarget.classList.remove("open")
  }

  select (event) {
    this.listTarget.classList.remove("open")

    this.valueTarget.innerHTML = event.target.innerHTML
    this.valueIndexTarget.value = event.target.dataset.valueIndex
  }
}
