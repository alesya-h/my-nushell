# Nushell Environment Config File
#
# version = 0.78.0

def git-staged [] {
  let code = (git diff-index --cached --quiet --ignore-submodules=dirty HEAD | complete).exit_code
  if ($code != 128 and $code != 0) { $"(ansi blue_bold)+(ansi reset)" }
}

def git-unstaged [] {
  let code = (git diff --no-ext-diff --ignore-submodules=dirty --quiet --exit-code|complete).exit_code
  if $code != 0 { $"(ansi blue_bold)!(ansi reset)" }
}

def git-data [] { $"(git rev-parse --abbrev-ref HEAD)(git-staged)(git-unstaged)" }

def git-info [] {
  if (do {git rev-parse --is-inside-work-tree|complete}).exit_code == 0 {
    $"(ansi cyan)[(ansi reset) (git-data) (ansi cyan)](ansi reset)"
  } else { "" }
}

def create_left_prompt [] {
    let home = $env.HOME
    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace -s $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_segment = if (is-admin) {
        $"(ansi red_bold)($dir)"
    } else {
        $"(ansi green_bold)($dir)"
    }

    $"($path_segment)(git-info)"
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%d/%m/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = {|| create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = {|| "> " }
let-env PROMPT_INDICATOR_VI_INSERT = {|| ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
let-env PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH, you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

source ~/.config/nushell/my.nu
