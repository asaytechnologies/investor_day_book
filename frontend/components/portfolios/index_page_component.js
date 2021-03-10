import Vue         from "vue/dist/vue.esm"
import VueResource from "vue-resource"
import { t }       from "ttag"

Vue.use(VueResource)

const elementSelector = "#portfolios-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const portfolios = new Vue({
    el: "#portfolios",
    data: {
      accessToken: document.getElementById("access_token").value,
      portfolios: []
    },
    created() {
      this.getPortfolios()
    },
    methods: {
      getPortfolios: function() {
        this.$http.get("/api/v1/portfolios.json", { params: { access_token: this.accessToken } }).then(function(data) {
          this.portfolios = data.body.portfolios.data
        })
      },
      createPortfolio: function(name, currency, source, file) {
        if (file) this.createPortfolioWithFile(name, currency, source, file)
        else this.createPortfolioWithoutFile(name, currency, source)
      },
      createPortfolioWithFile: function(name, currency, source, file) {
        const formData = new FormData()
        formData.append("portfolio[name]", name)
        formData.append("portfolio[currency]", currency)
        formData.append("portfolio[source]", source)
        formData.append("upload[file]", file)
        formData.append("access_token", this.accessToken)
        const config = { headers : { "Content-Type" : "multipart/form-data" } }
        this.$http.post("/api/v1/portfolios.json", formData, config).then(function(data) {
          this.addPortfolioToList(data.body.portfolio.data.attributes)
        })
      },
      createPortfolioWithoutFile: function(name, currency, source) {
        const params = {
          access_token: this.accessToken,
          portfolio:    {
            name:     name,
            currency: currency,
            source:   source
          }
        }
        this.$http.post("/api/v1/portfolios.json", params).then(function(data) {
          this.addPortfolioToList(data.body.portfolio.data.attributes)
        })
      },
      addPortfolioToList: function(attributes) {
        const portfolio = {
          id:         attributes.id,
          attributes: attributes
        }
        this.portfolios = [portfolio].concat(this.portfolios)

        newPortfolioSidebar.clearSidebar()

        this.showNotification(
          "success",
          `<p>${t`File for portfolio is uploaded`}</p><p>${t`Portfolio positions will be created in a few minutes`}</p>`
        )
      },
      destroyPortfolio: function(id) {
        var result = confirm(t`Do you really want to delete portfolio?`)
        if (!result) return

        this.$http.delete(`/api/v1/portfolios/${id}.json`, { params: { access_token: this.accessToken } }).then(function() {
          this.removePortfolioFromList(id)
          this.showNotification(
            "success",
            `<p>${t`Portfolio is destroyed`}</p>`
          )
        })
      },
      clearPortfolio: function(id) {
        var result = confirm(t`Do you really want to delete all operations in portfolio?`)
        if (!result) return

        this.$http.post(`/api/v1/portfolios/${id}/clear.json`, { access_token: this.accessToken }).then(function() {
          this.showNotification(
            "success",
            `<p>${t`Portfolio is cleared`}</p>`
          )
        })
      },
      showNotification: function(status, message) {
        const notification = document.createElement("div")
        notification.classList.add("notification")
        notification.classList.add(status)
        notification.innerHTML = message
        document.getElementById("notifications").append(notification)
        setTimeout(() => notification.remove(), 2500)
      },
      removePortfolioFromList: function(id) {
        const portfolio = this.portfolios.find((element) => {
          return element.attributes.id === id
        })
        if (!portfolio) return

        const portfolios = this.portfolios
        const portfolioIndex = portfolios.indexOf(portfolio)
        if (portfolioIndex === -1) return

        portfolios.splice(portfolioIndex, 1)
        this.portfolios = portfolios
      }
    }
  })

  const newPortfolioSidebar = new Vue({
    el: "[data-behavior='new-portfolio-sidebar']",
    data: {
      opened: false,
      name: "",
      currencyName: 'RUB',
      currencyIndex: 2,
      currencySelectOpened: false,
      sourceName: "",
      sourceIndex: -1,
      sourceSelectOpened: false,
      file: null,
      fileFormats: "",
      validation: false
    },
    computed: {
      isSidebarOpen: function () {
        return this.opened === true
      },
      isCurrencySelectOpen: function () {
        return this.currencySelectOpened === true
      },
      isSourceSelectOpen: function () {
        return this.sourceSelectOpened === true
      },
      isSourceSelected: function() {
        return this.sourceIndex !== -1
      }
    },
    methods: {
      openSidebar: function() {
        this.opened = true
      },
      hideSidebar: function() {
        this.opened = false
      },
      clearSidebar: function() {
        this.name = ""
        this.file = null
        this.fileFormats = ""
        this.validation = false
        this.hideSidebar()
      },
      toggleCurrencySelect: function() {
        this.currencySelectOpened = !this.currencySelectOpened
      },
      selectCurrency: function(name, index) {
        this.currencyName = name
        this.currencyIndex = index
        this.currencySelectOpened = false
      },
      toggleSourceSelect: function() {
        this.sourceSelectOpened = !this.sourceSelectOpened
      },
      selectBroker: function(name, index, formats) {
        this.sourceName = name
        this.sourceIndex = index
        this.file = null
        this.fileFormats = formats
        this.sourceSelectOpened = false
      },
      uploadFile: function() {
        this.file = event.target.files[0]
      },
      submitForm: function() {
        this.validation = true
        if (this.name) portfolios.createPortfolio(this.name, this.currencyIndex, this.sourceIndex, this.file)
      }
    }
  })
})
