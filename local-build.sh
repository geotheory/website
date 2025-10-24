#!/usr/bin/env bash
set -euo pipefail

rm -rf content
git clone https://github.com/geotheory/website.wiki.git content

# Iterate over all .md files in content/ recursively
find content/ -type f -name "*.md" | while read -r file; do
    # Skip files that already have front matter
    if ! head -n 1 "$file" | grep -qE '^\+\+\+|^---'; then
        # Derive title from filename (strip path and extension)
        filename=$(basename "$file" .md)
        title=$filename #"${filename//_/ }"  # replace underscores with spaces if desired

        # Prepend TOML front matter
        tmp=$(mktemp)
        {
            echo "+++"
            echo "title = \"$title\""
            echo "+++"
            echo ""
            cat "$file"
        } > "$tmp"
        mv "$tmp" "$file"
    fi
done

# # 5. Build the site
echo "Building site..."
zola build

# # 6. Check output
# if [ -d public ]; then
#     echo "Zola build successful. Output in ./public"
# else
#     echo "Zola build failed."
#     exit 1
# fi
