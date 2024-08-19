import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.buttonTargets.forEach(button => {
      button.addEventListener("click", this.toggleSelection.bind(this));
    });
  }

  toggleSelection(event) {
    event.preventDefault();
    const checkbox = event.currentTarget.querySelector("input[type='checkbox']");
    checkbox.checked = !checkbox.checked;
    event.currentTarget.classList.toggle("active");
  }
}