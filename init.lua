-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line/column your cursor is on
vim.opt.cursorline = true
vim.opt.cuc = true
vim.opt.colorcolumn = '80,100'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_set_keymap('n', '<C-x>', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', ':bn<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Left>', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Right>', ':bn<CR>', { noremap = true, silent = true })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.o.showtabline = 2 -- Always show the tabline

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- clear all harpoon marks
-- :lua require("harpoon.mark").clear_all()

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'sitiom/nvim-numbertoggle',
    lazy = false,
  },

  {
    'kana/vim-textobj-user',
    dependencies = { 'kana/vim-textobj-indent' },
    event = 'VeryLazy', -- Load the plugin lazily for better startup performance
    config = function()
      -- Key mappings for region expanding
      vim.api.nvim_set_keymap('o', 'iI', '<Plug>(textobj-indent-i)', { silent = true })
      vim.api.nvim_set_keymap('o', 'aI', '<Plug>(textobj-indent-a)', { silent = true })
      vim.api.nvim_set_keymap('x', 'iI', '<Plug>(textobj-indent-i)', { silent = true })
      vim.api.nvim_set_keymap('x', 'aI', '<Plug>(textobj-indent-a)', { silent = true })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight',
          -- theme = 'gruvbox',
          section_separators = { left = '', right = '' }, -- Fancy separators
          component_separators = { left = '', right = '' },
          icons_enabled = true,
        },
        sections = {
          lualine_a = { 'mode' }, -- Current mode (e.g., NORMAL, INSERT)
          lualine_b = { 'branch', 'diff', 'diagnostics' }, -- Git branch, changes, diagnostics
          lualine_c = { 'filename' }, -- Current filename
          lualine_x = { 'encoding', 'fileformat', 'filetype' }, -- Encoding, format, file type
          lualine_y = { 'progress' }, -- Progress (percentage through the file)
          lualine_z = { 'location' }, -- Cursor location (line/column)
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' }, -- Show only the filename in inactive windows
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {}, -- Add a custom tabline if needed
        extensions = { 'fugitive', 'nvim-tree' }, -- Support for plugins like Git and file explorer
      }
    end,
  },

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        numbers = function(number_opts)
          return number_opts.ordinal -- Display bufferline position
        end,
        name_formatter = function(buf)
          local harpoon = require 'harpoon'
          local marks = harpoon.get_mark_config().marks

          -- Get the buffer's filename (last part of the path)
          local buf_filename = vim.fn.fnamemodify(buf.path, ':t') -- Extract the filename
          local tab_name = buf_filename -- Default to the filename
          local harpoon_index = nil

          -- Debug: buffer filename
          -- print('[DEBUG Bufferline] Buffer Filename:', buf_filename)

          -- Cross-reference Harpoon marks
          for i, mark in ipairs(marks) do
            local mark_abs_path = vim.fn.resolve(vim.fn.fnamemodify(mark.filename, ':p')) -- Normalize Harpoon's path
            local buf_abs_path = vim.fn.resolve(vim.fn.fnamemodify(buf.path, ':p')) -- Normalize Bufferline's path

            -- Debug: Harpoon mark absolute path
            -- print('[DEBUG Bufferline] Harpoon Mark Absolute Path:', mark_abs_path)
            -- print('[DEBUG Bufferline] Buffer Absolute Path:', buf_abs_path)

            if mark_abs_path == buf_abs_path then
              harpoon_index = i
              break
            end
          end

          -- Update the tab name if a Harpoon index is found
          if harpoon_index then
            tab_name = buf_filename .. ' *' .. harpoon_index .. ''
          end

          -- Debug: final tab name
          -- print('[DEBUG Bufferline] Final Tab Name:', tab_name)
          return tab_name
        end,
        always_show_bufferline = true, -- Ensures Bufferline is always visible
        close_command = 'bdelete! %d', -- Command to close a buffer
        right_mouse_command = 'bdelete! %d', -- Close buffer with right-click
        left_mouse_command = 'buffer %d', -- Go to buffer with left-click
        middle_mouse_command = nil, -- Disable middle-click action
        indicator = {
          style = 'bold', -- Style of the active buffer indicator
        },
        buffer_close_icon = '', -- Icon for closing buffers
        modified_icon = '●', -- Icon for modified buffers
        close_icon = '', -- Icon for closing the tabline
        separator_style = 'thin', -- Options: "slant", "thick", "thin", etc.
        diagnostics = 'nvim_lsp', -- Show diagnostics from LSP
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
      },
    },
    keys = {
      { '<leader>bn', ':BufferLineCycleNext<CR>', desc = 'Next Buffer' },
      { '<leader>bp', ':BufferLineCyclePrev<CR>', desc = 'Previous Buffer' },
      { '<leader>bc', ':BufferLinePickClose<CR>', desc = 'Pick Buffer to Close' },
      { '<leader>bo', ':BufferLineCloseOthers<CR>', desc = 'Close Other Buffers' },
      { '<A-1>', '<cmd>BufferLineGoToBuffer 1<CR>', desc = 'Go to Buffer 1' },
      { '<A-2>', '<cmd>BufferLineGoToBuffer 2<CR>', desc = 'Go to Buffer 2' },
      { '<A-3>', '<cmd>BufferLineGoToBuffer 3<CR>', desc = 'Go to Buffer 3' },
      { '<A-4>', '<cmd>BufferLineGoToBuffer 4<CR>', desc = 'Go to Buffer 4' },
      { '<A-5>', '<cmd>BufferLineGoToBuffer 5<CR>', desc = 'Go to Buffer 5' },
      { '<A-6>', '<cmd>BufferLineGoToBuffer 6<CR>', desc = 'Go to Buffer 6' },
      { '<A-7>', '<cmd>BufferLineGoToBuffer 7<CR>', desc = 'Go to Buffer 7' },
      { '<A-8>', '<cmd>BufferLineGoToBuffer 8<CR>', desc = 'Go to Buffer 8' },
    },
  },

  -- HARPOON
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {}, -- Harpoon doesn't require specific setup
    config = function()
      local harpoon_mark = require 'harpoon.mark'
      local harpoon_ui = require 'harpoon.ui'
      local bufferline = require 'bufferline'

      -- Setup Harpoon
      require('harpoon').setup()

      -- Helper function to force Bufferline refresh by simulating re-render
      local function force_bufferline_refresh()
        vim.cmd 'redrawtabline' -- Force the tabline to redraw
      end

      -- Wrapper function to add a mark and refresh Bufferline
      local function add_mark()
        local current_file = vim.fn.expand '%:p'
        harpoon_mark.add_file(current_file)

        -- Force Bufferline refresh
        force_bufferline_refresh()
      end

      -- Wrapper function to remove the current mark and refresh Bufferline
      local function remove_mark()
        local current_file = vim.fn.expand '%:p'

        -- Remove the mark for the current file
        harpoon_mark.rm_file(current_file)

        -- Fetch marks directly from the Harpoon configuration
        local marks = require('harpoon').get_mark_config().marks or {}

        -- Clean up leftover `(empty)` marks without resetting IDs
        for i = #marks, 1, -1 do -- Iterate backwards to safely remove entries
          if marks[i].filename == '(empty)' then
            table.remove(marks, i)
          end
        end

        -- Force Bufferline refresh
        force_bufferline_refresh()
      end

      -- Keybindings
      vim.keymap.set('n', '<leader>a', add_mark, { desc = 'Harpoon Add File and Refresh' })
      vim.keymap.set('n', '<leader>h', harpoon_ui.toggle_quick_menu, { desc = 'Harpoon Quick Menu' })
      vim.keymap.set('n', '<leader>r', remove_mark, { desc = 'Harpoon Remove File and Refresh' })

      vim.keymap.set('n', '<leader>1', function()
        harpoon_ui.nav_file(1)
      end, { desc = 'Harpoon Select File 1' })
      vim.keymap.set('n', '<leader>2', function()
        harpoon_ui.nav_file(2)
      end, { desc = 'Harpoon Select File 2' })
      vim.keymap.set('n', '<leader>3', function()
        harpoon_ui.nav_file(3)
      end, { desc = 'Harpoon Select File 3' })
      vim.keymap.set('n', '<leader>4', function()
        harpoon_ui.nav_file(4)
      end, { desc = 'Harpoon Select File 4' })

      vim.keymap.set('n', '<C-S-P>', harpoon_ui.nav_prev, { desc = 'Harpoon Previous Buffer' })
      vim.keymap.set('n', '<C-S-N>', harpoon_ui.nav_next, { desc = 'Harpoon Next Buffer' })
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<c-\>]], -- Default toggle mapping
      direction = 'float',
      size = 20, -- for horizontal/vertical
      float_opts = { -- for floating
        border = 'curved',
        -- width = 80,
        -- height = 25,
      },
    },
    keys = {
      { '<Leader>t', ':ToggleTerm<CR>', mode = 'n', silent = true, desc = '[T]oggle Terminal' },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = 'float',
        -- width = 40,
        -- height = 20,
        mappings = {
          ['<space>'] = 'none',
        },
      },
    },
    keys = {
      { '<leader>e', ':Neotree filesystem toggle<CR>', desc = '[E]xplorer (NeoTree Float)' },
    },
  },

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    -- 'gruvbox-community/gruvbox',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.colorscheme 'gruvbox'

      -- Make sure this runs after your colorscheme loads
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          local cursorline_bg = vim.api.nvim_get_hl(0, { name = 'CursorLine' }).bg
          local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

          -- Reapply the highlights with priorities
          vim.api.nvim_set_hl(0, 'CursorLine', { bg = cursorline_bg, priority = 1 })
          vim.api.nvim_set_hl(0, 'ColorColumn', { bg = normal_bg, blend = 5, priority = 0 })
        end,
      })
      vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorLine' })

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('todo-comments').setup {
        keywords = {
          TODO = { icon = ' ', color = 'info', alt = { 'TBD' } }, -- Icon and alternatives
          FIX = { icon = ' ', color = 'error', alt = { 'BUG', 'FIXME' } },
          HACK = { icon = ' ', color = 'warning' },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
          NOTE = { icon = '★', color = 'hint' },
          PERF = { icon = '⏱', color = 'hint' },
          ATTN = { icon = '❗', color = 'critical' },
        },
        highlight = {
          before = 'fg', -- Highlight the keyword before the text
          keyword = 'wide', -- Highlight the whole keyword
          after = 'fg', -- Highlight the text after the keyword
          pattern = [[.*<(KEYWORDS)\s*:]], -- Pattern to match keywords
        },
        colors = {
          error = { 'DiagnosticError', '#DC2626' },
          critical = { 'ErrorMsg', '#FF0000' },
          warning = { 'DiagnosticWarn', '#FBBF24' },
          info = { 'DiagnosticInfo', '#2563EB' },
          hint = { 'DiagnosticHint', '#10B981' },
          default = { 'Identifier', '#7C3AED' },
        },
        search = {
          command = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
          },
          pattern = [[\b(KEYWORDS):]], -- Match pattern
        },
      }

      -- Keymaps for navigating and searching TODOs
      vim.keymap.set('n', ']t', function()
        require('todo-comments').jump_next()
      end, { desc = 'Next TODO comment' })

      vim.keymap.set('n', '[t', function()
        require('todo-comments').jump_prev()
      end, { desc = 'Previous TODO comment' })

      vim.keymap.set('n', '<leader>td', ':TodoTelescope<CR>', { desc = '[T]ODO [D]isplay with Telescope' })
      vim.keymap.set('n', '<leader>tt', ':TodoQuickFix<CR>', { desc = '[T]ODO [T]o Quickfix List' })
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Make sure this runs after your colorscheme loads
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    local cursorline_bg = vim.api.nvim_get_hl(0, { name = 'CursorLine' }).bg
    local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

    -- Reapply the highlights with priorities
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = cursorline_bg, priority = 1 })
    vim.api.nvim_set_hl(0, 'ColorColumn', { bg = normal_bg, blend = 3, priority = 0 })
  end,
})

-- Turn off syntax & treesitter highlight for files larger than ~256 KB
-- and enable lazyredraw for remote performance
vim.opt.lazyredraw = true
vim.api.nvim_create_autocmd('BufReadPre', {
  callback = function(args)
    local file = args.file
    local size = vim.fn.getfsize(file)
    if size > 262144 then
      vim.cmd('syntax off')
      if pcall(vim.cmd, 'TSBufDisable highlight') then end
    end
  end,
})
