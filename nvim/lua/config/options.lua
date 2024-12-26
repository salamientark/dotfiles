-- :help options
vim.opt.autoread = true			-- Read again file when changed outside of nvim
vim.opt.backup = false			-- Create a backup file
vim.opt.clipboard = "unnamedplus"	-- Allow nvim to access to the system clipboard
vim.opt.cmdheight = 2			-- More space in neovim cmd line  
vim.opt.conceallevel = 0		-- so that `` is visible in markdown files
vim.opt.cursorline = true 		-- highlight the current line
vim.opt.expandtab = false		-- convert tab to space 
vim.opt.fileencoding = "utf-8"		-- the encoding written to a file
vim.opt.guifont = "monospace:h17"	-- the font used in graphical neovim applications
vim.opt.hlsearch = true			-- highlight all matches on previous search pattern
vim.opt.ignorecase = true		-- ignore case in search patterns
vim.opt.langmenu = "en_US.UTF-8"	-- Change neovim menu language to english 
vim.opt.mouse = "a"			-- allow the mouse to be used in neovim
vim.opt.number = true			-- set numbered lines
vim.opt.numberwidth = 4			-- set number column width to 2 {default 4}
vim.opt.relativenumber = true		-- set relative numbered lines
vim.opt.pumheight = 10			-- pop up menu height
vim.opt.scrolloff = 8			-- minimum nbr of line above and below cursor 
vim.opt.sidescrolloff = 8		-- minimum nbr of columns on left & right of cursor 
vim.opt.shiftwidth = 4			-- the number of spaces inserted for each indentation
-- vim.opt.showmode = false		-- disable mode information like -- INSERT --
vim.opt.showtabline = 2			-- always show tabs
vim.opt.signcolumn = "yes:1"		-- always show the sign column
vim.opt.smartcase = true		-- smart case
vim.opt.smartindent = true		-- make indenting smarter again
vim.opt.smarttab = true			-- When at the beginning of the line insert shiftwidth tab
vim.opt.softtabstop = 4			-- number of space a tab count for in Editing mode
vim.opt.splitbelow = true		-- force horizontal splits to go below current window
vim.opt.splitright = true		-- force vertical splits to go to the right of current window
vim.opt.swapfile = false		-- creates a swapfile
vim.opt.termguicolors = true		-- set term gui colors (most terminals support this)
vim.opt.tabstop = 4			-- number of spac ea tab counbt for
vim.opt.timeoutlen = 1000		-- time (ms) to wait for a mapped sequence to complete
vim.opt.undofile = true			-- enable persistent undo
vim.opt.updatetime = 300		-- faster completion (4000ms default)
vim.opt.wrap = false			-- display lines as one long line
vim.opt.writebackup = false		-- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- nvim.UFO config
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- vim.opt.shortmess:append "c"		-- Don't know what it does
