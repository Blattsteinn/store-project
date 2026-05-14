require 'redcarpet'

module ProductsHelper
    def convert_from_cents(cents)
        cents = cents * 1.0 / 100
    end

    def markdown(text)
        renderer = Redcarpet::Render::HTML.new(hard_wrap: true, link_attributes: { target: "_blank" })
        Redcarpet::Markdown.new(renderer, autolink: true, tables: true).render(text)
    end

end
