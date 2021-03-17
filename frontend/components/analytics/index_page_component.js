import Vue         from "vue/dist/vue.esm"
import VueResource from "vue-resource"
import debounce    from "v-debounce"
import { t }       from "ttag"
import Chart       from "chart.js"
import getSymbolFromCurrency from "currency-symbol-map"

import { showNotification } from "../shared/modules/notifications"

Vue.use(VueResource)

const elementSelector = "#analytics-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const accessToken = document.getElementById("access_token").value
  const currentLocale = document.getElementById("current_locale").value

  const positions = new Vue({
    el: "#positions",
    data: {
      analytics: {},
      activesChartVisible: true,
      sectorsChartVisible: true
    },
    created() {
      this.getPositions(null)
    },
    computed: {
      incomePercentPositive: function() {
        const incomePercent = this.analytics.positions.total.summary.income_percent

        return incomePercent >= 0
      },
      incomePercentValue: function() {
        const incomePercent = this.analytics.positions.total.summary.income_percent

        return incomePercent >= 0 ? `+${incomePercent}%` : `${incomePercent}%`
      }
    },
    methods: {
      getPositions: function(portfolioId) {
        const params = { access_token: accessToken, locale: currentLocale }
        if (portfolioId !== null && portfolioId !== 0) params.portfolio_id = portfolioId
        this.$http.get("/api/v1/analytics", { params: params }).then(function(data) {
          this.analytics = data.body
          this.renderActivesChart()
          this.renderSectorsChart()
        })
      },
      presentMoney: function(value, currency, rounding) {
        return `${parseFloat(value).toFixed(2)} ${getSymbolFromCurrency(currency)}`
      },
      profitClass: function(value) {
        if (value > 0) return 'profit profitable'
        else if (value < 0) return 'profit negative'
        else return 'profit'
      },
      renderActivesChart: function() {
        if (Object.keys(this.analytics.actives_pie_stats).length === 0) {
          this.activesChartVisible = false
          return undefined
        } else this.activesChartVisible = true

        const chartData = {
          datasets: [{
            data: Object.values(this.analytics.actives_pie_stats).map(element => element.amount),
            backgroundColor: Object.values(this.analytics.actives_pie_stats).map(element => element.color)
          }],
          labels: Object.keys(this.analytics.actives_pie_stats)
        }

        const pieChart = new Chart(document.getElementById("actives-pie"), {
          type: 'pie',
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
        document.getElementById("actives-legend").innerHTML = pieChart.generateLegend()
      },
      renderSectorsChart: function() {
        if (Object.keys(this.analytics.sector_pie_stats).length === 0) {
          this.sectorsChartVisible = false
          return undefined
        } else this.sectorsChartVisible = true

        const chartData = {
          datasets: [{
            data: Object.values(this.analytics.sector_pie_stats).map(element => element.amount),
            backgroundColor: Object.values(this.analytics.sector_pie_stats).map(element => element.color)
          }],
          labels: Object.keys(this.analytics.sector_pie_stats)
        }

        const pieChart = new Chart(document.getElementById("sectors-pie"), {
          type: 'pie',
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

        positions.getPositions(id)
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
          positions.getPositions(postfolioSelect.selectedIndex)
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
