import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "./controllers"
const application = Application.start()

import "bootstrap"
import "bootstrap/dist/css/bootstrap.min.css"
import "./controllers/tag_buttons_controller"

import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import { Mandarin } from "flatpickr/dist/l10n/zh"

document.addEventListener("turbo:load", () => {
  flatpickr(".datetime-picker", {
    locale: Mandarin,
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
