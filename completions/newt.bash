#!/usr/bin/env bash

_newt_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-b -d -l -h --help -v --version"

    # Get repo root
    local repo_root
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || return 0

    # If previous word is -d, complete with worktrees
    if [[ "$prev" == "-d" ]]; then
        local worktree_base="${repo_root}/.newt"
        if [[ -d "$worktree_base" ]]; then
            local worktrees
            worktrees=$(cd "$worktree_base" && compgen -d -- "$cur")
            mapfile -t COMPREPLY < <(compgen -W "$worktrees" -- "$cur")
        fi
        return 0
    fi

    # If current word starts with -, complete with options
    if [[ "$cur" == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
        return 0
    fi

    # Check if -b, -d, or -l has already been used
    local has_flag=false
    for word in "${COMP_WORDS[@]:1:$((COMP_CWORD-1))}"; do
        if [[ "$word" =~ ^-(b|d|l)$ ]]; then
            has_flag=true
            break
        fi
    done

    # If no flag yet, complete with branches or flags
    if ! $has_flag; then
        local branches
        branches=$(git -C "$repo_root" for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null)
        mapfile -t COMPREPLY < <(compgen -W "$opts $branches" -- "$cur")
        return 0
    fi

    # If -b was used, complete with branch names (for new branch creation)
    if [[ "${COMP_WORDS[*]}" =~ -b ]]; then
        # Don't complete anything for new branch names
        return 0
    fi

    return 0
}

complete -F _newt_completions newt
