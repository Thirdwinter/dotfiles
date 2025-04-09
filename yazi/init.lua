require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.PLAIN,
})

th.git = th.git or {}
th.git.added = ui.Style():fg("#a6e3a1")
th.git.untracked = ui.Style():fg("gray")
th.git.modified = ui.Style():fg("#f9e2af")
th.git.added_sign = ""
th.git.untracked_sign = ""
th.git.modified_sign = ""
th.git.deleted_sign = ""
require("git"):setup()
