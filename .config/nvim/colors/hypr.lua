-- Hyprland-aware colorscheme for Neovim
-- Reads ~/.config/hypr/hyprland/colors.conf and maps a minimal palette to Neovim highlights
-- Colors are derived from:
--   - misc.background_color      -> bg
--   - plugin.hyprbars.col.text   -> fg (fallbacks if missing)
--   - general.col.active_border  -> accent
--   - general.col.inactive_border-> muted

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function parse_hypr_color(token)
  -- token examples: "rgba(1a110fFF)", "rgb(f1dfda)"
  if not token then return nil end
  token = token:lower()
  local hex = token:match("%((%x+)%)")
  if not hex then return nil end
  if #hex >= 6 then
    return "#" .. hex:sub(1, 6)
  end
  return nil
end

local function clamp(n, lo, hi)
  if n < lo then return lo end
  if n > hi then return hi end
  return n
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16) or 0
  local g = tonumber(hex:sub(3, 4), 16) or 0
  local b = tonumber(hex:sub(5, 6), 16) or 0
  return r, g, b
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", clamp(r, 0, 255), clamp(g, 0, 255), clamp(b, 0, 255))
end

local function blend(hex1, hex2, p)
  -- blend hex1 towards hex2 by factor p (0..1)
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  local r = r1 + (r2 - r1) * p
  local g = g1 + (g2 - g1) * p
  local b = b1 + (b2 - b1) * p
  return rgb_to_hex(math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

-- Load Hyprland colors
local colors_conf = (os.getenv("HOME") or "") .. "/.config/hypr/hyprland/colors.conf"
local content = read_file(colors_conf) or ""

local function match_color(pattern)
  local token = content:match(pattern)
  return parse_hypr_color(token)
end

local bg     = match_color("background_color%s*=%s*(rgba?%b())")
local text   = match_color("col%.text%s*=%s*(rgba?%b())")
local accent = match_color("col%.active_border%s*=%s*(rgba?%b())")
local muted  = match_color("col%.inactive_border%s*=%s*(rgba?%b())")

-- Fallbacks if some keys are not present
bg     = bg     or "#1a110f"
text   = text   or "#f1dfda"
accent = accent or "#a38b85"
muted  = muted  or "#55423d"

-- Prepare
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "hypr"

local function hi(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

-- Basic UI
hi("Normal",        { fg = text,  bg = bg })
hi("NormalFloat",   { fg = text,  bg = bg })
hi("FloatBorder",   { fg = accent, bg = bg })
hi("WinSeparator",  { fg = muted, bg = bg })
hi("LineNr",        { fg = blend(muted, bg, 0.3), bg = bg })
hi("CursorLine",    { bg = blend(bg, "#ffffff", 0.06) })
hi("CursorLineNr",  { fg = accent, bold = true })
hi("SignColumn",    { bg = bg })

-- Statusline & Tabline
hi("StatusLine",    { fg = text,  bg = blend(bg, "#000000", 0.20) })
hi("StatusLineNC",  { fg = blend(text, bg, 0.5), bg = blend(bg, "#000000", 0.10) })
hi("TabLineSel",    { fg = bg, bg = accent, bold = true })
hi("TabLine",       { fg = text, bg = blend(bg, "#000000", 0.12) })
hi("TabLineFill",   { bg = bg })

-- Popups & Menus
hi("Pmenu",         { fg = text,  bg = blend(bg, "#000000", 0.18) })
hi("PmenuSel",      { fg = bg,    bg = accent, bold = true })
hi("PmenuSbar",     { bg = blend(bg, "#000000", 0.22) })
hi("PmenuThumb",    { bg = accent })

-- Search & Visual
hi("Search",        { fg = bg, bg = accent })
hi("IncSearch",     { fg = bg, bg = accent, bold = true })
hi("Visual",        { bg = blend(accent, "#ffffff", 0.25) })

-- Diagnostics
hi("DiagnosticError", { fg = "#ff6b6b" })
hi("DiagnosticWarn",  { fg = "#e5c07b" })
hi("DiagnosticInfo",  { fg = blend(accent, "#ffffff", 0.15) })
hi("DiagnosticHint",  { fg = blend(accent, "#000000", 0.15) })

-- Git signs
hi("DiffAdd",       { fg = "#7ad77a", bg = blend(bg, "#00ff00", 0.04) })
hi("DiffChange",    { fg = "#61afef", bg = blend(bg, "#00aaff", 0.04) })
hi("DiffDelete",    { fg = "#e06c75", bg = blend(bg, "#ff0000", 0.04) })
hi("DiffText",      { fg = "#c678dd", bg = blend(bg, "#aa00ff", 0.06) })

-- LSP references
hi("LspReferenceText",  { bg = blend(bg, "#ffffff", 0.08) })
hi("LspReferenceRead",  { bg = blend(bg, "#ffffff", 0.08) })
hi("LspReferenceWrite", { bg = blend(bg, "#ffffff", 0.08) })

-- Titles & Messages
hi("Title",         { fg = accent, bold = true })
hi("MoreMsg",       { fg = accent, bold = true })
hi("WarningMsg",    { fg = "#ffcc00", bold = true })
hi("ErrorMsg",      { fg = "#ff5555", bold = true })

