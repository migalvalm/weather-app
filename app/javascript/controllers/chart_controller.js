import { Controller } from '@hotwired/stimulus'
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)

export default class extends Controller {
  static values = {
    data: Array
  }

  static targets = ['chart']

  connect() {
    this.initializeChart()
  }

  initializeChart() {
    const ctx = this.chartTarget.getContext('2d')
    const data = this.getData()

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: data.labels,
        datasets: [
          {
            label: 'Sunrise',
            data: data.sunriseValues,
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
            fill: true
          },
          {
            label: 'Golden Hour',
            data: data.goldenHourValues,
            borderColor: 'rgb(54, 162, 235)',
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            fill: true
          },
          {
            label: 'Sunset',
            data: data.sunsetValues,
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.5)',
            fill: true
          }
        ]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Time of Day'
            }
          },
          x: {
            title: {
              display: true,
              text: 'Date'
            }
          }
        }
      }
    })
  }

  getData() {
    const data = {
      labels: [],
      sunriseValues: [],
      goldenHourValues: [],
      sunsetValues: []
    }


    this.dataValue.forEach(day => {
      data.labels.push(day.date)
      data.sunriseValues.push(this.convertTimeToNumber(day.sunrise_time))
      data.goldenHourValues.push(this.convertTimeToNumber(day.golden_hour))
      data.sunsetValues.push(this.convertTimeToNumber(day.sunset_time))
    })

    return data
  }

  convertTimeToNumber(timeStr) {
    const [hours, minutes, seconds] = timeStr.split(':').map(value => {
      const num = Number(value)
      console.log(`Parsed ${value} to ${num}`)
      return isNaN(num) ? 0 : num
    })

    const result = hours + minutes / 60 + seconds / 3600
    return result
  }
}