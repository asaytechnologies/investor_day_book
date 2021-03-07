import Vue         from "vue/dist/vue.esm"
import VueResource from "vue-resource"
import debounce    from "v-debounce"
import { t }       from "ttag"

Vue.use(VueResource)

const elementSelector = "#analytics-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const accessToken = document.getElementById("access_token").value

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
      }
    }
  })

  const newPositionSidebar = new Vue({
    el: "[data-behavior='new-position-sidebar']",
    data: {
      currentLocale: document.getElementById("current_locale").value,
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

        this.$http.get("/api/v1/quotes/search.json", { params: { access_token: accessToken, query: this.securitySearchValue } }).then(function(data) {
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
        const params = {
          access_token: accessToken,
          position:     {
            portfolio_id:   this.portfolioIndex,
            quote_id:       this.selectedQuoteIndex,
            price:          this.price,
            amount:         this.amount,
            operation:      this.transactionIndex,
            operation_date: this.operationDate
          }
        }
        this.$http.post("/api/v1/users/positions.json", params).then(function(data) {
          this.clearSidebar()
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
      validation: false
    },
    computed: {
      isSidebarOpen: function () {
        return this.opened === true
      }
    },
    methods: {
      openSidebar: function() {
        this.opened = true
      },
      hideSidebar: function() {
        this.opened = false
      }
    }
  })

  const newIncomesSidebar = new Vue({
    el: "[data-behavior='new-incomes-sidebar']",
    data: {
      opened: false,
      validation: false
    },
    computed: {
      isSidebarOpen: function () {
        return this.opened === true
      }
    },
    methods: {
      openSidebar: function() {
        this.opened = true
      },
      hideSidebar: function() {
        this.opened = false
      }
    }
  })
})
