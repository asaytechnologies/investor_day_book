import ApplicationController from "../application_controller"
import Chart from 'chart.js'

export default class extends ApplicationController {
  static values = { pie: Object }

  connect () {
    const data = {
      datasets: [{
        data: Object.values(this.pieValue).map(element => element.amount),
        backgroundColor: Object.values(this.pieValue).map(element => element.color)
      }],
      labels: Object.keys(this.pieValue)
    }

    new Chart(document.getElementById('sectors-pie'), {
      type: 'pie',
      data: data,
      options: {
        legend: {
          position: 'right'
        }
      }
    })
  }
}
