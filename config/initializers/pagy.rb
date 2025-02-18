# Optionally override some pagy default with your own in the pagy initializer
Pagy::DEFAULT[:limit] = 10 # items per page
Pagy::DEFAULT[:size]  = 7 # Navbar links

# Allow easy handling of overflowing pages (i.e. requested page > count).
# https://ddnexus.github.io/pagy/docs/extras/overflow/
# default :empty_page (other options :last_page and :exception )
require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page
