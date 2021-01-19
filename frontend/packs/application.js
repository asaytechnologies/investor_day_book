require("@rails/ujs").start()
require("channels")

import debounced from "debounced"
debounced.initialize()

import "controllers"
import "../stylesheets/application.scss"

import "../locales"
