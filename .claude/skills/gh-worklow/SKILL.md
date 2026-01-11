---
name: Github Workflow Debugger
allowed-tools: "Read,Bash(gh:*)"
description: How to fetch logs from Github's CI/CD with the gh cli
---

Github worklows found in `.github/workflows/` define critical CI/CD steps to
build / test / deploy the project and they should not fail.

Engineers typically share URLs like: https://github.com/$REPO/actions/runs/$RUN_ID/job/$JOB_ID, to view this log:

  gh run view -R $REPO --job $JOB_ID --log

Since the repository might be private, the best way to view Github managed
workflows is via the Github cli, which should be pre-installed and available as
`gh`.

** Step 1: List latest runs

A run should start from the moment a new commit is pushed, but in practice it
can take several seconds and again you need to wait until a workflow is run to
get a complete picture (often minutes!).

    GH_PAGER=cat gh run ls

Doc: `gh run ls --help`

To know when the workflow is done:

    gh run watch $RUN_ID --exit-status

** Step 2: Verify latest commit corresponds to the latest run

    gh run view $RUN_ID --json headSha -q '.headSha[:7]'

Should be the same as

    git describe --always

Else warn the user hasn't pushed the current change?

** Step 3: Debug errors

To zoom into failed runs:

    gh run view $RUN_ID --log-failed

Doc: `gh run view --help`

** Step 4: Plan and fix the issue

AskUserQuestionTool for any clarifications and whether to `git push` to kick off another workflow iteration.

# Workflow syntax errors

Use `actionlint` to debug broken workflows.
