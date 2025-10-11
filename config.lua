-- ============================================================================
-- CONFIGURACIÓN DE LUNARVIM
-- ============================================================================

-- CONFIGURACIÓN GENERAL ------------------------------------------------------
lvim.format_on_save = true
lvim.colorscheme = "nordfox"

-- Configuración del cursor: bloque en modo normal, línea vertical en inserción
vim.cmd([[
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  set guicursor+=a:blinkwait700-blinkoff400-blinkon250
]])

-- TREESITTER -----------------------------------------------------------------
-- Resaltado de sintaxis y análisis de código
lvim.builtin.treesitter.ensure_installed = {
  "python",
  "typescript",
  "javascript",
  "lua",
  "yaml",
  "sql",
  "html",
  "css",
  "json",
  "markdown",
}
lvim.builtin.treesitter.auto_install = true

-- HERRAMIENTAS MASON ---------------------------------------------------------
-- Servidores LSP, linters, formateadores y depuradores para instalar automáticamente
lvim.lsp.automatic_servers_installation = false

local mason_tools = {
  -- Python
  "pyright", -- LSP con análisis de tipos
  "ruff",    -- Linter y formateador rápido

  -- JavaScript/TypeScript
  "eslint_d",                   -- Linter rápido (daemon)
  "prettier",                   -- Formateador universal para web
  "typescript-language-server", -- LSP para TypeScript/JavaScript
  "js-debug-adapter",           -- Depurador para Node.js

  -- CSS/HTML
  "css-lsp",
  "html-lsp",
  "tailwindcss-language-server",

  -- Archivos de configuración
  "json-lsp",
  "yaml-language-server",
  "yamllint",
  "lemminx", -- LSP para XML

  -- Documentación
  "markdown-oxide",

  -- DevOps
  "dockerfile-language-server",
  "docker-compose-language-service",

  -- Frameworks
  "angular-language-server",

  -- SQL
  "sql-formatter",

  -- Corrección ortográfica
  "cspell",
}

-- PLUGINS --------------------------------------------------------------------
lvim.plugins = {
  -- Instalación automática de herramientas Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = mason_tools,
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
      })
    end
  },
  -- Experiencia de usuario
  {
    "sphamba/smear-cursor.nvim",
    config = function()
      require("smear_cursor").setup({
        -- cursor_color = "#d3cdc3",
        cursor_color = "#ebdbb2",
        -- normal_bg = "#282828",
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        scroll_buffer_space = true,
        legacy_computing_symbols_support = false,
        disable_filetypes = { "TelescopePrompt", "alpha", "NvimTree" },
      })
    end,

  },
  -- Soporte de lenguajes
  { "nvim-treesitter/nvim-treesitter-angular" },
  { "windwp/nvim-ts-autotag" }, -- Cierre automático de etiquetas HTML/XML

  -- Temas de colores
  { "shaunsingh/nord.nvim" },
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },

  -- Integración con Git
  { "lewis6991/gitsigns.nvim" }, -- Indicadores Git en la columna
  { "tpope/vim-fugitive" },      -- Comandos Git

  -- Asistencia con IA
  { "github/copilot.vim" },
}

-- Inicializar plugin de cierre automático de etiquetas
require("nvim-ts-autotag").setup()

-- CONFIGURACIÓN DE LSP -------------------------------------------------------
-- Omitir Ruff LSP (se usa Ruff como formateador/linter vía null-ls)
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "ruff",
  "ruff_lsp"
})

local lsp = require("lvim.lsp.manager")

-- Angular
lsp.setup("angularls")

-- Tailwind CSS (ignorar conflictos comunes de CSS)
lsp.setup("tailwindcss", {
  settings = {
    lint = {
      cssConflict = "ignore",
      invalidApply = "ignore",
    },
  },
})

-- Markdown
lsp.setup("markdown_oxide", {
  filetypes = { "markdown", "md" }
})

-- Python (deshabilitar formato, se maneja con Ruff)
lsp.setup("pyright", {
  capabilities = {
    documentFormatting = false,
    documentRangeFormatting = false,
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
      },
    },
  },
})

-- FORMATEADORES --------------------------------------------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    command = "prettier", -- Archivos web (JS, TS, HTML, CSS, JSON, etc.)
  },
  {
    command = "sql-formatter",
    filetypes = { "sql" },
  },
  {
    command = "ruff",
    extra_args = { "format" },
    filetypes = { "python" },
  }
})

-- LINTERS --------------------------------------------------------------------
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  {
    command = "ruff",
    filetypes = { "python" },
  }
})
