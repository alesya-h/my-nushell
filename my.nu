def "config my" [] { ^$env.EDITOR ~/.config/nushell/my.nu }
def "config aliases" [] { ^$env.EDITOR ~/.config/nushell/aliases.nu }
def "config wezterm" [] { ^$env.EDITOR ~/.config/wezterm/wezterm.lua }
def "from edn" [] { $in | bb -I -o -e "(-> *input* json/generate-string)" | from json}

source ~/p/fork/nu_scripts/modules/network/sockets/sockets.nu
#ssh-agent -c | lines | first 2 | parse "setenv {name} {value};" | transpose -i -r -d | load-env
#ssh-add ~/.ssh/id_ed25519_cim o+e> /dev/null
source ~/.config/nushell/aliases.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/quitcd.nu

source ~/.config/nushell/oh-my-posh.nu
$env.POSH_THEME = $"($env.HOME)/.config/nushell/alesya.omp.yaml"
# source-if-exist "$HOME/p/fork/zsh-nix-shell/nix-shell.plugin.zsh"

# if [ -n "$NIX_SHELL_PACKAGES" ]; then
#   export PS1_NOTE="$PS1_NOTE > nix($NIX_SHELL_PACKAGES)"
# fi

$env.SHELL = 'nu'

def --env f [] {
    cd (^find -type d|sed 's|^./||'|grep -v -E '(^|/).git/'|fzf)
}

def "git last-updated" [] {
    ^git last-updated | into datetime
}

def mount [...args] {
  if $args == [] {
    ^mount
    | lines
    | parse -r '^(?P<what>\S+) on (?P<where>\S+) type (?P<type>\S+) \((?P<flags>[^)]+)\)$'
    | where what starts-with '/'
  } else {
    ^mount $args
  }
}

def df [--all(-a) --not-uniq ...args] {
  ^df -B 1 $args
  | detect columns
  | update Used {|x| $x.Used|into filesize}
  | update Available {|x| $x.Available | into filesize}
  | upsert Use {|x| ($x | get Use% | str replace '%' '' | into int) / 100 }
  | move Use --after Available
  | move Available --before Used
  | move Mounted --after Filesystem
  | reject '1B-blocks' Use% on
  | sort-by Filesystem
  | if ($all) { } else { where Filesystem starts-with / }
  | if ($not_uniq) { } else { uniq-by Filesystem }
}

def "up get" [url] {
  http get -H ["Authorization" $"Bearer (open ~/Documents/up-token.txt|str trim)"] $url
}

def "up account" [id] {
  up get $"https://api.up.com.au/api/v1/accounts/($id)"
}

def "up transactions" [account_id] {
  up get $"https://api.up.com.au/api/v1/accounts/($account_id)/transactions"
}

def "up accounts" [] {
  up get https://api.up.com.au/api/v1/accounts?page[size]=100 
  | get data
  | each {|it|
    let a = $it.attributes
    {
      name: $a.displayName
      balance: ($a.balance.value|into float)
      type: $a.accountType
      ownership: $a.ownershipType
      #created_at: $a.createdAt
      #created_at: ($a.createdAt|into datetime)
      id: $it.id
    }
  }
}

def "up balance" [] { up accounts |where type != SAVER|select name balance }
def "up savers" []  { up accounts |where type == SAVER|select name balance ownership }

def nix-add [file] {
  let f = ($file|path expand)
  nix-store --add-fixed sha256 $f
  nix hash file $f
}

def "date at" [when] {
    ^date $"--date=($when)" -Is|into datetime
}

source ~/.config/nushell/secret.nu
