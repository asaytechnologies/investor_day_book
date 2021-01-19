import { addLocale, useLocale } from "ttag"
import Cookie from "js-cookie"

const locale = Cookie.get("invest_plan_locale") || "en"

if (locale !== "en") {
  const translationObj = require(`./${locale}.po.json`)
  addLocale(locale, translationObj)
  useLocale(locale)
}
