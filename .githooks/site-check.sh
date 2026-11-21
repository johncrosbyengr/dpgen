#!/bin/sh
# Lab fork guard: exit 1 if the given text file contains a string that identifies one of the lab's clusters.
# The strings are kept outside the repository, one per line (matched case-insensitively as whole words, # comments):
#   $DPGEN_LAB_PATTERNS, default ~/.config/dpgen-lab/forbidden-patterns
# Used by the pre-commit and commit-msg hooks.
pat=${DPGEN_LAB_PATTERNS:-$HOME/.config/dpgen-lab/forbidden-patterns}
if [ ! -s "$pat" ]; then
    echo "lab guard: no pattern file at $pat; create it before committing (one string per line)." >&2
    exit 1
fi
list=$(mktemp) || exit 1
trap 'rm -f "$list"' EXIT
sed -e '/^[[:space:]]*#/d' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$pat" > "$list"
[ -s "$list" ] || { echo "lab guard: $pat has no patterns." >&2; exit 1; }
hits=$(grep -n -i -w -F -f "$list" "$1")
if [ -n "$hits" ]; then
    echo "lab guard: text that identifies a lab cluster ($2):" >&2
    echo "$hits" >&2
    echo "Move it to an untracked config file. Use --no-verify only for a confirmed false positive." >&2
    exit 1
fi
exit 0
