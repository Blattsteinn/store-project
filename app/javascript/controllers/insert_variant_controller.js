import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
  }
  static targets = ["template", "container"]

  add(){
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }
}
