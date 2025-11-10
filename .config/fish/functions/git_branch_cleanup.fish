function git_branch_cleanup
    # Get all branches except the current one
    set branches (git branch | string replace -r '^\*?\s*' '')

    # Use fish's built-in selection functionality
    set selected_branches (printf "%s\n" $branches | fzf -m)

    # Check if any branches were selected
    if test -n "$selected_branches"
        # Confirm deletion
        echo "You're about to delete these branches:"
        printf "%s\n" $selected_branches

        read -l -P "Are you sure? (y/N) " confirm

        if test "$confirm" = y -o "$confirm" = Y
            for branch in $selected_branches
                echo "Deleting $branch..."
                git branch -D $branch
            end
            echo "Branch cleanup complete!"
        else
            echo "Operation cancelled."
        end
    else
        echo "No branches selected."
    end
end
