return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = { light = "mocha", dark = "mocha" },

      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
      float = { transparent = false, solid = false },

      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },

      color_overrides = {
        all = {
          crust = "#222222",
          mantle = "#282828",
          base = "#323232",
          surface0 = "#3c3c3c",
          surface1 = "#4a4a4a",
          surface2 = "#565656",

          text = "#eaeaea",
          subtext1 = "#abb2bf",
          subtext0 = "#9e9e9e",
          overlay2 = "#9e9e9e",
          overlay1 = "#7a8388",
          overlay0 = "#727a82",

          rosewater = "#dba870",
          flamingo = "#e06c75",
          pink = "#c678dd",
          mauve = "#c678dd",
          red = "#e06c75",
          maroon = "#b83030",
          peach = "#d19a66",
          yellow = "#e5c07b",
          green = "#98c379",
          teal = "#56b6c2",
          sky = "#56b6c2",
          sapphire = "#5a8bb0",
          blue = "#5a8bb0",
          lavender = "#72a3c5",
          coral = "#e89a8a",

          border = "#4c7899",
          selection = "#285577",
          critical = "#6e2028",
          text_max = "#ffffff",
          diff_add = "#28442f",
          diff_change = "#283d4d",
          diff_delete = "#4a2a2d",
          diff_text = "#4c7899",
        },
        mocha = {},
      },

      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.subtext0, style = { "italic" } },
          ["@comment"] = { fg = colors.subtext0, style = { "italic" } },
          ["@comment.todo"] = { fg = colors.crust, bg = colors.rosewater, style = { "bold" } },
          ["@comment.note"] = { fg = colors.text_max, bg = colors.border, style = { "bold" } },

          Visual = { bg = colors.selection, style = { "bold" } },
          VisualNOS = { bg = colors.selection, style = { "bold" } },
          Search = { bg = colors.selection, fg = colors.text_max },
          IncSearch = { bg = colors.peach, fg = colors.crust },
          CurSearch = { bg = colors.peach, fg = colors.crust },
          PmenuSel = { bg = colors.selection, style = { "bold" } },
          WildMenu = { bg = colors.selection },

          FloatBorder = { fg = colors.border, bg = colors.mantle },
          FloatTitle = { fg = colors.subtext1, bg = colors.mantle },
          PmenuBorder = { fg = colors.border, bg = colors.mantle },

          StatusLineNC = { fg = colors.overlay1, bg = colors.mantle },
          TabLine = { bg = colors.crust, fg = colors.overlay1 },
          TabLineSel = { fg = colors.text, bg = colors.mantle, style = { "bold" } },

          DiffAdd = { bg = colors.diff_add },
          DiffChange = { bg = colors.diff_change },
          DiffDelete = { bg = colors.diff_delete },
          DiffText = { bg = colors.diff_text },

          Label = { fg = colors.mauve },
          Special = { fg = colors.red },
          SpecialChar = { fg = colors.red },

          Identifier = { fg = colors.red },
          ["@variable.parameter"] = { fg = colors.red, style = { "italic" } },
          ["@property"] = { fg = colors.coral },
          ["@variable.member"] = { fg = colors.coral },
          ["@field"] = { fg = colors.coral },

          SnacksDashboardHeader = { fg = colors.rosewater },
          CursorLineNr = { fg = colors.subtext1, style = { "bold" } },
        }
      end,

      integrations = {
        gitsigns = true,
        which_key = true,
        mason = true,
        markdown = true,
        notify = true,
        noice = true,
        dap = true,
        dap_ui = true,
        telescope = true,
        indent_blankline = { enabled = true, scope_color = "overlay1" },
        blink_cmp = { style = "bordered" },
      },
    })

    local function cozy_terminal()
      local ansi = {
        [0] = "#727a82",
        [1] = "#e06c75",
        [2] = "#98c379",
        [3] = "#e5c07b",
        [4] = "#5a8bb0",
        [5] = "#c678dd",
        [6] = "#56b6c2",
        [7] = "#eaeaea",
        [8] = "#7e868e",
        [9] = "#e88991",
        [10] = "#a8d48a",
        [11] = "#ecd08e",
        [12] = "#72a3c5",
        [13] = "#d494e8",
        [14] = "#6ec8d4",
        [15] = "#ffffff",
      }
      for i, hex in pairs(ansi) do
        vim.g["terminal_color_" .. i] = hex
      end
    end

    vim.cmd.colorscheme("catppuccin")
    cozy_terminal()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "catppuccin*",
      callback = cozy_terminal,
    })
  end,
}
