const flatpickr = require("flatpickr");
const { Mandarin } = require("flatpickr/dist/l10n/zh");

document.addEventListener("turbo:load", function() {
  document.querySelectorAll('.select2').forEach(function(selectElement) {
    new Select2(selectElement, {
      width: '100%',
      theme: 'bootstrap-5'
    });
  });
});

document.addEventListener("turbo:load", function() {
  flatpickr(".datetime-picker", {
    locale: Mandarin,
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
