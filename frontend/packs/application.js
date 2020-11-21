import "init"

import "components/page_wrappers/devise/devise"
import "components/page_wrappers/page/page"

import "components/welcome/welcome"
import "components/home/home"

require("@rails/ujs").start()
require("channels")

import "controllers"
