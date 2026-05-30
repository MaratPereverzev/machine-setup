-- LSP: server overrides.
-- Language servers for enabled extras are configured automatically.
-- Add or tweak servers here; they are installed via mason and started by lspconfig.
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- lua_ls = {
                --     settings = {
                --         Lua = { hint = { enable = true } },
                --     },
                -- },
            },
        },
    },
}
