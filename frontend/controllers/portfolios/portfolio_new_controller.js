import Rails from "@rails/ujs"
import { t } from "ttag"

import ApplicationController from "../application_controller"

const megabyte = 1024000
const guidSize = 12

export default class extends ApplicationController {
  static targets = ["name", "file", "source"]

  submitForm (event) {
    event.preventDefault()

    const file = this.fileTarget
    if (file.files && file.files[0] && file.files[0].size <= megabyte) {
      const guid = this.generateRandomHex(guidSize)
      this.createPortfolioRequest(guid)

      const formData = new FormData()
      formData.append("upload[file]", file.files[0])
      formData.append("upload[source]", this.sourceTarget.innerHTML.toLowerCase())
      formData.append("upload[name]", "portfolio_initial_data")
      formData.append("upload[guid]", guid)

      Rails.ajax({
        url: "/uploads",
        type: "post",
        data: formData,
        success: () => this.success()
      })
    } else {
      this.createPortfolioRequest(null)
    }
  }

  generateRandomHex (size) {
    return [...Array(size)].map(() => Math.floor(Math.random() * 16).toString(16)).join("")
  }

  createPortfolioRequest (guid) {
    const args = { locale: document.getElementById("current_locale").value }
    if (guid !== null) args.guid = guid

    this.stimulate(
      'PortfoliosReflex#create',
      args
    )
  }

  success () {
    const notification = document.createElement("div")
    notification.classList.add("notification")
    notification.classList.add("success")
    notification.innerHTML = `<p>${t`File for portfolio is uploaded`}</p><p>${t`Portfolio positions will be created in a few minutes`}</p>`
    document.getElementById("notifications").append(notification)
    setTimeout(() => notification.remove(), 2500)
  }

  afterCreate () {
    this.nameTarget.value = ""
    this.fileTarget.value = ""
  }
}
