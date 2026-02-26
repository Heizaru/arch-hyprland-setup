if status is-interactive
    starship init fish | source
    mise activate fish | source
    zoxide init fish | source

    set -U fish_color_normal c0caf5
    set -U fish_color_command 7aa2f7
    set -U fish_color_quote e0af68
    set -U fish_color_redirection 7dcfff
    set -U fish_color_end 9ece6a
    set -U fish_color_error f7768e
    set -U fish_color_param bb9af7
    set -U fish_color_comment 565f89
    set -U fish_color_match 7aa2f7
    set -U fish_color_selection --background=24283b
    set -U fish_color_search_match --background=24283b
    set -U fish_color_operator 7dcfff
    set -U fish_color_escape 73daca
    set -U fish_color_cwd 9ece6a
    set -U fish_color_autosuggestion 565f89
    set -U fish_color_user 9ece6a
    set -U fish_color_host 7aa2f7
    set -U fish_color_host_remote 7aa2f7
    set -U fish_color_status f7768e
    set -U fish_color_valid_path --underline

    abbr ls lsd
    abbr ll lsd -la
    abbr la lsd -a
    abbr lt lsd --tree
    abbr vim nvim
    abbr g git
    abbr cd z
    abbr hconf nvim ~/.config/hypr/hyprland.conf
    abbr hreload hyprctl reload
    abbr ca cargo
    abbr rake bundle exec rake
    abbr r rails
    abbr be bundle exec
    abbr rubocop bundle exec rubocop -a

    set -x EDITOR nvim
    set -x VISUAL nvim
    set -x PAGER nvim

    set -x BAT_THEME tokyonight
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache
end
