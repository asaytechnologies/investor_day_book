import Rails from "@rails/ujs"

import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["name", "file", "source"]

  submitForm (event) {
    event.preventDefault()

    const file = this.fileTarget
    if (file.files && file.files[0]) {
      const formData = new FormData()
      formData.append("file", file.files[0])
      formData.append("source", this.sourceTarget.innerHTML)
      formData.append("upload_name", "portfolio_initial_data")

      Rails.ajax({
        url: "/uploads",
        type: "post",
        data: formData,
        success: () => this.success()
      })
    }

    this.stimulate(
      'PortfoliosReflex#create',
      {
        locale: document.getElementById("current_locale").value
      }
    )
  }

  success () {
    console.log("File was uploaded")
  }

  afterCreate () {
    this.nameTarget.value = ""
    this.fileTarget.value = ""
  }
}
