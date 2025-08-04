---@diagnostic disable: param-type-mismatch
---@alias statuscolumn.Component "mark"|"sign"|"fold"|"git"
---@alias statuscolumn.Components statuscolumn.Component[]|fun(win:number,buf:number,lnum:number):statuscolumn.Component[]

---@class statuscolumn.Config
---@field left statuscolumn.Components
---@field right statuscolumn.Components
---@field enabled? boolean
local defaults = {
  left = { "sign", "git" }, -- priority of signs on the left (high to low)
  right = { "fold" },       -- priority of signs on the right (high to low)
  folds = {
    open = true,            -- show open fold icons
    git_hl = true,          -- use Git Signs hl for fold icons
  },
  git = {
    -- patterns to match Git signs
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50, -- refresh at most every 50ms
}

-- local Snacks = require("snacks")

---@class statuscolumn
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(t)
    return t.get()
  end,
})

M.meta = {
  desc = "Pretty status column",
  needs_setup = true,
}


-- local config = Snacks.config.get("statuscolumn", defaults)
local config = defaults

---@private
---@alias statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias statuscolumn.Sign {name:string, text:string, texthl:string, priority:number, type:statuscolumn.Sign.type}

-- Cache for signs per buffer and line
---@type table<number,table<number,statuscolumn.Sign[]>>
local sign_cache = {}
local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>
local did_setup = false


local hl_patch = require("config.hl_patch")
---@private
function M.setup()
  if did_setup then
    return
  end
  did_setup = true
  hl_patch.set_hl({
    Mark = "DiagnosticHint",
  }, { prefix = "MyStatusColumn", default = true })
  local timer = assert((vim.uv or vim.loop).new_timer())
  timer:start(config.refresh, config.refresh, function()
    sign_cache = {}
    cache = {}
  end)
end

---@private
---@param name string
function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end
end

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@private
---@return table<number, statuscolumn.Sign[]>
---@param buf number
function M.buf_signs(buf)
  -- Get regular signs
  ---@type table<number, statuscolumn.Sign[]>
  local signs = {}

  if vim.fn.has("nvim-0.10") == 0 then
    -- Only needed for Neovim <0.10
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*" })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as statuscolumn.Sign]]
      if ret then
        ret.priority = sign.priority
        ret.type = M.is_git_sign(sign.name) and "git" or "sign"
        signs[sign.lnum] = signs[sign.lnum] or {}
        table.insert(signs[sign.lnum], ret)
      end
    end
  end

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local lnum = extmark[2] + 1
    signs[lnum] = signs[lnum] or {}
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    table.insert(signs[lnum], {
      name = name,
      type = M.is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end

  -- Add marks
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "MyStatusColumnMark", type = "mark" })
    end
  end

  return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@private
---@param win number
---@param buf number
---@param lnum number
---@return statuscolumn.Sign[]
function M.line_signs(win, buf, lnum)
  local buf_signs = sign_cache[buf]
  if not buf_signs then
    buf_signs = M.buf_signs(buf)
    sign_cache[buf] = buf_signs
  end
  local signs = buf_signs[lnum] or {}

  -- Get fold signs
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(lnum) >= 0 then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif config.folds.open and vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)
  return signs
end

---@private
---@param sign? statuscolumn.Sign
function M.icon(sign)
  if not sign then
    return "  "
  end
  local key = (sign.text or "") .. (sign.texthl or "")
  if icon_cache[key] then
    return icon_cache[key]
  end
  local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
  text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
  icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  return icon_cache[key]
end

---@return string
function M._get()
  -- 检查是否已初始化，如果未初始化则执行 setup 函数
  if not did_setup then
    M.setup()
  end

  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local nu = vim.wo[win].number
  local rnu = vim.wo[win].relativenumber
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"

  -- Initialize parts that will be built
  local left_content = ""
  local right_content = "" -- Renamed from components[3] for clarity in this context
  ---@diagnostic disable-next-line: unused-local
  local git_sign_hl_group = nil

  if not (show_signs or nu or rnu) then
    return ""
  end

  -- --- BEGIN MODIFICATIONS ---

  -- First, construct left and right content to get their actual rendered widths
  if show_signs then
    local is_file = vim.bo[buf].buftype == ""
    local signs = M.line_signs(win, buf, vim.v.lnum)

    -- Try to find a Git sign for separator color
    for _, s in ipairs(signs) do
      if s.type == "git" and s.texthl then
        git_sign_hl_group = s.texthl
        break
      end
    end

    local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left
    local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right

    for _, comp_type in ipairs(left_c) do
      local found_sign = nil
      for _, s in ipairs(signs) do
        if s.type == comp_type then
          found_sign = s
          break
        end
      end

      if config.folds.git_hl and found_sign and found_sign.type == "fold" then
        for _, s in ipairs(signs) do
          if s.type == "git" then
            found_sign.texthl = s.texthl
            break
          end
        end
      end
      left_content = left_content .. M.icon(found_sign)
    end

    if is_file then
      for _, comp_type in ipairs(right_c) do
        local found_sign = nil
        for _, s in ipairs(signs) do
          if s.type == comp_type then
            found_sign = s
            break
          end
        end

        if config.folds.git_hl and found_sign and found_sign.type == "fold" then
          for _, s in ipairs(signs) do
            if s.type == "git" then
              found_sign.texthl = s.texthl
              break
            end
          end
        end
        right_content = right_content .. M.icon(found_sign)
      end
    end
  else
    -- If not showing signs, use empty spaces based on configured components
    left_content = string.rep("  ", #config.left)
    right_content = string.rep("  ", #config.right)
  end

  -- Calculate the *actual* rendered width of left_content
  -- We need to strip highlights to get the true display width
  local actual_left_width = vim.fn.strdisplaywidth(left_content:gsub("%%#.-#", ""):gsub("%%*", ""))

  -- Determine the expected width for the line number area
  local max_lnum_digits = #tostring(vim.api.nvim_buf_line_count(buf))
  -- Line number width includes digits + 1 space before separator
  local expected_lnum_display_width = max_lnum_digits + 1

  -- Calculate the total width of the column from the configuration.
  -- Each component is 2 characters wide.
  -- Line number width will be `max_lnum_digits` + 1 (for space)
  -- Plus 1 for the separator itself.
  local total_configured_width = (#(type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left) * 2)
      + (#(type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right) * 2)
      + expected_lnum_display_width
      + 1 -- for the separator

  -- The effective width for the line number area (including its trailing space)
  -- This ensures a consistent total column width, padding if necessary.
  local effective_lnum_slot_width = total_configured_width - actual_left_width -
      vim.fn.strdisplaywidth(right_content:gsub("%%#.-#", ""):gsub("%%*", "")) -
      1 -- -1 for separator

  -- Adjust for minimum width or ensure it's not negative
  effective_lnum_slot_width = math.max(expected_lnum_display_width, effective_lnum_slot_width)

  -- Handle line number area (middle)
  local line_num_content = ""
  if (nu or rnu) and vim.v.virtnum == 0 then
    local num ---@type number
    if rnu and nu and vim.v.relnum == 0 then
      num = vim.v.lnum
    elseif rnu then
      num = vim.v.relnum
    else
      num = vim.v.lnum
    end
    -- Get the display width of the current line number
    local current_num_display_width = #tostring(num)
    -- Pad the number to the effective slot width, minus the single trailing space we add
    local padding_needed = effective_lnum_slot_width - current_num_display_width - 1
    if padding_needed < 0 then padding_needed = 0 end -- Ensure non-negative padding
    line_num_content = string.rep(" ", padding_needed) .. tostring(num) .. " "
  else
    -- Virtual lines: fill with spaces to the effective slot width
    line_num_content = string.rep(" ", effective_lnum_slot_width)
  end


  -- --- END MODIFICATIONS ---

  -- Concatenate final content: Left signs -> Line number -> Separator -> Right signs
  -- local separator_hl_group = git_sign_hl_group or "LineNr"
  local separator_hl_group = "LineNr"
  -- local separator = "%#" .. separator_hl_group .. "#┃%*"
  local separator = "%#" .. separator_hl_group .. "#│%*"
  local ret = left_content .. line_num_content .. separator .. right_content

  -- Add fold click area: clicking the entire status column triggers fold toggle (za command)
  -- return "%@v:lua.require'snacks.statuscolumn'.click_fold@" .. ret .. "%T"
  return "%@v:lua.require'" .. CURRENT_MODULE_PATH .. "'.click_fold@" .. ret .. "%T"
end

function M.get()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype == "nofile" then
    -- local key = ("% d:% d:% d:% d:% d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
    -- cache[key] = "" -- 缓存空结果
    return ""
  end

  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
  if cache[key] then
    return cache[key]
  end
  local ok, ret = pcall(M._get)
  if ok then
    cache[key] = ret
    return ret
  end
  return ""
end

-- function M.health()
--   local ready = vim.o.statuscolumn:find("snacks.statuscolumn", 1, true)
--   if config.enabled and not ready then
--     Snacks.health.warn(("is not configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
--   elseif not config.enabled and ready then
--     Snacks.health.ok(("is manually configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
--   end
-- end

-- 获取当前文件的模块路径
local function get_current_module_name()
  -- 获取当前脚本的文件路径（移除开头的@符号）
  local info = debug.getinfo(1, "S")
  local file_path = info.source:gsub("^@", "") -- 例如: "/Users/.../lua/config/hl_patch.lua"

  -- 直接获取runtimepath列表（表类型，无需转字符串）
  local rtp = vim.opt.rtp:get() -- 返回路径数组，如 { "/path1", "/path2", ... }

  local module_base_path = ""

  -- 遍历rtp中的每个路径，寻找最长匹配的lua目录前缀
  for _, rtp_path in ipairs(rtp) do
    -- 模块通常位于rtp路径下的lua子目录中
    local lua_dir = rtp_path .. "/lua/" -- 例如: "/Users/.../nvim/lua/"

    -- 检查文件路径是否以当前lua_dir为前缀（精确匹配，不解析模式）
    if file_path:find(lua_dir, 1, true) == 1 then
      -- 保留最长的匹配路径（避免子目录被误判）
      if #lua_dir > #module_base_path then
        module_base_path = lua_dir
      end
    end
  end

  -- 提取模块名
  if module_base_path ~= "" then
    -- 1. 移除lua目录前缀（如从"/Users/.../lua/config/hl_patch.lua"得到"config/hl_patch.lua"）
    -- 2. 移除.lua后缀（得到"config/hl_patch"）
    -- 3. 将路径分隔符替换为.（得到"config.hl_patch"）
    local module_name = file_path
        :gsub(module_base_path, "")
        :gsub("%.lua$", "")
        :gsub("/", ".")
        :gsub("\\", ".") -- 兼容Windows路径

    return module_name
  end

  -- 未找到匹配时的容错
  vim.notify("无法推断模块名：文件不在runtimepath的lua目录中\n文件路径：" .. file_path, vim.log.levels.WARN)
  return "unknown_module"
end

-- 获取当前模块名，存储起来以便后续使用
CURRENT_MODULE_PATH = get_current_module_name()

-- click_fold 函数作为 M 的一个方法
function M.click_fold()
  local pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd("normal! za")
    end
  end)
end

return M
