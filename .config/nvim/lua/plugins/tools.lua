-- Tools: formatters, linters and other CLIs installed through mason.
return {
    {
        "mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shfmt",
                "shellcheck",
            },
        },
    },
}
