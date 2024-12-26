local status_ok, markdown = pcall(require, "bufferline")
if not status_ok then
  return
end

markdown.setup {
	options = {
		auto_start = 0,
		auto_close = 1,
		refresh_slow = 0,
		command_for_global = 0,
		open_to_the_world = 0,
		open_ip = '',
		browser = '',
		echo_preview_url = 0,
		browserfunc = '',
		preview_options = {
		mkit = {},
		katex = {},
		uml = {},
		maid = {},
		disable_sync_scroll = 0,
		sync_scroll_type = 'middle',
		hide_yaml_meta = 1,
		sequence_diagrams = {},
		flowchart_diagrams = {},
		content_editable = false,
		disable_filename = 0,
		toc = {}
		},
		markdown_css = '',
		highlight_css = '',
		port = '',
		page_title = '「${name}」',
		images_path = '/home/user/.markdown_images',
		filetypes = { 'markdown' },
		theme = 'dark',
		combine_preview = 0,
		combine_preview_auto_refresh = 1
	},
}
