if not (which carapace | is-empty) {
    const carapace_file = ($nu.default-config-dir | path join "carapace.nu")
    carapace _carapace nushell | save --force $carapace_file
    if ($carapace_file | path exists) {
        source $carapace_file
    }
}

$env._WAVETERM_SI_FIRSTPROMPT = true

def _waveterm_si_osc7 [] {
    let enc = ($env.PWD | url encode)
    print -n $"\e]7;file://localhost/($enc)\a"
}

$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt? | default [] | append {||
    if $env._WAVETERM_SI_FIRSTPROMPT {
        let v = (version).version
        print -n $"\e]16162;M;{\"shell\":\"nu\",\"shellversion\":\($v\),\"integration\":false}\a"
        $env._WAVETERM_SI_FIRSTPROMPT = false
    }
    _waveterm_si_osc7
})

alias sudo = ^pass show user | ^sudo -S


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