-- Coding: completion, snippets, treesitter, editing helpers.
-- yanky / dial / inc-rename come from extras; extend treesitter parsers here.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "bash",
                "lua",
                "markdown",
                "markdown_inline",
                "regex",
                "vim",
            })
        end,
    },
}
