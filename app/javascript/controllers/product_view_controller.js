import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const price = 0;
  }

  disconnect() {
  }

  static targets = [ "variantMax", "entireDiv",
    "stripeQuantity", "stripeVariantId", 
    "addToCartQuantity", "addToCartVariantId",
    "price"
  ]

  update_form_values(event){
    this.entireDivTarget.hidden = false;


    const stock = event.target.dataset.stock;
    const variantId = event.target.dataset.variantId;
    this.price = event.target.dataset.price

    this.variantMaxTarget.value = 1;
    this.variantMaxTarget.max = stock;

    this.addToCartVariantIdTarget.value = variantId;
    this.addToCartQuantityTarget.value = 1;

    this.stripeVariantIdTarget.value = variantId;
    this.stripeQuantityTarget.value = 1;

    this.priceTarget.textContent = (1 * this.price)/100
  }

  // update_quantity(event){
  //   const quantity = event.target.value;
  //   console.log("fejisdg")
  //   this.addToCartQuantityTarget.value = quantity;
  //   this.stripeQuantityTarget.value = quantity;

  //   this.priceTarget.textContent = (quantity * this.price)/100
  // }

  increase(){
    const quantity = Number(this.variantMaxTarget.value) + 1;
    if(quantity > Number(this.variantMaxTarget.max)){
      return;
    }

    this.variantMaxTarget.value = quantity
    this.addToCartQuantityTarget.value = quantity;
    this.stripeQuantityTarget.value = quantity;

    this.priceTarget.textContent = (quantity * this.price)/100
  }

  decrease(){
    const quantity = Number(this.variantMaxTarget.value) - 1;
    if(quantity <= 0){
      return;
    }

    this.variantMaxTarget.value = quantity
    this.addToCartQuantityTarget.value = quantity;
    this.stripeQuantityTarget.value = quantity;

    this.priceTarget.textContent = (quantity * this.price)/100
  }
}
