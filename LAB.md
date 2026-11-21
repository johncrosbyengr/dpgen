# Lab fork of DP-GEN

This is a fork of [deepmodeling/dpgen](https://github.com/deepmodeling/dpgen), maintained by John Crosby
(GitHub: johncrosbyengr). It is upstream DP-GEN with one area changed: job dispatching. The goal is to let one stage
(for example the first-principles labelling) spread its tasks over several clusters of different kinds, CPU and GPU,
instead of one machine per stage. That work has not started yet; for now the code is upstream v0.14.0.

## Branches

- `master` mirrors upstream. Never commit to it.
- `lab` holds the lab's changes and is the default branch.

To bring in upstream changes:

```bash
git fetch upstream
git switch master && git merge --ff-only upstream/master && git push origin master
git switch lab && git merge master
```

## No cluster details in tracked files

Nothing that identifies a real cluster may be committed: hostnames, domains, IP addresses, user names, scheduler
accounts or partitions, node names, or paths on a cluster. Those belong in machine configuration files kept outside
the repository, or in untracked files (`.gitignore` covers `machine*.json`, `*.local.json` and `lab-config/`).
Examples, tests and docs use placeholders such as `cluster-a`, `user` and `/path/to/work`.

Two git hooks in `.githooks/` enforce this. They refuse a commit whose added lines, file names or message contain any
string from a list kept outside the repository, at `~/.config/dpgen-lab/forbidden-patterns` (or the file named by
`$DPGEN_LAB_PATTERNS`): one string per line, matched case-insensitively as a whole word, `#` for comments. Without
that file, every commit is refused.

One-time setup in each clone you commit from:

```bash
git config core.hooksPath .githooks
```

Then create the pattern file with your own clusters' details. Use `git commit --no-verify` only for a confirmed false
positive.

## Installing on a cluster

No credentials are needed; the repository is public.

```bash
pip install "git+https://github.com/johncrosbyengr/dpgen@lab"
```

DP-GEN only has to be installed where it is launched. The clusters it sends jobs to need only the simulation codes.
