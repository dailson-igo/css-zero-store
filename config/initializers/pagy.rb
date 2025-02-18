# Optionally override some pagy default with your own in the pagy initializer
Pagy::DEFAULT[:limit] = 10 # items per page
Pagy::DEFAULT[:size]  = 7 # Navbar links

# Allow easy handling of overflowing pages (i.e. requested page > count).
# https://ddnexus.github.io/pagy/docs/extras/overflow/
# default :empty_page (other options :last_page and :exception )
require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page

# Customiza a geração das séries para não incluir o :gap à esquerda e a última página
# https://www.beflagrant.com/blog/a-pagination-story-2024-07-15
class Pagy
  def custom_series(size: @vars[:size], **_)
    half_size = (size / 2)

    # assume the current page will be in the middle and go half down, but not below 1
    left = [ @page - half_size, 1 ].max
    # now go fully up from there, but not above the last page
    right = [ left + size, @last ].min
    # and now readjust the first number if the last had to be capped
    left = [ [ left, right - size ].min, 1 ].max

    result = [
      (left...@page).to_a,
      @page.to_s,
      ((@page + 1)..right).to_a
    ].flatten

    if right != @pages
      result[-1] = :gap
    end

    result
  end

  # Sobrescreve o método series padrão para usar o custom_series
  # alias_method :series, :custom_series
end
