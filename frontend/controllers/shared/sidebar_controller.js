import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  open (event) {
    const index = event.target.dataset.valueIndex

    this.index = index
    document.getElementById(`sidebar-window-${index}`).classList.add("open")
  }

  close () {
    document.getElementById(`sidebar-window-${this.index}`).classList.remove("open")
  }
}
