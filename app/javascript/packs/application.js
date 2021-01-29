require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("jquery")
require("bootstrap")
require("social-share-button")

// ICONS
import "@fortawesome/fontawesome-free/css/all"
// CSS
import 'stylesheets/application'
// JS
import 'js/application'
// Images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

