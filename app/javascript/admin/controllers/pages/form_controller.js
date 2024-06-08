import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview"];

  preview() {
    const formData = new FormData(this.element.querySelector("form"));
    formData.append("_method", "POST");
    fetch("/admin/pages/preview", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.text())
      .then((html) => {
        const previewWindow = window.open("", "preview");
        previewWindow.document.open();
        previewWindow.document.write(html);
        previewWindow.document.close();
      });
  }
}