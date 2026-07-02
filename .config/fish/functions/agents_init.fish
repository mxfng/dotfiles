function agents_init --argument-names dir
    test -z "$dir"; and set dir (pwd)

    log "initializing project AGENTS.md"

    if not test -d "$dir"
        echo "agents_init: no such directory: $dir" >&2
        return 1
    end

    set -l agents "$dir/AGENTS.md"
    set -l claude "$dir/CLAUDE.md"

    if test -e "$agents"
        echo "AGENTS.md already exists, leaving it untouched"
    else
        printf '%s\n' \
            "# $(basename $dir)" \
            "" \
            "Instructions for coding agents working in this repository." \
            "" \
            "## What this is" \
            "" \
            "_What the project is, who it's for, and the problem it solves._" \
            "" \
            "## Repository layout" \
            "" \
            "_The top-level directories and what lives in each._" \
            "" \
            '```' \
            "_annotated list of the key paths_" \
            '```' \
            "" \
            "## Terminology" \
            "" \
            "_Domain terms and internal names an agent needs to read the code._" \
            "" \
            "- **Term** - definition." \
            "" \
            "## How it works" \
            "" \
            "_The most important components and how they fit together._" \
            "" \
            "### Component" \
            "" \
            "_What it does, where it lives, and how it connects to the rest._" \
            "" \
            "## End-to-end testing" \
            "" \
            "_How to exercise the project the way a real user would, from setup to teardown._" \
            "" \
            "## Conventions" \
            "" \
            "_Code style, naming, commit, and workflow rules to follow._" >"$agents"
        echo "created $agents"
    end

    if test -L "$claude"; and test (readlink "$claude") = AGENTS.md
        echo "CLAUDE.md already links to AGENTS.md"
    else if test -e "$claude"; or test -L "$claude"
        echo "agents_init: CLAUDE.md already exists and is not a link to AGENTS.md, leaving it untouched" >&2
        return 1
    else
        ln -s AGENTS.md "$claude"
        echo "linked CLAUDE.md -> AGENTS.md"
    end
end
