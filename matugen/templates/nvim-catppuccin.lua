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
				rosewater = "{{colors.orange.default.hex}}",
				flamingo = "{{colors.orange.default.hex}}",
				pink = "{{colors.red.default.hex}}",
				mauve = "{{colors.purple.default.hex}}",
				red = "{{colors.red.default.hex}}",
				maroon = "{{colors.red.default.hex}}",
				peach = "{{colors.orange_source.default.hex}}",
				yellow = "{{colors.yellow.default.hex}}",
				green = "{{colors.tertiary.default.hex}}",
				teal = "{{colors.green.default.hex}}",
				sky = "{{colors.primary.default.hex}}",
				sapphire = "{{colors.primary.default.hex}}",
				blue = "{{colors.primary.default.hex}}",
				lavender = "{{colors.primary.default.hex}}",
				text = "{{colors.on_surface.default.hex}}",
				subtext1 = "#bbbbbb",
				subtext0 = "#aaaaaa",
				overlay2 = "#999999",
				overlay1 = "#888888",
				overlay0 = "#777777",
				surface2 = "#666666",
				surface1 = "#555555",
				surface0 = "#444444",
				base = "{{colors.surface_container_low.default.hex}}",
				mantle = "{{colors.surface_container_lowest.default.hex}}",
				crust = "{{colors.surface.default.hex}}",
			},
			latte = {
				rosewater = "{{colors.orange_source.default.hex}}",
				flamingo = "{{colors.orange_source.default.hex}}",
				pink = "{{colors.red_source.default.hex}}",
				mauve = "{{colors.purple.default.hex}}",
				red = "{{colors.red_source.default.hex}}",
				maroon = "{{colors.red_source.default.hex}}",
				peach = "{{colors.orange_source.default.hex}}",
				yellow = "{{colors.yellow_container.default.hex}}",
				green = "{{colors.tertiary.default.hex}}",
				teal = "{{colors.green_source.default.hex}}",
				sky = "{{colors.primary.default.hex}}",
				sapphire = "{{colors.primary.default.hex}}",
				blue = "{{colors.primary.default.hex}}",
				lavender = "{{colors.primary.default.hex}}",
				text = "{{colors.on_surface.default.hex}}",
				subtext1 = "#555555",
				subtext0 = "#666666",
				overlay2 = "#777777",
				overlay1 = "#888888",
				overlay0 = "#999999",
				surface2 = "#aaaaaa",
				surface1 = "#bbbbbb",
				surface0 = "#cccccc",
				base = "{{colors.surface_container_low.default.hex}}",
				mantle = "{{colors.surface_container_lowest.default.hex}}",
				crust = "{{colors.surface.default.hex}}",
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
