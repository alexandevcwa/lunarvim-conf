-- =============================================================================
-- CONFIGURACIÓN LUNARVIM - DESARROLLO WEB Y ANGULAR
-- Archivo: ~/.config/lvim/config.lua
-- =============================================================================

-- ---------------------------------------------------------------------------
-- GENERAL
-- ---------------------------------------------------------------------------

-- Tema de color principal
lvim.colorscheme = "duskfox"

-- Formateo automático al guardar
lvim.format_on_save = true

-- ---------------------------------------------------------------------------
-- SERVIDORES LSP
-- ---------------------------------------------------------------------------

-- Angular Language Server
require("lvim.lsp.manager").setup("angularls")
-- Nota: Requiere instalación global: npm install -g @angular/language-server

-- TailwindCSS LSP (opcional, descomentarlo si quieres activarlo por proyecto)
-- require("lspconfig").tailwindcss.setup({
--   filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
-- })

-- ---------------------------------------------------------------------------
-- FORMATTERS / LINTING
-- ---------------------------------------------------------------------------

local formatters = require("lvim.lsp.null-ls.formatters")

-- Prettier para proyectos web
formatters.setup({
  {
    command = "prettier",
    extra_args = { "--tab-width", "2", "--use-tabs", "false" },
    filetypes = { "html", "css", "scss", "javascript", "typescript", "json" },
  },
})

-- SQL Formatter (alternativa si no se usa SQLFluff)
formatters.setup({
  {
    exe = "sql_formatter",
    args = { "--language", "plsql" },
    extra_args = { "--tab-width", "4", "--use-tabs", "false" },
    filetypes = { "sql" },
  },
})

formatters.setup({
  {
    exe = "sqlfluff",
    args = { "fix", "--dialect", "oracle" },
    filetypes = { "sql" },
  },
})

-- ---------------------------------------------------------------------------
-- CONFIGURACIONES ESPECÍFICAS DE ARCHIVOS
-- ---------------------------------------------------------------------------

-- HTML
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Jenkinsfile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufReadPost" }, {
  pattern = { "Jenkinsfile*", "*.jenkinsfile" },
  callback = function()
    vim.bo.filetype = "jenkinsfile"
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.o.filetype = "groovy"
  end,
})

-- ---------------------------------------------------------------------------
-- PLUGINS ADICIONALES
-- ---------------------------------------------------------------------------

lvim.plugins = {
  -- Syntax y lenguajes
  { "martinda/Jenkinsfile-vim-syntax" },
  { "nvim-treesitter/nvim-treesitter-angular" },

  -- Temas
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim",                        name = "catppuccin" },
  { "ellisonleao/gruvbox.nvim" },
  { "navarasu/onedark.nvim" },
  { "sainnhe/everforest" },
  { "shaunsingh/nord.nvim" },
  { "Mofiqul/dracula.nvim" },
  { "EdenEast/nightfox.nvim" }, -- duskfox incluido
  { "rose-pine/neovim",                       name = "rose-pine" },
  { "shaunsingh/solarized.nvim" },

  -- Desarrollo
  { "windwp/nvim-ts-autotag" }, -- Auto-cierre de tags HTML/JSX
  { "psf/black" },              -- Formateo Python
  { "zbirenbaum/copilot.lua" }, -- GitHub Copilot

  -- Git
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },
}

lvim.builtin.mason.ensure_installed = {
  -- ====================
  -- LINTERS / FORMATTERS
  -- ====================
  -- Python
  "black",  -- Formateador de código Python
  "pylint", -- Linter de Python

  -- Bash / Shell
  "beautysh",             -- Formateador de scripts shell
  "bash-debug-adapter",   -- Debugger para scripts Bash
  "bash-language-server", -- Linter y completado para Bash

  -- JavaScript / TypeScript / Frontend
  "eslint_d",                   -- Linter rápido JS/TS
  "prettier",                   -- Formateador JS/TS/HTML/CSS/JSON
  "typescript-language-server", -- Servidor de lenguaje TypeScript
  "js-debug-adapter",           -- Debugger para Node.js

  -- CSS / HTML / Frontend
  "css-lsp",                     -- Servidor de lenguaje CSS
  "html-lsp",                    -- Servidor de lenguaje HTML
  "tailwindcss-language-server", -- Servidor de lenguaje TailwindCSS

  -- JSON / YAML / XML
  "json-lsp",             -- Servidor de lenguaje JSON
  "fixjson",              -- Formateador JSON
  "yaml-language-server", -- Servidor de lenguaje YAML
  "yamllint",             -- Linter YAML
  "lemminx",              -- Servidor de lenguaje XML

  -- Markdown / Documentation
  "markdown-oxide", -- Procesador rápido de Markdown
  "doctoc",         -- Generador de tablas de contenido Markdown

  -- Docker / CI
  "dockerfile-language-server",      -- Servidor de lenguaje Dockerfile
  "docker-compose-language-service", -- Servidor para docker-compose
  "gh-actions-language-server",      -- Servidor para GitHub Actions YAML
  "actionlint",                      -- Linter GitHub Actions YAML

  -- Groovy / Java
  "groovy-language-server", -- Servidor de lenguaje Groovy
  "npm-groovy-lint",        -- Linter Groovy vía npm

  -- Angular / Frameworks
  "angular-language-server", -- Servidor Angular
  "postgrestools",           -- Herramientas PostgREST / Postgres

  -- SQL
  "sql-formatter", -- Formateador SQL
}


-- Configuración de plugins
require("nvim-ts-autotag").setup()
-- Copilot se puede activar en esta sección
-- lvim.builtin.copilot.active = true
-- require("copilot").setup({ suggestion = { enabled = false }, panel = { enabled = false } })

-- =============================================================================
-- DEPENDENCIAS EXTERNAS
-- =============================================================================
-- Node.js/npm:
--   - Prettier: npm install -g prettier
--   - AngularLS: npm install -g @angular/language-server
-- Python:
--   - Black: pip install black
-- Git: necesario para plugins de control de versiones
