import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "./controllers"
const application = Application.start()

import "bootstrap"
import "bootstrap/dist/css/bootstrap.min.css"
import "./controllers/tag_buttons_controller"
