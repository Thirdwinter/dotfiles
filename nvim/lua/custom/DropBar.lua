-- 定义需要用到的颜色变量（根据实际主题调整）
local overlay1 = "#666666" -- 示例颜色值
local text = "#bbbbbb"     -- 示例颜色值

-- 1. 基础高亮组配置（直接调用 set_hl 应用）
-- require("config.hl_patch").set_hl({
--   -- 非链接样式配置
--   DropBarMenuHoverEntry = { link = "Visual" }, -- 链接到 Visual 高亮组
--   DropBarMenuHoverIcon = { reverse = true },   -- 直接样式：反转颜色
--   DropBarMenuHoverSymbol = { bold = true },    -- 直接样式：加粗
--   DropBarIconUISeparator = { fg = overlay1 },  -- 直接样式：指定前景色
-- }, { clear = false })                          -- 不清空原有配置（默认值，可省略）

-- 2. 批量配置 Kind 系列高亮组（全部使用链接）
-- 用循环简化重复代码，避免手动逐个定义
local kind_groups = {
  "Array", "Boolean", "BreakStatement", "Call", "CaseStatement", "Class",
  "Constant", "Constructor", "ContinueStatement", "Declaration", "Delete",
  "DoStatement", "ElseStatement", "Enum", "EnumMember", "Event", "Field",
  "File", "Folder", "ForStatement", "Function", "Identifier", "IfStatement",
  "Interface", "Keyword", "List", "Macro", "MarkdownH1", "MarkdownH2",
  "MarkdownH3", "MarkdownH4", "MarkdownH5", "MarkdownH6", "Method", "Module",
  "Namespace", "Null", "Number", "Object", "Operator", "Package", "Property",
  "Reference", "Repeat", "Scope", "Specifier", "Statement", "String", "Struct",
  "SwitchStatement", "Type", "TypeParameter", "Unit", "Value", "Variable",
  "WhileStatement"
}

-- 循环生成并应用配置
for _, kind in ipairs(kind_groups) do
  local group_name = "DropBarKind" .. kind       -- 拼接高亮组名（如 DropBarKindArray）
  local target_group = "DropBarIconKind" .. kind -- 目标链接组名（如 DropBarIconKindArray）
  require("config.hl_patch").set_hl({
    [group_name] = target_group                  -- 链接到目标组
  }, { default = true, clear = true })           -- 设为默认配置（允许用户覆盖）
end
