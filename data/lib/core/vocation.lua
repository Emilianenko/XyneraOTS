function Vocation:getBase()
	local base = self
	while base:getDemotion() do
		base = base:getDemotion()
	end
	return base
end

local promotions = {}
for vocId, voc in pairs(Game.getVocations()) do
	local demotion = voc:getDemotion()
	if demotion then
		demotion = demotion:getId()
		if not promotions[demotion] then
			promotions[demotion] = {}
		end
		
		promotions[demotion][#promotions[demotion] + 1] = vocId		
	else
		promotions[vocId] = {}
	end
end

function Vocation:getAllPromotions()
	if self:getId() ~= self:getBase():getId() then
		return
	end
	
	return promotions[self:getId()]
end