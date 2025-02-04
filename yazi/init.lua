require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

THEME.git = THEME.git or {}
THEME.git.added = ui.Style():fg("#a6e3a1")
THEME.git.untracked = ui.Style():fg("gray")
THEME.git.modified = ui.Style():fg("#f9e2af")
THEME.git.added_sign = ""
THEME.git.untracked_sign = ""
THEME.git.modified_sign = ""
THEME.git.deleted_sign = ""
require("git"):setup({})

function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = (self._file.cha.modified or 0)

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
end
