const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')

const CompressionPlugin = require('compression-webpack-plugin')
const { VueLoaderPlugin } = require('vue-loader')

environment.plugins.prepend('env',
  new CompressionPlugin({
    filename: '[path].gz[query]',
    algorithm: 'brotliCompress',
    test: /\.js$|\.css$/,
    threshold: 10240,
    minRatio: 0.8,
    cache: true
  })
)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
