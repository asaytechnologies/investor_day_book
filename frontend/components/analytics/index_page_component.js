import Vue         from "vue/dist/vue.esm"
import VueResource from "vue-resource"
import debounce    from "v-debounce"
import { t }       from "ttag"
import Chart       from "chart.js"

import { showNotification } from "../shared/modules/notifications"
import { presentMoney } from "../shared/modules/money_presenter"

Vue.use(VueResource)

const elementSelector = "#analytics-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const accessToken = document.getElementById("access_token").value
  const currentLocale = document.getElementById("current_locale").value

  const activeTypesOrder = {
    "Share": 3,
    "Bond": 2,
    "Foundation": 1
  }

  const activeTypesColors = {
    "Share": "red",
    "Bond": "blue",
    "Foundation": "green"
  }

  const positions = new Vue({
    el: "#positions",
    data: {
      activesChartVisible: true,
      sectorsChartVisible: true,
      insights: []
    },
    created() {
      this.getInsights(null)
    },
    computed: {
    },
    methods: {
      getInsights: function(portfolioId) {
        const params = { access_token: accessToken, locale: currentLocale }
        if (portfolioId !== null && portfolioId !== 0) params.portfolio_id = portfolioId
        this.$http.get("/api/v1/insights", { params: params }).then(function(data) {
          const insightsData = data.body.insights.data.map((element) => {
            return element.attributes
          })
          const activeTypes = insightsData.filter((element) => {
            return element.insightable_type === "ActiveType"
          })

          activeTypes.sort((a, b) => {
            return activeTypesOrder[a.insightable_name] > activeTypesOrder[b.insightable_name]
          })

          let insights = []
          activeTypes.forEach((activeType) => {
            let positions = []
            if (activeType.insightable_name === "Share") {
              const sectors = insightsData.filter((element) => {
                return element.insightable_type === "Sector"
              })
              sectors.forEach((sector) => {
                positions.unshift(sector)
                insightsData.forEach((element) => {
                  if (element.security_type === "Share" && element.security_sector_name === sector.insightable_name) positions.unshift(element)
                })
              })
            } else {
              insightsData.forEach((element) => {
                if (element.security_type === activeType.insightable_name) positions.unshift(element)
              })
            }
            activeType.positions = positions
            insights.unshift(activeType)
          })
          this.insights = insights
          this.renderActivesChart()
          this.renderSectorsChart()
        })
      },
      presentMoney: function(value, currency, rounding) {
        return presentMoney(value, currency, rounding)
      },
      profitClass: function(value) {
        if (value > 0) return "profit profitable"
        else if (value < 0) return "profit negative"
        else return "profit"
      },
      sectorClass: function(position) {
        if (position.insightable_type === "Sector") return "sector"
      },
      securityName: function(value) {
        switch (value) {
          case "Share":
            return t`Shares`
          case "Bond":
            return t`Bonds`
          case "Foundation":
            return t`Foundation`
        }
      },
      renderActivesChart: function() {
        if (this.insights.length === 0) {
          this.activesChartVisible = false
          return undefined
        } else this.activesChartVisible = true

        const amountData = []
        const colorData = []
        const labelData = []
        let totalPrice = 0
        this.insights.forEach((element) => {
          totalPrice += element.stats.price
        })
        this.insights.sort((a, b) => {
          return a.stats.price < b.stats.price
        }).forEach((element) => {
          amountData.push(totalPrice === 0 ? 0 : ((element.stats.price / totalPrice) * 100).toFixed(2))
          colorData.push(activeTypesColors[element.insightable_name])
          labelData.push(this.securityName(element.insightable_name))
        })
        const chartData = {
          datasets: [{
            data: amountData,
            backgroundColor: colorData
          }],
          labels: labelData
        }

        const pieChart = new Chart(document.getElementById("actives-pie"), {
          type: "pie",
          data: chartData,
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
                  text.push("</li>")
                }
              }
              text.push("</ul>")
              return text.join("")
            },
            legend: {
              display: false
            }
          }
        })
        document.getElementById("actives-legend").innerHTML = pieChart.generateLegend()
      },
      renderSectorsChart: function() {
        if (this.insights.length === 0) {
          this.sectorsChartVisible = false
          return undefined
        } else this.sectorsChartVisible = true

        let sectorsData = []
        this.insights.forEach((insight) => {
          if (insight.insightable_name === "Share") {
            sectorsData = insight.positions.filter((element) => {
              return element.insightable_type === "Sector"
            }).sort((a, b) => {
              return a.stats.price < b.stats.price
            })
          }
        })

        if (sectorsData.length === 0) {
          this.sectorsChartVisible = false
          return undefined
        } else this.sectorsChartVisible = true

        const amountData = []
        const colorData = []
        const labelData = []
        let totalPrice = 0
        sectorsData.forEach((element) => {
          totalPrice += element.stats.price
        })
        sectorsData.forEach((element) => {
          amountData.push(totalPrice === 0 ? 0 : ((element.stats.price / totalPrice) * 100).toFixed(2))
          colorData.push(element.security_sector_color)
          labelData.push(element.insightable_name)
        })
        const chartData = {
          datasets: [{
            data: amountData,
            backgroundColor: colorData
          }],
          labels: labelData
        }

        const pieChart = new Chart(document.getElementById("sectors-pie"), {
          type: "pie",
          data: chartData,
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
                  text.push("</li>")
                }
              }
              text.push("</ul>")
              return text.join("")
            },
            legend: {
              display: false
            }
          }
        })

        document.getElementById("legend").innerHTML = pieChart.generateLegend()
      }
    }
  })

  const postfolioSelect = new Vue({
    el: "#portfolio-select",
    data: {
      opened: false,
      selectedName: t`All portfolios stats`,
      selectedIndex: 0
    },
    computed: {
      isSelectOpen: function () {
        return this.opened === true
      }
    },
    methods: {
      toggleSelect: function() {
        this.opened = !this.opened
      },
      selectPortfolio: function(name, id) {
        this.selectedName = name
        this.selectedIndex = id
        this.opened = false

        positions.getInsights(id)
      }
    }
  })

  const newPositionSidebar = new Vue({
    el: "[data-behavior='new-position-sidebar']",
    data: {
      opened: false,
      portfolioName: "",
      portfolioIndex: null,
      portfolioSelectOpened: false,
      securitySearchValue: "",
      lastSecuritySearchValue: "",
      quotes: [],
      selectedQuoteName: "",
      selectedQuoteIndex: null,
      transactionName: t`Buy`,
      transactionIndex: 0,
      transactionSelectOpened: false,
      price: null,
      amount: null,
      operationDate: null,
      validation: false
    },
    computed: {
      isSidebarOpen: function () {
        return this.opened === true
      },
      isPortfolioSelectOpen: function () {
        return this.portfolioSelectOpened === true
      },
      isTransactionSelectOpen: function () {
        return this.transactionSelectOpened === true
      },
      totalPrice: function() {
        if (Number.isNaN(parseFloat(this.price))) return 0
        if (Number.isNaN(parseFloat(this.amount))) return 0

        return (parseFloat(this.price) * parseFloat(this.amount)).toFixed(2)
      }
    },
    methods: {
      openSidebar: function() {
        this.opened = true
      },
      hideSidebar: function() {
        this.opened = false
      },
      togglePortfolioSelect: function() {
        this.portfolioSelectOpened = !this.portfolioSelectOpened
      },
      selectPortfolio: function(name, index) {
        this.portfolioName = name
        this.portfolioIndex = index
        this.portfolioSelectOpened = false
      },
      clearSearch: function() {
        this.securitySearchValue = ""
        this.lastSecuritySearchValue = ""
        this.quotes = []
      },
      searchSecurities: function(event) {
        if (this.securitySearchValue.length === 0 || this.lastSecuritySearchValue === this.securitySearchValue) return

        this.$http.get("/api/v1/quotes/search", { params: { access_token: accessToken, query: this.securitySearchValue, locale: currentLocale } }).then(function(data) {
          this.quotes = data.body.quotes.data.reduce(function(acc, current) {
            if (acc[current.attributes.security_type]) {
              acc[current.attributes.security_type].push(current)
            } else {
              acc[current.attributes.security_type] = [current]
            }
            return acc
          }, {})
          this.lastSecuritySearchValue = this.securitySearchValue
        })
      },
      selectQuote: function(name, id) {
        this.securitySearchValue = ""
        this.lastSecuritySearchValue = ""
        this.quotes = []
        this.selectedQuoteName = name
        this.selectedQuoteIndex = id
      },
      clearSelectedQuote: function() {
        this.selectedQuoteName = ""
        this.selectedQuoteIndex = null
      },
      toggleTransactionSelect: function() {
        this.transactionSelectOpened = !this.transactionSelectOpened
      },
      selectTransaction: function(name, index) {
        this.transactionName = name
        this.transactionIndex = index
        this.transactionSelectOpened = false
      },
      createPosition: function() {
        this.validation = true
        if (this.portfolioIndex === null) return showNotification("error", `<p>${t`You need to select portfolio`}</p>`)
        if (this.selectedQuoteIndex === null) return showNotification("error", `<p>${t`You need to select security`}</p>`)
        if (this.price === null) return showNotification("error", `<p>${t`You need to specify price`}</p>`)
        if (this.amount === null) return showNotification("error", `<p>${t`You need to specify amount`}</p>`)
        if (this.operationDate === null) return showNotification("error", `<p>${t`You need to specify operation date`}</p>`)

        const params = {
          access_token: accessToken,
          position:     {
            portfolio_id:   this.portfolioIndex,
            quote_id:       this.selectedQuoteIndex,
            price:          this.price,
            amount:         this.amount,
            operation:      this.transactionIndex,
            operation_date: this.operationDate
          },
          locale:       currentLocale
        }
        this.$http.post("/api/v1/users/positions", params).then(function(data) {
          this.clearSidebar()
          showNotification("success", `<p>${t`Operation is added`}</p>`)
          positions.getInsights(postfolioSelect.selectedIndex)
        })
      },
      clearSidebar: function() {
        this.opened = false
        this.portfolioName = ""
        this.portfolioIndex = null
        this.portfolioSelectOpened = false
        this.securitySearchValue = ""
        this.lastSecuritySearchValue = ""
        this.quotes = []
        this.selectedQuoteName = ""
        this.selectedQuoteIndex = null
        this.transactionName = t`Buy`
        this.transactionIndex = 0
        this.transactionSelectOpened = false
        this.price = null
        this.amount = null
        this.operationDate = null
      }
    },
    directives: {
      debounce
    }
  })

  const newBalanceSidebar = new Vue({
    el: "[data-behavior='new-balance-sidebar']",
    data: {
      opened: false,
      portfolioName: "",
      portfolioIndex: null,
      portfolioSelectOpened: false,
      transactionName: t`Buy`,
      transactionIndex: 0,
      transactionSelectOpened: false,
      scopeName: "",
      scopeIndex: null,
      scopeSelectOpened: false,
      eur: 0,
      usd: 0,
      rub: 0,
      validation: false
    },
    computed: {
      isSidebarOpen: function () {
        return this.opened === true
      },
      isPortfolioSelectOpen: function () {
        return this.portfolioSelectOpened === true
      },
      isTransactionSelectOpen: function () {
        return this.transactionSelectOpened === true
      },
      isScopeSelectOpen: function () {
        return this.scopeSelectOpened === true
      }
    },
    methods: {
      openSidebar: function() {
        this.opened = true
      },
      hideSidebar: function() {
        this.opened = false
      },
      togglePortfolioSelect: function() {
        this.portfolioSelectOpened = !this.portfolioSelectOpened
      },
      selectPortfolio: function(name, index) {
        this.portfolioName = name
        this.portfolioIndex = index
        this.portfolioSelectOpened = false
      },
      toggleTransactionSelect: function() {
        this.transactionSelectOpened = !this.transactionSelectOpened
      },
      selectTransaction: function(name, index) {
        this.transactionName = name
        this.transactionIndex = index
        this.transactionSelectOpened = false
      },
      toggleScopeSelect: function() {
        this.scopeSelectOpened = !this.scopeSelectOpened
      },
      selectScope: function(name, index) {
        this.scopeName = name
        this.scopeIndex = index
        this.scopeSelectOpened = false
      },
      changeBalance: function() {
        this.validation = true
        if (this.portfolioIndex === null) return showNotification("error", `<p>${t`You need to select portfolio`}</p>`)
        if (this.scopeIndex === null) return showNotification("error", `<p>${t`You need to select operation type`}</p>`)

        const params = {
          access_token: accessToken,
          portfolio:    {
            operation: this.transactionIndex,
            usd:       this.usd,
            eur:       this.eur,
            rub:       this.rub,
            scope:     this.scopeIndex
          },
          locale:       currentLocale
        }
        this.$http.patch(`/api/v1/portfolios/cashes/${this.portfolioIndex}`, params).then(function(data) {
          this.clearSidebar()
          showNotification("success", `<p>${t`Portfolio balance is changed`}</p>`)
          positions.getPositions(postfolioSelect.selectedIndex)
        })
      },
      clearSidebar: function() {
        this.opened = false
        this.portfolioName = ""
        this.portfolioIndex = null
        this.portfolioSelectOpened = false
        this.transactionName = t`Buy`
        this.transactionIndex = 0
        this.transactionSelectOpened = false
        this.scopeName = ""
        this.scopeIndex = null
        this.scopeSelectOpened = false
        this.eur = 0
        this.usd = 0
        this.rub = 0
      }
    }
  })
})
