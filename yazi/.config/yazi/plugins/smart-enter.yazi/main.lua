--- @sync entry
return {
	entry = function()
		local h = cx.active.current.hovered
		ya.dbg("smart-enter: hovered =", h and h.url or "nil")
		if h then
			ya.dbg("smart-enter: is_dir =", tostring(h.cha.is_dir))
			if h.cha.is_dir then
				ya.emit("enter", {})
			else
				ya.emit("open", { hovered = true })
			end
		else
			ya.err("smart-enter: no hovered item")
		end
	end,
}
