require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("bootstrap")
require("social-share-button")
require('chosen-js')
// CSS
import 'stylesheets'
// JS
import 'js'
// Images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
