local status_ok, opencode = pcall(require, "opencode")
if not status_ok then
	return
end

opencode.setup()
