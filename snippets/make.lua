---@diagnostic disable: undefined-global

return {
    s(
        {
            trig = "hel",
            desc = "Simple help target for self-documented Makefile",
        },
        t({
            "help: ## Print help for targets with comments",
            "\t@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \\",
            '\t\tawk \'BEGIN {FS = ":.*?## "}; {printf "\\033[36m%-30s\\033[0m %s\\n", $$1, $$2}\'',
        })
    ),
    s(
        {
            trig = "help",
            desc = "Advanced help target for self-documented Makefile",
        },
        t({
            "help: ## Print help for targets with comments",
            "\t@cat $(MAKEFILE_LIST) | \\",
            "\t\tawk ' \\",
            "\t\t/^##/ || /^#  +/ { \\",
            '\t\t\tprintf "\\033[95m%s\\033[0m\\n", substr($$0, 0) \\',
            "\t\t}; \\",
            "\t\t/^#=/ { \\",
            '\t\t\tprintf "\\033[35m%s\\033[0m\\n", substr($$0, 0) \\',
            "\t\t}; \\",
            "\t\t/^[a-zA-Z_-]+:.*## .*$$/ { \\",
            "\t\t\tmatch($$0, /^[a-zA-Z_-]+/); \\",
            "\t\t\ttarget_name = substr($$0, RSTART, RLENGTH); \\",
            "\t\t\t\\",
            '\t\t\tcomment_start_pos = index($$0, "## "); \\',
            "\t\t\t\\",
            "\t\t\tif (comment_start_pos > 0) { \\",
            "\t\t\t\tdescription = substr($$0, comment_start_pos + 3); \\",
            '\t\t\t\tprintf "\\033[36m%-30s\\033[0m %s\\n", target_name, description \\',
            "\t\t\t} \\",
            "\t\t}'",
        })
    ),
    s(
        {
            trig = "rel",
            desc = "Print commit messages since the last tag for release notes",
        },
        t({
            "release: ## Print commit messages since last tag",
            '\t@LAST_TAG="$$(git describe --tags --abbrev=0 2>/dev/null || true)"; \\',
            '\tif [ -n "$$LAST_TAG" ]; then \\',
            '\t\techo "Commits since $$LAST_TAG:"; \\',
            '\t\tCOMMITS="$$(git log "$$LAST_TAG"..HEAD --pretty=format:\'- %s\')"; \\',
            '\t\tif [ -n "$$COMMITS" ]; then \\',
            '\t\t\techo "$$COMMITS"; \\',
            "\t\telse \\",
            '\t\t\techo "No commits since last release."; \\',
            "\t\tfi; \\",
            "\telse \\",
            '\t\techo "No previous tag found; showing all commit messages:"; \\',
            "\t\tgit log HEAD --pretty=format:'- %s'; \\",
            "\tfi",
        })
    ),
}
