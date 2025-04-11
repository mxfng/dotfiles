function quote -d "Display a random quote from wisdom.yml"
    set -l script_dir (dirname (status filename))
    set -l quote_file "$script_dir/quote.yml"

    set -l categories (yq '.categories | keys | .[]' $quote_file)
    set -l category $categories[(random 1 (count $categories))]

    set -l quote_count (yq ".categories.$category | length" $quote_file)
    set -l quote_index (random 0 (math $quote_count - 1))

    set -l quote (yq ".categories[\"$category\"][$quote_index].quote" $quote_file)
    set -l author (yq ".categories[\"$category\"][$quote_index].author" $quote_file)

    echo -n "❝ "
    echo -n $quote
    echo " ❞"
    echo " — " $author
end
