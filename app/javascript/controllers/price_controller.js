import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.update_price();
    
    // nice
    this.observer = new MutationObserver(() => this.update_price())
    this.observer.observe(
    this.element.querySelector("#cart-items-container"),
    { childList: true, subtree: true }
  )
  }

  disconnect() {
    this.observer?.disconnect()
  }

  static targets = ["price"]

  update_price(){
    const prices = this.element.querySelectorAll(".cart-product-price");
    const quantities = this.element.querySelectorAll(".cart-quantity");
    
    let total = 0;
    for(let i = 0; i < prices.length; i++){
      total += parseFloat(prices[i].textContent) * parseInt(quantities[i].textContent)
    }

    console.log(total)
    this.priceTarget.innerHTML = total

  }
}
