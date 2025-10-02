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
