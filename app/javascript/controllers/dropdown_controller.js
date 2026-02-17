import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  // クリックで開閉
  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  // 画面のどこかをクリックしたら閉じる
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
