-- =============================================================================
-- CONFIGURACIÓN LUNARVIM - DESARROLLO WEB Y ANGULAR
-- Archivo: ~/.config/lvim/config.lua
-- =============================================================================

-- ---------------------------------------------------------------------------
-- GENERAL
-- ---------------------------------------------------------------------------

-- Tema de color principal
lvim.colorscheme = "carbonfox"

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
local linters = require("lvim.lsp.null-ls.linters")

-- Prettier para proyectos web
formatters.setup({
  {
    command = "prettier",
    extra_args = { "--tab-width", "2", "--use-tabs", "false" },
    filetypes = { "html", "css", "scss", "javascript", "typescript", "json" },
  },
})

-- Formareo de archivos SQL
formatters.setup({
  {
    exe = "sql_formatter",
    args = { "--language", "plsql" },
    extra_args = { "--tab-width", "4", "--use-tabs", "false" },
    filetypes = { "sql" },
  },
})

-- formatters.setup({
--   {
--     exe = "sqlfluff",
--     args = { "fix", "--dialect", "oracle" },
--     filetypes = { "sql" },
--   },
-- })

-- Configuramos Ruff para el LINTING (diagnósticos de estilo) Python
linters.setup {
  { command = "ruff", filetypes = { "python" } },
  -- Puedes añadir aquí otros linters si es necesario
}

-- Configuramos Ruff para el FORMATEO (ej. reemplaza a black) Python
formatters.setup {
  { command = "ruff", filetypes = { "python" } },
  -- { command = "black", filetypes = { "python" } }, -- Si quieres Black como fallback
}


-- ------------------------------
-- Configuración de LSP (Pyright) Python
-- ------------------------------

-- Desabilitar Ruff com LSP
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "ruff",
  "ruff_lsp"
})

-- NOTA: Esto es solo si quieres anular la configuración predeterminada de LunarVim.
-- Si Pyright ya está funcionando bien, este paso puede ser opcional.

require("lvim.lsp.manager").setup("pyright", {
  -- Asegura que Pyright no intente formatear (ya lo hace Ruff)
  capabilities = {
    documentFormattingProvider = false
  },
  -- Configuración de Pyright (ejemplo para forzar el chequeo de tipos estricto)
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
      },
    },
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

local mason_tools = {
  -- ====================
  -- LINTERS / FORMATTERS
  -- ====================
  -- Python
  --"black",  -- Formateador de código Python
  "pyright", -- LSP Principal
  "ruff",    -- Linter y Formatter

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

  -- C++
  "cpptools", -- DAP

  -- Idiomas
  "cspell",
}

-- Mason general
lvim.builtin.mason.active = true
lvim.builtin.mason.lsp_installer = true

-- Auto-instalar paquetes al iniciar
lvim.builtin.mason.auto_install = true

lvim.plugins = {
  -- Syntax y lenguajes
  { "martinda/Jenkinsfile-vim-syntax" },
  { "nvim-treesitter/nvim-treesitter-angular" },
  { "windwp/nvim-ts-autotag" },

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
  { "psf/black" },              -- Formateo Python
  { "zbirenbaum/copilot.lua" }, -- GitHub Copilot

  -- Git
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },

  -- Mason, instalación automática de plugins
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = mason_tools,
        auto_update = true,  -- actualiza herramientas automáticamente
        run_on_start = true, -- instala herramientas al iniciar Neovim
        start_delay = 3000,  -- tiempo en ms para esperar antes de iniciar la instalación
        ebounce_hours = 24,  -- evita múltiples actualizaciones en 24h
      }
    end
  },
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
