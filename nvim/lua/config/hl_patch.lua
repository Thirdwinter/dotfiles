local M = {}

---@private
-- 辅助函数：获取现有高亮属性，以便进行扩展
local get_existing_hl = function(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

---@alias HighlightConfig { [string]: any }
---@alias HighlightLink string
---@alias HighlightDefinition HighlightConfig | HighlightLink | fun(): HighlightConfig

---@class SetHlOptions
---@field prefix? string 高亮组名称前缀
---@field default? boolean 是否设为默认高亮（允许用户覆盖）
---@field managed? boolean 是否将高亮组存入M表管理（默认为true）
---@field clear? boolean 设置前是否清空原有有配置（默认为false）

---@param groups table<string, HighlightDefinition> 键为高亮组名，值为高亮配置或链接目标
---@param opts? SetHlOptions 配置选项
function M.set_hl(groups, opts)
  M.definitions = M.definitions or {}
  M.links = M.links or {}
  opts = vim.tbl_extend('force', {
    clear = false -- 默认不清空原有配置
  }, opts or {})

  for hl_group, hl in pairs(groups) do
    -- 处理前缀
    local full_group_name = opts.prefix and opts.prefix .. hl_group or hl_group

    -- 确保hl_config是表
    ---@type vim.api.keyset.highlight
    local hl_config
    if type(hl) == "string" then
      -- 字符串表示高亮链接，转换为 { link = 目标 } 格式
      hl_config = { link = hl } ---@cast hl_config vim.api.keyset.highlight
    elseif type(hl) == "function" then
      hl_config = hl() ---@cast hl_config vim.api.keyset.highlight
    else
      -- 直接使用表类型配置，明确类型
      hl_config = hl ---@cast hl_config vim.api.keyset.highlight
    end

    -- 设置default属性
    hl_config.default = opts.default

    -- 如果需要清空，先执行清空操作
    if opts.clear then
      -- 使用pcall容错，避免高亮组不存在时报错
      pcall(vim.api.nvim_set_hl, 0, full_group_name, {})
    end

    -- 存入definitions
    if opts.managed ~= false then
      M.definitions[full_group_name] = hl_config
    end

    vim.api.nvim_set_hl(0, full_group_name, hl_config)
  end
end

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

-- SnacksPicker
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
end
]] --

function M.apply()
  -- 遍历 M.definitions 来获取配置
  for group_name, hl_attrs in pairs(M.definitions) do
    if type(group_name) == 'string' then
      local final_attrs = hl_attrs
      if type(hl_attrs) == 'function' then
        final_attrs = hl_attrs()
      end
      if type(final_attrs) == 'table' then
        vim.api.nvim_set_hl(0, group_name, final_attrs)
      else
        vim.notify(string.format("针对 '%s' 的高亮属性无效: %s", group_name, vim.inspect(hl_attrs)), vim.log.levels.WARN)
      end
    end
  end

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

return M
