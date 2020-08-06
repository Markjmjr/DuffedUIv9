local D, C, L = unpack(select(2, ...)) 
if not C['chat']['enable'] then return end

local numlines = 2
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i=1, numlines do self:ScrollDown() end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, numlines do self:ScrollUp() end
		end
	end
end
