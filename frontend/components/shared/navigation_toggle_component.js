import Vue from "vue/dist/vue.esm"

const elementSelector = "[data-behavior='navigation-toggle']"

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(elementSelector) === null) return

  new Vue({
    el: elementSelector,
    data: {
      opened: false
    },
    computed: {
      isOpen: function () {
        return this.opened === true
      }
    },
    methods: {
      toggle: function() {
        this.opened = !this.opened
      }
    }
  })
})
