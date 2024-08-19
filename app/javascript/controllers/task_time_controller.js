import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Mandarin } from "flatpickr/dist/l10n/zh";

export default class extends Controller {
  static targets = ["startTime", "endTime"];

  connect() {
    this.initFlatpickr();
  }

  initFlatpickr() {
    flatpickr(this.startTimeTarget, {
      locale: Mandarin,
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      defaultDate: this.startTimeTarget.value || new Date()
    });

    flatpickr(this.endTimeTarget, {
      locale: Mandarin,
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      defaultDate: this.endTimeTarget.value || new Date()
    });
  }
}
