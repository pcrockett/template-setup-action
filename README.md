# setup-action template repository

this is a [copier](https://copier.readthedocs.io/en/stable/) template repository to
generate robust _setup-XXX_ github action repositories.

it generates a github action that downloads a tool, verifies its checksum, and makes
it available on `$PATH`. it also includes a dependabot configuration, linting with
pre-commit, etc.

to use:

```bash
# replace "SOMETOOL" with the tool of your choice
git init setup-SOMETOOL
copier copy <TODO: this repo URL> setup-SOMETOOL
```
