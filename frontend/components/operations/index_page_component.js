import Vue         from "vue/dist/vue.esm"
import VueResource from "vue-resource"
import { t }       from "ttag"

import { showNotification } from "../shared/modules/notifications"
import { presentMoney } from "../shared/modules/money_presenter"

Vue.use(VueResource)

const elementSelector = "#operations-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const accessToken = document.getElementById("access_token").value
  const currentLocale = document.getElementById("current_locale").value

  const operations = new Vue({
    el: "#operations",
    data: {
      positions: []
    },
    created() {
      this.getOperations(null)
    },
    computed: {
    },
    methods: {
      getOperations: function(portfolioId) {
        const params = {
          access_token: accessToken,
          locale:       currentLocale,
          fields:       'security_name,security_ticker,quote_currency,operation_date'
        }
        if (portfolioId !== null && portfolioId !== 0) params.portfolio_id = portfolioId
        this.$http.get("/api/v1/users/positions", { params: params }).then(function(data) {
          this.positions = data.body.positions.data
        })
      },
      presentMoney: function(value, currency, rounding) {
        return presentMoney(value, currency, rounding)
      },
      deleteOperation: function(position) {
        var result = confirm(t`Do you really want to delete operation?`)
        if (!result) return

        const params = {
          access_token: accessToken
        }
        this.$http.delete(`/api/v1/users/positions/${position.attributes.id}`, { params: params }).then(function(data) {
          const positions = this.positions
          const positionIndex = positions.indexOf(position)
          positions.splice(positionIndex, 1)
          this.positions = positions
          showNotification("success", `<p>${t`Operation is deleted`}</p>`)
        })
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

        operations.getOperations(id)
      }
    }
  })
})
