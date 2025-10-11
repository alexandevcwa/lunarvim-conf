# 🚀 Mi Configuración LunarVim

[![LunarVim](https://img.shields.io/badge/LunarVim-1.0+-blueviolet.svg)](https://lunarvim.org)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)](https://neovim.io)

Mi configuración personalizada de LunarVim, diseñada para desarrollo eficiente y siempre a mano. ✨

## 📁 Estructura

```bash
lvim-config/
├── config.lua          # ⚙️  Configuración principal
├── lazy-lock.json      # 🔒  Versiones de plugins
└── README.md           # 📚  Este archivo
```

## Configuración LunarVim con GitHub Copilot

Para integrar GitHub Copilot en tu configuración de LunarVim, sigue estos pasos:

1. Registrate en [GitHub Copilot](https://copilot.github.com/) y asegúrate de tener una suscripción activa.

2. Ejecuta el siguiente comando en tu LunarVim para iniciar sesión en GitHub Copilot:

   ```bash
    :Copilot setup
   ```

3. Sigue las instrucciones en pantalla para completar el proceso de autenticación.

4. Una vez autenticado, puedes comenzar a usar GitHub Copilot en tus archivos de código. Simplemente comienza a escribir y Copilot te sugerirá completaciones de código.

### 🚀 Comandos Útiles

- `Alt + ]`: Moverse a la siguiente sugerencia.
- `Alt + [`: Retroceder a la sugerencia anterior.
- `Ctrl + i`: Aceptar la sugerencia de Copilot.

### 🔧 Configuración Adicional

Si deseas personalizar el comportamiento de GitHub Copilot, puedes agregar configuraciones adicionales en tu archivo `config.lua`. Por ejemplo:

```lua
vim.g.copilot_no_tab_map = true  -- Deshabilitar el mapeo de la tecla Tab
```
