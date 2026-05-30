-- Central plugin manifest (imported from config/lazy.lua as `plugins.init` only).
-- To add a module: create lua/plugins/<name>.lua and register it below.
return {
    { import = "plugins.colorscheme" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.coding" },
    { import = "plugins.lsp" },
    { import = "plugins.tools" },

    -- Per-language overrides (languages themselves are enabled via :LazyExtras).
    { import = "plugins.lang.python" },
}
