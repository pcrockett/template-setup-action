#!/usr/bin/env nu

const BRANCH_NAME = "template-update"

# Shallow-clone all your `setup-*` GitHub repos, apply template updates, and open an PR
def main [] {
  let repos = (
    gh api '/search/repositories?q=user:@me+setup-+in:name&per_page=100'
    | from json
    | get items
  )
  let current_dir = pwd
  let temp_dir = mktemp --directory
  let cleanup = {
    cd $current_dir
    rm --force --recursive $temp_dir
  }

  try {
    cd $temp_dir
    (
      $repos
      | each { update-repo }
    )
  } catch {|err|
    do $cleanup
    error make $err
  }

  do $cleanup
}

def update-repo []: record<name: string, full_name: string> -> nothing {
  let repo = $in
  ^gh repo clone $repo.full_name -- --depth 1
  cd $repo.name
  if not (is-templated-repo) {
    $"($repo.name) doesn't come from this template. Skipping." | print
    return
  }
  ^just update-template
  if not (has-changes) {
    $"($repo.name) is already up-to-date. Skipping." | print
    return
  }
  ^git add .
  ^git sw -c $BRANCH_NAME
  ^git commit -m "update from template"
  ^git push --set-upstream origin $BRANCH_NAME
  (
    ^gh pr create
    --title "Update from template"
    --body ""
    --assignee @me
    --draft
  )
  ignore
}

def has-changes []: nothing -> bool {
  ^git status --porcelain | is-not-empty
}

def is-templated-repo []: nothing -> bool {
  try {
    (open .copier-answers.yml | get _src_path) == "gh:pcrockett/template-setup-action"
  } catch {
    false
  }
}
