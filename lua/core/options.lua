local api = vim.api
local opt = vim.opt

opt.termguicolors = true
opt.hidden = true
opt.magic = true
opt.virtualedit = 'block'
opt.clipboard = 'unnamedplus'
opt.wildignorecase = true
opt.swapfile = false

opt.history = 2000
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true
opt.cursorline = true

if vim.fn.executable('rg') == 1 then
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

opt.completeopt = 'menu,menuone,noinsert'
opt.showmode = false
opt.shortmess = 'aoOTIcF'
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.ruler = false
opt.showtabline = 0
opt.winwidth = 30
opt.pumheight = 15
opt.showcmd = false

opt.cmdheight = 0
opt.laststatus = 3
opt.list = true

opt.listchars = 'tab:»·,nbsp:+,trail:·,extends:→,precedes:←'
opt.pumblend = 10
opt.winblend = 0
opt.undofile = true

opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2

opt.foldlevelstart = 99
opt.foldmethod = 'marker'

opt.splitright = true
opt.wrap = false

opt.number = true
opt.signcolumn = 'yes'
opt.spelloptions = 'camel'

opt.textwidth = 100
opt.colorcolumn = '100'

local function get_signs()
  local buf = api.nvim_get_current_buf()
  return vim
    .iter(api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = 'sign' }))
    :filter(function(item)
      return item[2] == vim.v.lnum - 1
    end)
    :map(function(item)
      return item[4]
    end)
    :totable()
end

function _G.show_stc()
  local sign = '  '
  local gitsign = '  '
  for _, s in ipairs(get_signs()) do
    if s.sign_hl_group:find('GitSign') then
      gitsign = '%#' .. s.sign_hl_group .. '#' .. s.sign_text .. '%*'
    else
      sign = '%#' .. s.sign_hl_group .. '#' .. s.sign_text .. '%*'
    end
  end

  local function show_break()
    if vim.v.virtnum > 0 then
      return (' '):rep(math.floor(math.ceil(math.log10(vim.v.lnum))) - 1) .. '↳'
    elseif vim.v.virtnum < 0 then
      return ''
    else
      return vim.v.lnum
    end
  end

  return sign .. '%=' .. show_break() .. gitsign
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    vim.wo[vim.api.nvim_get_current_win()].stc = [[%!v:lua.show_stc()]]
  end,
})

if vim.uv.os_uname().sysname == 'Darwin' then
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
end
