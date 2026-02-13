return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "bashls",
                "cssls",
                "eslint",
                "html",
                "lua_ls",
                "ts_ls",
                "ast_grep",
                "pyright",
                "pylsp",
                "tailwindcss",
            },
            auto_install = true,
        },
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local caps = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("bashls", { capabilities = caps })
            vim.lsp.config("cssls", { capabilities = caps })
            vim.lsp.config("eslint", { capabilities = caps })
            vim.lsp.config("html", { capabilities = caps })
            vim.lsp.config("lua_ls", { capabilities = caps })
            vim.lsp.config("ts_ls", { capabilities = caps })
            vim.lsp.config("ast_grep", { capabilities = caps })
            vim.lsp.config("pyright", { capabilities = caps })
            vim.lsp.config("pylsp", { capabilities = caps })
            vim.lsp.config("tailwindcss", { capabilities = caps })

            vim.lsp.enable({
                "bashls",
                "cssls",
                "eslint",
                "html",
                "lua_ls",
                "ts_ls",
                "ast_grep",
                "pyright",
                "pylsp",
                "tailwindcss",
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
        end,
    },
}

