import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        token: String
    }

    connect() {
        let elem = document.querySelector('meta[name="csrf-token"]');
        if (!elem) {
            elem = document.createElement('meta');
            elem.setAttribute('name', 'csrf-token');
            document.head.appendChild(elem);
        }
        elem.setAttribute('content', this.tokenValue);
    }
}
