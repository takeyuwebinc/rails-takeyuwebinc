import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview"];

  connect() {
    this.preview();
  }

  preview() {
    const formData = new FormData(this.element.querySelector("form"));
    formData.append("_method", "POST");
    fetch("/admin/pages/preview", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.text())
      .then((html) => {
        console.log(html);
        this.previewTarget.innerHTML = html;
      });
  }
}