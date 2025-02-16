return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		term_colors = true,
		transparent_background = vim.g.transparent(),
		integrations = {
			cmp = true,
			blink_cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			notify = true,
			mason = true,
			rainbow_delimiters = true,
			snacks = true,
			-- mini = {
			--   enabled = true,
			--   indentscope_color = '',
			-- },
			dropbar = {
				enabled = true,
				color_mode = true, -- enable color for kind's texts, not just kind's icons
			},
			fidget = true,
			noice = true,
			symbols_outline = true,
			lsp_trouble = true,
			which_key = true,
		},
		-- transparent_background = transparent_background,
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = { "italic" }, -- Change the style of comments
			conditionals = { "italic" },
			loops = {},
			functions = { "italic" },
			keywords = { "italic", "bold" },
			strings = {},
			variables = {},
			numbers = {},
			booleans = { "italic" },
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {
			mocha = {
				rosewater = "#ffb59c",
				flamingo = "#ffb59c",
				pink = "#ffb2b8",
				mauve = "#e6b6f1",
				red = "#ffb2b8",
				maroon = "#ffb2b8",
				peach = "#fab387",
				yellow = "#f5bd6f",
				green = "#e1c28c",
				teal = "#b1d18a",
				sky = "#ffb3ad",
				sapphire = "#ffb3ad",
				blue = "#ffb3ad",
				lavender = "#ffb3ad",
				text = "#f1dedc",
				subtext1 = "#bbbbbb",
				subtext0 = "#aaaaaa",
				overlay2 = "#999999",
				overlay1 = "#888888",
				overlay0 = "#777777",
				surface2 = "#666666",
				surface1 = "#555555",
				surface0 = "#444444",
				base = "#231918",
				mantle = "#140c0b",
				crust = "#1a1110",
			},
			latte = {
				rosewater = "#fab387",
				flamingo = "#fab387",
				pink = "#f38ba8",
				mauve = "#e6b6f1",
				red = "#f38ba8",
				maroon = "#f38ba8",
				peach = "#fab387",
				yellow = "#633f00",
				green = "#e1c28c",
				teal = "#a6e3a1",
				sky = "#ffb3ad",
				sapphire = "#ffb3ad",
				blue = "#ffb3ad",
				lavender = "#ffb3ad",
				text = "#f1dedc",
				subtext1 = "#555555",
				subtext0 = "#666666",
				overlay2 = "#777777",
				overlay1 = "#888888",
				overlay0 = "#999999",
				surface2 = "#aaaaaa",
				surface1 = "#bbbbbb",
				surface0 = "#cccccc",
				base = "#231918",
				mantle = "#140c0b",
				crust = "#1a1110",
			},
		},

		highlight_overrides = {
			mocha = function(mocha)
				return {
					DiagnosticUnderlineError = { undercurl = true, sp = mocha.red },
					DiagnosticUnderlineWarn = { undercurl = true, sp = mocha.yellow },
					DiagnosticUnderlineInfo = { undercurl = true, sp = mocha.green },
					DiagnosticUnderlineHint = { undercurl = true, sp = mocha.sky },
				}
			end,
		},
	},
}
