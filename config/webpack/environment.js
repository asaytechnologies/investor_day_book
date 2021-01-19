const { environment } = require('@rails/webpacker')
const CompressionPlugin = require('compression-webpack-plugin')

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

module.exports = environment
