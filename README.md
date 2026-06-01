# dbzstore

Still under development simple e-commerce web application built with **Ruby on Rails 8** for personal usage. Featuring  product listings, shopping carts, Stripe-powered checkout, order management and an admin dashboard.

## Features
- **Product catalogue** — Browse products with multiple images, variants (title, price, stock), and visibility controls (live/hidden), can checkout instantly or via cart
- **Shopping cart** — session based, can add items to it, adjust quantities, and 
- **Stripe integration**
- **User accounts** — Authentication via Devise
- **Wish list** — Save product variants for later, can add them to cart
- **Feedback & ratings** — Users can leave feedback and rating if the order has been completed 
- **FAQs** — Admin-managed frequently asked questions
- **Admin dashboard** — Manage products, orders, feedbacks, and FAQs from a central interface
## Stack

- **Ruby on Rails 8.1**
- **PostgreSQL**
- **Hotwire** (Turbo + Stimulus)

## Prerequisites

- Ruby 3.3.6
- PostgreSQL 9.3+
- Bundler (`gem install bundler`)

## Setup

```bash
bundle install
bin/rails db:prepare
bin/rails server
```
