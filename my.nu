def "config my" [] { ^$env.EDITOR ~/.config/nushell/my.nu }
def "config aliases" [] { ^$env.EDITOR ~/.config/nushell/aliases.nu }
def "from edn" [] { $in | bb -I -o -e "(-> *input* json/generate-string)" | from json}

source ~/p/fork/nu_scripts/modules/network/sockets/sockets.nu

source ~/.config/nushell/aliases.nu
source ~/.config/nushell/zoxide.nu

source ~/.config/nushell/oh-my-posh.nu
# let-env POSH_THEME = '~/p/fork/oh-my-posh/themes/M365Princess.omp.json'
let-env POSH_THEME = "~/p/fork/oh-my-posh/themes/iterm2.omp.json"

def mount [...args] {
  if $args == [] {
    ^mount|lines|parse -r '^(?P<what>\S+) on (?P<where>\S+) type (?P<type>\S+) \((?P<flags>[^)]+)\)$'
  } else {
    ^mount $args
  }
}
