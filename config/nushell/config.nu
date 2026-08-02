if not (which carapace | is-empty) {
    const carapace_file = $"($nu.default-config-dir)/carapace.nu"
    carapace _carapace nushell | save --force $carapace_file
    if ($carapace_file | path exists) {
        source $carapace_file
    }
}

$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = false
$env.config.completions.external.enable = false
$env.config.render_right_prompt_on_last_line = true
$env.config.table.mode = "rounded"
$env.config.table.trim = {methodology: "truncating" truncating_suffix: "..."}
$env.config.filesize.precision = 2

$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
$env.STARSHIP_CACHE = ($nu.default-config-dir | path join 'starship')
$env.STARSHIP_CONFIG = ($nu.default-config-dir | path join 'starship\starship.toml')
$env.PROMPT_INDICATOR = ""
$env.PROMPT_MULTILINE_INDICATOR = {|| starship prompt --continuation}
$env.PROMPT_COMMAND = {||
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
}
$env.PROMPT_COMMAND_RIGHT = {||
    starship prompt --right --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
}

const NU_PLUGIN_DIRS = [
    ($nu.current-exe | path dirname)
    ($nu.default-config-dir | path join 'plugins')
]