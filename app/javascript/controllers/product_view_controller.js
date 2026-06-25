import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "variantMax", "entireDiv",
    "stripeQuantity", "stripeVariantId", 
    // "addToCartQuantity", "addToCartVariantId",
    "price",
    // "addToWishListQuantity","addToWishListVariantId"
    "image", "dot", "imageCounter"
  ]

  connect() {
    this.currentImageIndex = 0
    this.showImage(0)
  }

  // ---- Image carousel ----

  openLightbox(event) {
    // Remove any existing lightbox first
    this.closeLightbox()

    const overlay = document.createElement('div')
    overlay.id = 'image-lightbox'
    overlay.addEventListener('click', () => this.closeLightbox())

    const img = document.createElement('img')
    img.src = event.currentTarget.src
    img.addEventListener('click', (e) => e.stopPropagation())

    // Close on Escape key
    this._escHandler = (e) => { if (e.key === 'Escape') this.closeLightbox() }
    document.addEventListener('keydown', this._escHandler)

    overlay.appendChild(img)
    document.body.appendChild(overlay)
    document.body.style.overflow = 'hidden'
  }

  closeLightbox() {
    const overlay = document.getElementById('image-lightbox')
    if (overlay) {
      overlay.classList.add('fade-out')
      setTimeout(() => {
        overlay.remove()
        document.body.style.overflow = ''
        document.removeEventListener('keydown', this._escHandler)
      }, 150)
    }
  }

  showImage(index) {
    if (!this.hasImageTarget) return

    this.imageTargets.forEach((img, i) => {
      img.hidden = (i !== index)
    })

    if (this.hasDotTarget) {
      this.dotTargets.forEach((dot, i) => {
        dot.classList.toggle("active", i === index)
      })
    }

    if (this.hasImageCounterTarget) {
      this.imageCounterTarget.textContent = `${index + 1} / ${this.imageTargets.length}`
    }

    this.currentImageIndex = index
  }

  nextImage() {
    const next = (this.currentImageIndex + 1) % this.imageTargets.length
    this.showImage(next)
  }

  prevImage() {
    const prev = (this.currentImageIndex - 1 + this.imageTargets.length) % this.imageTargets.length
    this.showImage(prev)
  }

  goToImage(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    this.showImage(index)
  }

  // ---- Variant / quantity ----

  update_form_values(event){
    this.entireDivTarget.hidden = false;

    const stock = event.target.dataset.stock;
    const variantId = event.target.dataset.variantId;
    this.price = event.target.dataset.price

    this.variantMaxTarget.value = 1;
    this.variantMaxTarget.max = stock;

    this.stripeVariantIdTarget.value = variantId;
    this.stripeQuantityTarget.value = 1;

    this.priceTarget.textContent = `${(1 * this.price) / 100} EUR`
  }

  increase(){
    const quantity = Number(this.variantMaxTarget.value) + 1;
    if(quantity > Number(this.variantMaxTarget.max)){
      return;
    }

    this.variantMaxTarget.value = quantity
    this.stripeQuantityTarget.value = quantity;
    this.priceTarget.textContent = `${(quantity * this.price) / 100} EUR`
  }

  decrease(){
    const quantity = Number(this.variantMaxTarget.value) - 1;
    if(quantity <= 0){
      return;
    }

    this.variantMaxTarget.value = quantity
    this.stripeQuantityTarget.value = quantity;
    this.priceTarget.textContent = `${(quantity * this.price) / 100} EUR`
  }
}
