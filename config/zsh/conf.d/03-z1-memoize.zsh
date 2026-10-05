# ------------------------------------------------------------------------------
# region: z1_memoize: Cache command output for fast shell startup
# ------------------------------------------------------------------------------

# __memoize_cmd: Evaluate a command, cache its output, and use its cache for 20 hours.
# Only successful, non-empty output is cached; a failed run leaves any previous
# cache in place (even if stale) and an empty cache file is never treated as valid.
function __memoize_cmd {
  emulate -L zsh; setopt local_options $__z1_opts
  local memofile=$__zsh_cache_dir/memoized/$1; shift
  local -a cached=($memofile(N.L+0mh-20))
  if ! (( $#cached )); then
    local tmpfile=$memofile.$$.tmp
    mkdir -p ${memofile:h}
    if "$@" >| $tmpfile && [[ -s $tmpfile ]]; then
      mv -f $tmpfile $memofile
    else
      rm -f $tmpfile
    fi
  fi
  if [[ -s $memofile ]]; then source $memofile; fi
}

# endregion --------------------------------------------------------------------

# vim: ft=zsh
