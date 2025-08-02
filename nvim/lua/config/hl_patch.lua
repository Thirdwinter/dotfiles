local M = {} -- 这个 M 将作为模块的导出表

---@private
-- 辅助函数：获取现有高亮属性，以便进行扩展
local get_existing_hl = function(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

-- ===============================================
-- 亮点补丁定义 (之前在 highlights_patch.lua 中的内容)
-- 这些定义现在直接作为 M 表的属性，或者在 M.definitions 这样的子表中
-- ===============================================

M.definitions = {} -- 用于存储所有常规高亮定义

M.definitions['@variable.parameter'] = function()
  return vim.tbl_extend('force', get_existing_hl('@variable.parameter'), { italic = true, bold = true })
end

M.definitions['@variable'] = function()
  return vim.tbl_extend('force', get_existing_hl('@variable'), { italic = true, fg = "#B4BEFF" })
end

M.definitions['Boolean'] = function()
  return vim.tbl_extend('force', get_existing_hl('Boolean'), { italic = true, bold = true })
end

M.definitions['Statement'] = function()
  return vim.tbl_extend('force', get_existing_hl('Statement'), { italic = true })
end

M.definitions['Comment'] = function()
  return vim.tbl_extend('force', get_existing_hl('Comment'), { italic = true, bold = true })
end

M.definitions['Type'] = function()
  return vim.tbl_extend('force', get_existing_hl('Type'), { italic = true, bold = false })
end

M.definitions['Visual'] = function()
  return vim.tbl_extend('force', get_existing_hl('Visual'), { bg = '#45475A' })
end

-- 用于高亮链接和清除的特殊条目

-- 不依赖于现有组或链接的特定高亮设置
M.definitions['WinBarNc'] = function()
  return vim.tbl_extend('force', get_existing_hl('WinBarNc'), { bg = "" })
end
M.definitions['WinBar'] = function()
  return vim.tbl_extend('force', get_existing_hl('WinBar'), { bg = "" })
end
M.definitions['CursorLine'] = { bg = '#4f536d' }
M.definitions['markdownCodeBlock'] = { bg = '' }
M.definitions['MyBorder'] = { fg = '#B4BEFF' }
M.definitions['BlinkCmpLabelMatch'] = { fg = '#f38ba8' }
M.definitions['BlinkCmpDocSeparator'] = { bg = '' }
M.definitions['BlinkCmpDoc'] = { bg = '' }

-- SnacksPicker 高亮
M.definitions['SnacksPickerTitle'] = { fg = '#11111b', bg = '#cba6f7' }
M.definitions['SnacksPickerInputTitle'] = { fg = '#11111b', bg = '#f38ba8' }
M.definitions['SnacksPickerPreviewTitle'] = { fg = '#11111b', bg = '#a6e3a1' }
M.definitions['SnacksPickerListTitle'] = { fg = '#11111b', bg = '#b4befe' }

M.links = {
  { 'FloatBorder',                 'MyBorder',    clear = true },
  { 'CursorLineNr',                'MyBorder',    clear = true },
  { 'NormalFloat',                 'MyBorder',    clear = true },
  { 'BlinkCmpMenuBorder',          'FloatBorder', clear = true },
  { 'BlinkCmpDocBorder',           'FloatBorder', clear = true },
  { 'BlinkCmpSignatureHelpBorder', 'FloatBorder', clear = true },
  { 'BlinkCmpMenuSelection',       'CursorLine',  clear = true },
}


--[[
-- 如果你有透明背景的逻辑，并且它会动态修改高亮，可以像这样在这里更新 M.definitions
if not vim.g.transparent() then
  local normal_hl = vim.api.nvim_get_hl_by_name('Normal', true)
  local label_hl = vim.api.nvim_get_hl_by_name('Label', true)
  local Popbg = ''
  local Popfg = '#138376'

  if normal_hl and normal_hl.background then
    Popbg = string.format('#%06x', normal_hl.background)
  end
  if label_hl and label_hl.fg then
    Popfg = string.format('#%06x', label_hl.fg)
  end

  M.definitions['UserMenu'] = { bg = Popbg }
  M.definitions['Pmenu'] = { fg = Popfg, bg = Popbg }
  -- ... 其他相关定义
end
]] --

-- ===============================================
-- 应用高亮补丁的函数 (之前在 apply_highlights.lua 中的内容)
-- 现在这个函数成为 M 的一个方法
-- ===============================================

function M.apply()
  -- 应用常规高亮
  -- 遍历 M.definitions 来获取配置
  for group_name, hl_attrs in pairs(M.definitions) do
    if type(group_name) == 'string' then
      local final_attrs = hl_attrs
      if type(hl_attrs) == 'function' then
        -- 如果是函数，执行它以获取属性 (用于动态扩展)
        final_attrs = hl_attrs()
      end
      if type(final_attrs) == 'table' then
        vim.api.nvim_set_hl(0, group_name, final_attrs)
      else
        vim.notify(string.format("针对 '%s' 的高亮属性无效: %s", group_name, vim.inspect(hl_attrs)), vim.log.levels.WARN)
      end
    end
  end

  -- 应用高亮链接
  if M.links and type(M.links) == 'table' then
    for i, link_def in ipairs(M.links) do
      if type(link_def) == 'table' and #link_def >= 2 then
        local target = link_def[1]
        local source = link_def[2]
        if link_def.clear then
          pcall(function() vim.cmd('highlight clear ' .. target) end)               -- Wrap in an anonymous function
        end
        pcall(function() vim.cmd('highlight link ' .. target .. ' ' .. source) end) -- Wrap in an anonymous function
      else
        vim.notify(string.format("链接定义无效，索引 %d: %s", i, vim.inspect(link_def)), vim.log.levels.WARN)
      end
    end
  end
end

return M -- 导出 M 表，其中包含定义和 apply 函数
