local Snacks = require("snacks")

---@class snacks.statuscolumn
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

---@alias snacks.statuscolumn.Component "mark"|"sign"|"fold"|"git"
---@alias snacks.statuscolumn.Components snacks.statuscolumn.Component[]|fun(win:number,buf:number,lnum:number):snacks.statuscolumn.Component[]

---@class snacks.statuscolumn.Config
---@field left snacks.statuscolumn.Components
---@field right snacks.statuscolumn.Components
---@field enabled? boolean
local defaults = {
  left = { "git", "sign" }, -- priority of signs on the left (high to low)
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

-- local config = Snacks.config.get("statuscolumn", defaults)
local config = defaults

---@private
---@alias snacks.statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias snacks.statuscolumn.Sign {name:string, text:string, texthl:string, priority:number, type:snacks.statuscolumn.Sign.type}

-- Cache for signs per buffer and line
---@type table<number,table<number,snacks.statuscolumn.Sign[]>>
local sign_cache = {}
local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>

local did_setup = false

---@private
function M.setup()
  if did_setup then
    return
  end
  did_setup = true
  Snacks.util.set_hl({
    Mark = "DiagnosticHint",
    Separator = { fg = "#555555" } -- 分隔线高亮（深灰色，可调整）
  }, { prefix = "SnacksStatusColumn", default = true })
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
---@return table<number, snacks.statuscolumn.Sign[]>
---@param buf number
function M.buf_signs(buf)
  -- Get regular signs
  ---@type table<number, snacks.statuscolumn.Sign[]>
  local signs = {}

  if vim.fn.has("nvim-0.10") == 0 then
    -- Only needed for Neovim <0.10
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*" })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as snacks.statuscolumn.Sign]]
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
      table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "SnacksStatusColumnMark", type = "mark" })
    end
  end

  return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@private
---@param win number
---@param buf number
---@param lnum number
---@return snacks.statuscolumn.Sign[]
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
---@param sign? snacks.statuscolumn.Sign
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
---@return string
function M._get()
  -- 检查是否已初始化，如果未初始化则执行 setup 函数
  -- setup 函数主要用于设置高亮组和定时刷新缓存
  if not did_setup then
    M.setup()
  end

  -- 获取当前状态行所属窗口的 ID（用于后续获取窗口配置）
  local win = vim.g.statusline_winid

  -- 获取当前窗口的行号显示配置：
  -- nu: 是否显示绝对行号
  -- rnu: 是否显示相对行号
  local nu = vim.wo[win].number
  local rnu = vim.wo[win].relativenumber

  -- 决定是否显示符号列：
  -- 仅当不是虚拟行（vim.v.virtnum == 0）且符号列配置不是 "no" 时显示
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"

  -- 初始化组件数组：
  -- components[1]: 左侧内容（如折叠符号、标记等）
  -- components[2]: 中间内容（行号）
  -- components[3]: 右侧内容（如 git 符号等）
  local components = { "", "", "" }
  -- 如果不需要显示符号列且不显示行号，则返回空字符串（不渲染状态列）
  if not (show_signs or nu or rnu) then
    return ""
  end

  -- 1. 处理行号区域 (middle)
  local line_num_content = ""
  -- 仅在显示行号且当前行为实际行（非虚拟行）时生成行号内容
  if (nu or rnu) and vim.v.virtnum == 0 then
    local num ---@type number
    -- 根据相对行号和绝对行号的配置，确定当前行应显示的数字：
    -- - 当同时开启相对行号和绝对行号，且当前行为光标所在行（relnum == 0）时，显示绝对行号
    -- - 当仅开启相对行号时，显示相对行号
    -- - 当仅开启绝对行号时，显示绝对行号
    if rnu and nu and vim.v.relnum == 0 then
      num = vim.v.lnum   -- 光标行显示绝对行号
    elseif rnu then
      num = vim.v.relnum -- 非光标行显示相对行号
    else
      num = vim.v.lnum   -- 仅显示绝对行号
    end
    -- 行号内容使用 "%=" 实现右对齐，后面加空格与分隔线分隔
    line_num_content = "%=" .. num .. " "
  else
    -- 虚拟行（如折叠行）用 4 个空格占位，确保与实际行的行号区域宽度一致（保证对齐）
    line_num_content = string.rep(" ", 4)
  end

  -- 2. 处理左侧内容（折叠符号等, left）
  local left_content = ""
  if show_signs then -- 仅当需要显示符号列时处理
    -- 获取当前窗口关联的缓冲区 ID
    local buf = vim.api.nvim_win_get_buf(win)
    -- 判断当前缓冲区是否为普通文件（非终端、非 quickfix 等特殊缓冲区）
    local is_file = vim.bo[buf].buftype == ""
    -- 获取当前行的所有符号（折叠符号、git 符号等）
    local signs = M.line_signs(win, buf, vim.v.lnum)

    -- 解析左右侧的组件配置：如果是函数则执行获取动态列表，否则直接使用配置的列表
    local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left
    local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right

    -- If there are signs, we'll try to find the icons for the configured components.
    -- If no sign is found for a component type, it will be represented by spaces.
    -- We want to show all configured left signs, each in its own two-character slot.
    for _, comp_type in ipairs(left_c) do
      local found_sign = nil
      for _, s in ipairs(signs) do
        if s.type == comp_type then
          found_sign = s
          break -- Found the highest priority sign for this type
        end
      end

      -- If configured to use Git highligh for folds and we found a fold sign,
      -- and there's a git sign, apply the git sign's highlight to the fold sign.
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

    -- Handle the right-side components similarly, but only for file buffers.
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
        components[3] = components[3] .. M.icon(found_sign)
      end
    end
  else
    -- If not showing signs, ensure the left side has a consistent width for potential signs.
    -- This assumes each configured left component will take 2 characters.
    left_content = string.rep("  ", #config.left)
  end

  -- 3. 拼接最终内容：左侧符号 → 行号 → 分隔线 → 右侧内容
  -- 分隔线使用专门的高亮组（SnacksStatusColumnSeparator），默认字符为 "│"
  local separator = "%#LineNr#│%*"
  local ret = left_content .. line_num_content .. separator .. components[3]

  -- 添加折叠点击区域：点击整个状态列时触发折叠切换（za 命令）
  -- %@...@ 定义点击区域，%T 结束点击区域定义
  return "%@v:lua.require'snacks.statuscolumn'.click_fold@" .. ret .. "%T"
end

function M.get()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
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

---@private
function M.health()
  local ready = vim.o.statuscolumn:find("snacks.statuscolumn", 1, true)
  if config.enabled and not ready then
    Snacks.health.warn(("is not configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
  elseif not config.enabled and ready then
    Snacks.health.ok(("is manually configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
  end
end

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
