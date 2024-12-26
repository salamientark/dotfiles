local colorscheme = "onedark"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not_found!")
	-- Set retrobox as default colorscheme if no one found 
	vim.cmd("colorscheme retrobox")
	return
end
