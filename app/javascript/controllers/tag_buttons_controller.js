document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".tag-button").forEach(button => {
    button.addEventListener("click", function(event) {
      event.preventDefault();
      const checkbox = this.querySelector("input[type='checkbox']");
      checkbox.checked = !checkbox.checked;
      this.classList.toggle("active");
    });
  });
});
