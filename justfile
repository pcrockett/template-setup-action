[private]
_default:
    @just --list

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Update repos
update-repos msg="Update from template":
    ./update-repos.nu --commit-message {{msg}}
