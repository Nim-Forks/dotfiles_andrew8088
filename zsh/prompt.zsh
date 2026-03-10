autoload -Uz add-zsh-hook

_prompt_precmd() {
  local exit_code=$?

  local dir='%F{blue}%~%f'
  local git_info=""
  local git_info_plain=""

  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git branch --show-current 2>/dev/null)
    [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

    git_info=" %F{242}${branch}%f"
    git_info_plain=" ${branch}"

    local added=0 removed=0
    local line
    while IFS=$'\t' read -r a r _; do
      [[ "$a" == "-" ]] && continue
      (( added += a ))
      (( removed += r ))
    done < <(git diff HEAD --numstat 2>/dev/null)

    if (( added > 0 || removed > 0 )); then
      git_info+=" %F{green}+${added}%f, %F{red}-${removed}%f"
      git_info_plain+=" +${added}, -${removed}"
    fi
  fi

  local right_parts=()
  local num_jobs=${(%):-%j}
  if (( num_jobs > 0 )); then
    right_parts+=("⚙ ${num_jobs}")
  fi
  right_parts+=("$(date +%H:%M:%S)")
  local right_info="${(j: :)right_parts}"

  local left="${dir}${git_info}"
  local left_plain="${${(%):-%~}}${git_info_plain}"

  local char
  if (( exit_code == 0 )); then
    char='%F{magenta}❯%f'
  else
    char='%F{red}❯%f'
  fi

  local fill=""
  if [[ -n "$right_info" ]]; then
    local right_len=${#right_info}
    local padding=$(( COLUMNS - ${#left_plain} - right_len ))
    (( padding < 1 )) && padding=1
    fill="${(l:$padding:)}"
    right_info="%F{yellow}${right_info}%f"
  fi

  PROMPT="
%B${left}${fill}${right_info}
${char}%b "
}

add-zsh-hook precmd _prompt_precmd
