-- =============================================================================
-- CONFIGURACIÓN LUNARVIM - DESARROLLO WEB Y ANGULAR
-- =============================================================================
-- Archivo: ~/.config/lvim/config.lua
-- Autor: [Tu Nombre]
-- Última actualización: 2025
--
-- DESCRIPCIÓN:
-- Configuración optimizada de LunarVim para desarrollo web full-stack con
-- énfasis en Angular, TypeScript, Python y DevOps. Incluye LSP, formatters,
-- linters y herramientas de productividad.
--
-- REQUISITOS PREVIOS:
-- - LunarVim instalado (https://www.lunarvim.org)
-- - Node.js >= 18.x y npm
-- - Python >= 3.8
-- - Git
-- =============================================================================

-- =============================================================================
-- 1. CONFIGURACIÓN GENERAL
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1.1 Apariencia y Tema
-- -----------------------------------------------------------------------------

-- Esquema de color principal
-- Opciones disponibles: nordfox, tokyonight, catppuccin, gruvbox, dracula, etc.
lvim.colorscheme = "nordfox"

-- Configuración del cursor (actualmente deshabilitada)
-- Descomenta para cambiar la forma del cursor según el modo de Vim
-- vim.opt.guicursor = ""
-- vim.cmd([[
--   set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
--   set guicursor+=a:blinkwait700-blinkoff400-blinkon250
-- ]])

-- -----------------------------------------------------------------------------
-- 1.2 Formateo Automático
-- -----------------------------------------------------------------------------

-- Activa el formateo automático al guardar archivos
-- Los formatters específicos se configuran en la sección 4
lvim.format_on_save = true

-- =============================================================================
-- 2. TREESITTER - SYNTAX HIGHLIGHTING Y ANÁLISIS DE CÓDIGO
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 2.1 Lenguajes Instalados
-- -----------------------------------------------------------------------------

-- Lista de parsers de Treesitter que se instalarán automáticamente
-- Treesitter proporciona highlighting avanzado y mejor comprensión del código
lvim.builtin.treesitter.ensure_installed = {
  "python",     -- Python
  "typescript", -- TypeScript y Angular
  "javascript", -- JavaScript
  "lua",        -- Lua (para configuración de Neovim)
  "yaml",       -- YAML (Docker, CI/CD)
  "sql",        -- SQL (bases de datos)
  "html",       -- HTML (plantillas web)
  "css",        -- CSS (estilos web)
  "json",       -- JSON (configuración)
  "markdown",   -- Markdown (documentación)
  "groovy",     -- Groovy (Jenkinsfile)
  "tsx",        -- TSX (React con TypeScript)
  "bash",       -- Bash/Shell scripts
}

-- Permite la instalación automática de parsers cuando se abre un archivo nuevo
lvim.builtin.treesitter.auto_install = true

-- =============================================================================
-- 3. SERVIDORES LSP (LANGUAGE SERVER PROTOCOL)
-- =============================================================================
-- Los LSP proporcionan intellisense, autocompletado, ir a definición, etc.

-- -----------------------------------------------------------------------------
-- 3.1 Angular Language Server
-- -----------------------------------------------------------------------------

-- Configuración para proyectos Angular
require("lvim.lsp.manager").setup("angularls")

-- NOTA IMPORTANTE: Requiere instalación global de Angular Language Server
-- Ejecutar: npm install -g @angular/language-server
-- Este servidor proporciona soporte completo para plantillas Angular,
-- directivas, componentes y servicios

-- -----------------------------------------------------------------------------
-- 3.2 TailwindCSS LSP
-- -----------------------------------------------------------------------------

-- Configuración de TailwindCSS con soporte solo para HTML
-- Se define al final del archivo (línea 290+) con configuración específica
-- Proporciona autocompletado de clases de Tailwind en plantillas HTML

-- -----------------------------------------------------------------------------
-- 3.3 Python LSP - Pyright
-- -----------------------------------------------------------------------------

-- Desactivar Ruff como servidor LSP (solo se usa como linter/formatter)
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "ruff",
  "ruff_lsp"
})

-- Configuración de Pyright como LSP principal para Python
require("lvim.lsp.manager").setup("pyright", {
  -- Desactiva el formateo de Pyright (delega a Ruff)
  capabilities = {
    documentFormattingProvider = false
  },
  -- Configuración de análisis estático
  settings = {
    python = {
      analysis = {
        -- Modo de verificación de tipos
        -- Opciones: "off", "basic", "standard", "strict"
        typeCheckingMode = "standard",
      },
    },
  },
})


-- =============================================================================
-- 4. FORMATTERS Y LINTERS
-- =============================================================================
-- Los formatters automatizan el estilo del código
-- Los linters detectan errores y problemas de estilo

local formatters = require("lvim.lsp.null-ls.formatters")
local linters = require("lvim.lsp.null-ls.linters")


-- -----------------------------------------------------------------------------
-- 4.1 Configuración de Formatters
-- -----------------------------------------------------------------------------

formatters.setup({
  -- Prettier: Formatter universal para web
  {
    command = "prettier",
    extra_args = {
      "--tab-width", "2",   -- Ancho de tabulación: 2 espacios
      "--use-tabs", "false" -- Usar espacios en lugar de tabs
    },
    filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "typescript",
      "json",
      "markdown",
      "yaml"
    },
  },

  -- SQL Formatter: Formatea consultas SQL
  {
    command = "sql-formatter",
    extra_args = {
      "--language", "plsql", -- Dialecto: PL/SQL (Oracle)
      "--tab-width", "4",    -- Ancho de tabulación para SQL
      "--use-tabs", "false"
    },
    filetypes = { "sql" },
  },

  -- Ruff: Formatter ultrarrápido para Python
  {
    command = "ruff",
    extra_args = { "format" },
    filetypes = { "python" }
  },
})

-- -----------------------------------------------------------------------------
-- 4.2 Configuración de Linters
-- -----------------------------------------------------------------------------

-- Ruff como linter de Python
-- Detecta errores de sintaxis, imports no usados, violaciones de PEP 8, etc.
linters.setup {
  {
    command = "ruff",
    filetypes = { "python" }
  },
}

-- =============================================================================
-- 5. CONFIGURACIONES ESPECÍFICAS POR TIPO DE ARCHIVO
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 5.1 HTML - Archivos de plantillas
-- -----------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    -- Configuración de indentación para HTML
    vim.opt_local.tabstop = 2     -- Tab = 2 espacios
    vim.opt_local.shiftwidth = 2  -- Indentación automática = 2 espacios
    vim.opt_local.softtabstop = 2 -- Tab en modo inserción = 2 espacios
  end,
})

-- -----------------------------------------------------------------------------
-- 5.2 Jenkinsfile - Archivos de CI/CD
-- -----------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufReadPost" }, {
  pattern = { "Jenkinsfile*", "*.jenkinsfile" },
  callback = function()
    -- Reconocer Jenkinsfile como tipo de archivo específico
    vim.bo.filetype = "jenkinsfile"

    -- Configuración de indentación
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true -- Convertir tabs a espacios

    -- Tratarlo como Groovy para highlighting
    vim.o.filetype = "groovy"
  end,
})

-- =============================================================================
-- 6. GESTIÓN DE PAQUETES CON MASON
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 6.1 Lista de Herramientas a Instalar
-- -----------------------------------------------------------------------------

local mason_tools = {
  -- PYTHON -------------------------------------------------------------------
  "pyright", -- LSP: Análisis estático y type checking
  "ruff",    -- Linter y formatter ultrarrápido

  -- JAVASCRIPT / TYPESCRIPT --------------------------------------------------
  "eslint_d",                   -- Linter rápido (daemon) para JS/TS
  "prettier",                   -- Formatter universal para web
  "typescript-language-server", -- LSP: TypeScript y JavaScript
  "js-debug-adapter",           -- DAP: Debugger para Node.js

  -- FRONTEND - CSS / HTML ----------------------------------------------------
  "css-lsp",                     -- LSP: Autocompletado CSS
  "html-lsp",                    -- LSP: Autocompletado HTML
  "tailwindcss-language-server", -- LSP: Clases de Tailwind CSS

  -- ARCHIVOS DE CONFIGURACIÓN ------------------------------------------------
  "json-lsp",             -- LSP: JSON con esquemas
  "yaml-language-server", -- LSP: YAML con validación
  "yamllint",             -- Linter: Errores de sintaxis YAML
  "lemminx",              -- LSP: XML con validación

  -- DOCUMENTACIÓN ------------------------------------------------------------
  "markdown-oxide", -- LSP: Markdown avanzado

  -- DEVOPS - DOCKER / CI -----------------------------------------------------
  "dockerfile-language-server",      -- LSP: Dockerfile
  "docker-compose-language-service", -- LSP: docker-compose.yml

  -- FRAMEWORKS ---------------------------------------------------------------
  "angular-language-server", -- LSP: Componentes y plantillas Angular

  -- SQL ----------------------------------------------------------------------
  "sql-formatter", -- Formatter: SQL multiplataforma

  -- CORRECCIÓN ORTOGRÁFICA ---------------------------------------------------
  "cspell", -- Spell checker para código

}

-- -----------------------------------------------------------------------------
-- 6.2 Configuración de Mason
-- -----------------------------------------------------------------------------

-- Habilitar Mason (gestor de LSP, DAP, linters, formatters)
lvim.builtin.mason.active = true

-- Permitir que Mason instale LSP automáticamente
lvim.builtin.mason.lsp_installer = true

-- Instalar herramientas automáticamente al iniciar
lvim.builtin.mason.auto_install = true

-- =============================================================================
-- 7. PLUGINS ADICIONALES
-- =============================================================================

lvim.plugins = {
  -- SINTAXIS Y LENGUAJES -----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-angular" -- Parser Angular para Treesitter
  },
  {
    "windwp/nvim-ts-autotag" -- Cierre automático de tags HTML/XML
  },

  -- TEMAS --------------------------------------------------------------------
  { "folke/tokyonight.nvim" },    -- Tema Tokyo Night
  { "ellisonleao/gruvbox.nvim" }, -- Tema Gruvbox
  { "navarasu/onedark.nvim" },    -- Tema One Dark
  { "sainnhe/everforest" },       -- Tema Everforest
  { "shaunsingh/nord.nvim" },     -- Tema Nord
  { "Mofiqul/dracula.nvim" },     -- Tema Dracula
  { "EdenEast/nightfox.nvim" },   -- Familia Nightfox (incluye Nordfox)

  -- CONTROL DE VERSIONES -----------------------------------------------------
  {
    "tpope/vim-fugitive" -- Integración avanzada con Git
  },
  {
    "lewis6991/gitsigns.nvim" -- Indicadores Git en la columna lateral
  },

  -- EXPERIENCIA DE USUARIO ---------------------------------------------------
  {
    "sphamba/smear-cursor.nvim", -- Efecto visual para el cursor
    -- config = function()
    --   require("smear_cursor").setup({
    --     cursor_color = "#d3cdc3",
    --     normal_bg = "#282828",
    --     smear_between_buffers = true,
    --     smear_between_neighbor_lines = true,
    --     scroll_buffer_space = true,
    --     legacy_computing_symbols_support = false,
    --   })
    -- end,
  },

  -- GESTIÓN DE HERRAMIENTAS --------------------------------------------------
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = mason_tools, -- Lista definida en línea 185+
        auto_update = true,             -- Actualiza herramientas automáticamente
        run_on_start = true,            -- Instala al iniciar Neovim
        start_delay = 3000,             -- Espera 3s antes de iniciar instalación
      }
    end
  },

  -- COPILOT -------------------------------------------------------------------
  { "github/copilot.vim" },
}

--
--
-- =============================================================================
-- 8. CONFIGURACIÓN DE PLUGINS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 8.1 Autotag - Cierre automático de tags
-- -----------------------------------------------------------------------------

-- Cierra automáticamente tags HTML/XML al escribir </
require("nvim-ts-autotag").setup()

-- -----------------------------------------------------------------------------
-- 8.2 GitHub Copilot (Desactivado por defecto)
-- -----------------------------------------------------------------------------

-- Descomenta las siguientes líneas para activar GitHub Copilot
-- Requiere autenticación: :Copilot setup
--
-- lvim.builtin.copilot.active = true
-- require("copilot").setup({
--   suggestion = { enabled = false },  -- Desactiva sugerencias inline
--   panel = { enabled = false }        -- Desactiva panel lateral
-- })

-- =============================================================================
-- 9. CONFIGURACIÓN AVANZADA DE LSP
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 9.1 TailwindCSS - Configuración específica para HTML
-- -----------------------------------------------------------------------------

local lsp = require("lvim.lsp.manager")

lsp.setup("tailwindcss", {
  -- Activar solo para HTML (evita conflictos en otros archivos)
  filetypes = { "html" },

  settings = {
    tailwindCSS = {
      -- Lenguajes adicionales donde funciona Tailwind
      includeLanguages = {
        html = "html",
        typescript = "typescriptreact",
      },

      -- Configuración de linting
      lint = {
        cssConflict = "ignore",  -- Ignorar conflictos de CSS
        invalidApply = "ignore", -- Ignorar @apply inválidos
      },

      -- Configuración experimental
      experimental = {
        classRegex = {}, -- Regex personalizado para detectar clases
      },
    },
  },
})


-- -----------------------------------------------------------------------------
-- 9.2 Mardown Oxide- Configuración específica para Mardown
-- -----------------------------------------------------------------------------
lsp.setup("markdown_oxide", {
  filetypes = { "markdown" },
})

-- =============================================================================
-- DEPENDENCIAS EXTERNAS REQUERIDAS
-- =============================================================================
--
-- NODE.JS / NPM:
--   npm install -g prettier                    # Formatter web
--   npm install -g @angular/language-server    # LSP Angular
--
-- PYTHON:
--   pip install ruff                           # Linter y formatter
--
-- SISTEMA:
--   - Git (para plugins de control de versiones)
--   - Node.js >= 18.x
--   - Python >= 3.8
--
-- NOTAS:
--   - La mayoría de herramientas se instalan automáticamente via Mason
--   - Algunas herramientas requieren instalación manual (ver arriba)
--   - Para verificar instalaciones: :Mason
--
-- =============================================================================
