function random_quote -d "Display a random quote from quotes.yml"
    set -l quotes_file "$HOME/.config/fish/data/quotes.yml"
    set -l categories (yq '.categories | keys | .[]' $quotes_file)
    set -l category $categories[(random 1 (count $categories))]
    set -l quote_count (yq ".categories.$category | length" $quotes_file)
    set -l quote_index (random 0 (math $quote_count - 1))
    set -l quote (yq ".categories[\"$category\"][$quote_index].quote" $quotes_file)
    set -l author (yq ".categories[\"$category\"][$quote_index].author" $quotes_file)

    echo -n "❝ "
    echo -n $quote
    echo " ❞"
    echo " — " $author
end
