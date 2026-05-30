-- Python overrides on top of the lazyvim.plugins.extras.lang.python extra.
return {
    {
        "linux-cultist/venv-selector.nvim",
        opts = function(_, opts)
            opts = opts or {}
            opts.options = opts.options or {}

            -- Debian/Ubuntu package is `fd-find` (binary: fdfind).
            if vim.fn.executable("fdfind") == 1 then
                opts.options.fd_binary_name = "fdfind"
            elseif vim.fn.executable("fd") == 1 then
                opts.options.fd_binary_name = "fd"
            end

            opts.options.notify_user_on_venv_activation = true

            return opts
        end,
        init = function()
            -- Auto-activate project .venv when opening Python (venv-selector only restores cached venvs).
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("lazyvim_python_venv", { clear = true }),
                pattern = "python",
                callback = function(args)
                    local buf = args.buf
                    vim.defer_fn(function()
                        if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "python" then
                            return
                        end
                        if vim.b[buf].venv_selector_disabled then
                            return
                        end

                        local root = LazyVim.root({ buf = buf })
                        if not root then
                            return
                        end

                        local venv_python = root .. "/.venv/bin/python"
                        if vim.fn.executable(venv_python) ~= 1 then
                            return
                        end

                        local venv = require("venv-selector.venv")
                        local pr = require("venv-selector.project_root").key_for_buf(buf)
                        if pr and venv.active_project_root and venv.active_project_root() == pr then
                            return
                        end

                        venv.activate_for_buffer(venv_python, "venv", buf, { save_cache = true })
                    end, 500)
                end,
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                diagnosticSeverityOverrides = {
                                    reportMissingImports = "warning",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
