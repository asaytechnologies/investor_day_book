import getSymbolFromCurrency from "currency-symbol-map"

function presentMoney(value, currency, rounding) {
  const roundedValue = +(parseFloat(value)).toFixed(rounding)
  return `${roundedValue} ${getSymbolFromCurrency(currency)}`
}

export { presentMoney }
