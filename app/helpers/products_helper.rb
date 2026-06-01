require 'redcarpet'

module ProductsHelper
    def convert_from_cents(cents)
        cents = cents * 1.0 / 100
    end

    def markdown(text)
        renderer = Redcarpet::Render::HTML.new(
            hard_wrap: true,
            filter_html: true,
            link_attributes: { target: "_blank", rel: "noopener noreferrer" }
        )

        markdown = Redcarpet::Markdown.new(
            renderer,
            autolink: true,
            tables: true
        )

        sanitize(markdown.render(text))
    end

end
