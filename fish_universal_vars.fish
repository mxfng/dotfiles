set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -U fish_color_normal $foreground
set -U fish_color_command $purple
set -U fish_color_keyword $pink
set -U fish_color_quote $yellow
set -U fish_color_redirection $green
set -U fish_color_end $orange
set -U fish_color_error $red
set -U fish_color_param $foreground
set -U fish_color_comment $comment
set -U fish_color_selection --background=$selection
set -U fish_color_search_match --background=$selection
set -U fish_color_operator $cyan
set -U fish_color_escape $pink
set -U fish_color_autosuggestion $comment

# Completion Pager Colors
set -U fish_pager_color_progress $comment
set -U fish_pager_color_prefix $purple
set -U fish_pager_color_completion $foreground
set -U fish_pager_color_description $comment
