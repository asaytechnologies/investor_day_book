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

    const pieChart = new Chart(document.getElementById("sectors-pie"), {
      type: 'pie',
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legendCallback: function (chart) {
          const text = []
          text.push("<ul class='legend-list'>")

          const data = chart.data
          const datasets = data.datasets
          const labels = data.labels

          if (datasets.length) {
            for (var i = 0; i < datasets[0].data.length; ++i) {
              text.push('<li><span style="background-color:' + datasets[0].backgroundColor[i] + '"></span>')
              if (labels[i]) {
                text.push(labels[i] + ' (' + datasets[0].data[i] + '%)')
              }
              text.push('</li>')
            }
          }
          text.push('</ul>')
          return text.join('')
        },
        legend: {
          display: false
        }
      }
    })

    document.getElementById("legend").innerHTML = pieChart.generateLegend()
  }
}
