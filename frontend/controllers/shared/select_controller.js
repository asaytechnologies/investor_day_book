import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["list", "value", "valueIndex"]

  connect () {
    this.valueTarget.innerHTML = this.data.get("value")
    this.valueIndexTarget.value = this.data.get("valueIndex")
  }

  open () {
    this.listTarget.classList.add("open")
  }

  select (event) {
    this.listTarget.classList.remove("open")

    this.valueTarget.innerHTML = event.target.innerHTML
    this.valueIndexTarget.value = event.target.dataset.valueIndex
  }
}
