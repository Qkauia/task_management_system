import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-buttons"
export default class extends Controller {
  static targets = ["button", "letter", "count", "totalCount"];

  connect() {
    this.updateActiveStates();
  }

  toggle(event) {
    event.preventDefault();
    const checkbox = event.currentTarget.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
    event.currentTarget.classList.toggle("active", checkbox.checked);

    this.updateLetterAppearance(event.currentTarget.dataset.letter);
    this.updateTotalCount();
  }

  clearAll(event) {
    event.preventDefault();

    // 清除所有選取
    this.buttonTargets.forEach(button => {
      const checkbox = button.querySelector('input[type="checkbox"]');
      checkbox.checked = false;
      button.classList.remove("active");
    });

    // 重置字母背景和計數
    this.letterTargets.forEach(letter => {
      this.updateLetterAppearance(letter.dataset.letter);
    });

    // 更新總選取數量
    this.updateTotalCount();
  }

  updateActiveStates() {
    this.buttonTargets.forEach(button => {
      const checkbox = button.querySelector('input[type="checkbox"]');
      button.classList.toggle("active", checkbox.checked);
    });

    this.letterTargets.forEach(letter => {
      this.updateLetterAppearance(letter.dataset.letter);
    });

    this.updateTotalCount();
  }

  updateLetterAppearance(letter) {
    const relatedButtons = this.buttonTargets.filter(button => button.dataset.letter === letter);
    const selectedButtons = relatedButtons.filter(button => button.querySelector('input[type="checkbox"]').checked);

    const letterElement = this.letterTargets.find(l => l.dataset.letter === letter);
    const countElement = this.countTargets.find(c => c.dataset.letter === letter);

    if (letterElement) {
      letterElement.classList.toggle("bg-warning", selectedButtons.length > 0);
      letterElement.classList.toggle("text-white", selectedButtons.length > 0);
    }

    if (countElement) {
      countElement.textContent = selectedButtons.length > 0 ? `${selectedButtons.length}` : '';
    }
  }

  updateTotalCount() {
    const totalCount = this.buttonTargets.filter(button => button.querySelector('input[type="checkbox"]').checked).length;
    this.totalCountTarget.textContent = `${totalCount}`;
  }
}
