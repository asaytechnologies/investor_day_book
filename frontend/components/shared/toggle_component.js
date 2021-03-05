import Vue from "vue/dist/vue.esm"

document.addEventListener("DOMContentLoaded", () => {
  Object.entries(document.getElementsByClassName('toggle')).forEach(([index, element]) => {
    new Vue({
      el: element,
      data: {
        opened: false
      },
      computed: {
        isOpen: function () {
          return this.opened === true
        }
      },
      methods: {
        open: function() {
          this.opened = true
        },
        hide: function() {
          this.opened = false
        },
        toggle: function() {
          this.opened = !this.opened
        }
      }
    })
  })
})
