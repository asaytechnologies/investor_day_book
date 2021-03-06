import Vue from "vue/dist/vue.esm"

const elementSelector = "#portfolios-index-page"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  const newPortfolioSidebar = new Vue({
    el: "[data-behavior='new-portfolio-sidebar']",
    data: {
      opened: false,
      name: '',
      currencyName: 'RUB',
      currencyIndex: 2,
      currencySelectOpened: false,
      sourceName: '',
      sourceIndex: -1,
      sourceSelectOpened: false,
      fileFormats: '',
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
        this.fileFormats = formats
        this.sourceSelectOpened = false
      },
      submitForm: function() {
        this.validation = true
      }
    }
  })
})
