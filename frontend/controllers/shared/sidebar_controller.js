import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["window"]

  open() {
    this.windowTarget.classList.add("open")
  }

  close() {
    this.windowTarget.classList.remove("open")
  }
}
