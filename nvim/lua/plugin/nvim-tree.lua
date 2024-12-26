-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
-- 	print("NOT OK_2")
--     return
-- end
-- print("OK_2")

-- local tree_cb = nvim_tree_config.nvim_tree_callback

local function my_on_attach(bufnr)
    local api_status_ok, api = pcall(require, "nvim-tree.api")

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- copy default mappings here from defaults in next section
    -- vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
    -- vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
    -- ---
    -- OR use all default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- remove a default
    vim.keymap.del('n', '>', { buffer = bufnr })
    vim.keymap.del('n', '<', { buffer = bufnr })

    -- override a default
    -- vim.keymap.set('n', '<C-e>', api.tree.reload,                       opts('Refresh'))

    -- add your mappings
    -- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    ---
  end


nvim_tree.setup {
	on_attach = my_on_attach,
    disable_netrw = true,
    hijack_netrw = true,
--     open_on_setup = false,
--    ignore_ft_on_setup = {
--        "startify",
--        "dashboard",
--        "alpha",
--    },
	-- auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 30,
--        height = 30,
        side = "left",
--        auto_resize = true,
--        mappings = {
--            custom_only = false,
--            list = {
--            { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
--            { key = "h", cb = tree_cb "close_node" },
--            { key = "v", cb = tree_cb "vsplit" },
--            },
--        },
        number = false,
        relativenumber = false,
    },
    actions = {
		open_file = {
			quit_on_open = true,
			window_picker = { enable = true },
		},
    },
    renderer = {
        highlight_git = true,
        root_folder_label = false,
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    untracked = "U",
                    ignored = "◌",
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            }
        }
    }
}
