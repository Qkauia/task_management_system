import flatpickr from "flatpickr";
import { Mandarin } from "flatpickr/dist/l10n/zh";

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