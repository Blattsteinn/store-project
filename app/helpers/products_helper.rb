module ProductsHelper
    def convert_from_cents(cents)
        cents = cents * 1.0 / 100
    end

end
