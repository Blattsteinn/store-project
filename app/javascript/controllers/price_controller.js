import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
    this.update_price()
  }
  static targets = ["price"]

  update_price(){
    const prices = this.element.querySelectorAll(".cart-product-price");
    const quantities = this.element.querySelectorAll(".cart-quantity")
    
    let total = 0;
    for(let i = 0; i < prices.length; i++){
      console.log(prices[i])
      console.log(quantities[i])
      total += parseFloat(prices[i].textContent) * parseInt(quantities[i].textContent)
    }

    this.priceTarget.innerHTML = total
  }
}
