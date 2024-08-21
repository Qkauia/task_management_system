import "@hotwired/turbo-rails";
import "./controllers";

import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import { Mandarin } from "flatpickr/dist/l10n/zh";
import 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener("turbo:load", () => {
  $('.select2').select2({
    width: '100%',
    theme: 'bootstrap-5'
  });
});

document.addEventListener("turbo:load", () => {
  flatpickr(".datetime-picker", {
    locale: Mandarin,
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
