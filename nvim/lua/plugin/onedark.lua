local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
	return
end

onedark.setup{
	style = 'deep', -- 'dark' | 'darker' | 'cool' | 'deep' | 'warm' | 'warmer'
}
