import Rails from "@rails/ujs"

import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["name", "file", "source"]

  submitForm (event) {
    event.preventDefault()

    const file = this.fileTarget
    if (file.files && file.files[0] && file.files[0].size <= 1024000) {
      const formData = new FormData()
      const guid = this.generateRandomHex(12)
      formData.append("upload[file]", file.files[0])
      formData.append("upload[source]", this.sourceTarget.innerHTML)
      formData.append("upload[name]", "portfolio_initial_data")
      formData.append("upload[guid]", guid)

      Rails.ajax({
        url: "/uploads",
        type: "post",
        data: formData,
        success: () => this.success(guid)
      })
    } else {
      this.stimulate(
        'PortfoliosReflex#create',
        {
          locale: document.getElementById("current_locale").value
        }
      )
    }
  }

  generateRandomHex (size) {
    return [...Array(size)].map(() => Math.floor(Math.random() * 16).toString(16)).join("")
  }

  success (guid) {
    this.stimulate(
      'PortfoliosReflex#create',
      {
        locale: document.getElementById("current_locale").value,
        guid:   guid
      }
    )

    console.log("File was uploaded")
  }

  afterCreate () {
    this.nameTarget.value = ""
    this.fileTarget.value = ""
  }
}
