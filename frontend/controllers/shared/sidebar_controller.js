import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  open (event) {
    // close previous sidebar
    if (this.index) this.close()
    // open new sidebar
    const index = event.target.dataset.valueIndex
    this.index = index
    document.getElementById(`sidebar-window-${index}`).classList.add("open")
  }

  close () {
    document.getElementById(`sidebar-window-${this.index}`).classList.remove("open")
  }
}
