---@class FOXChess.Model
---@field Board ModelPart
---@field Pawn ModelPart
---@field Bishop ModelPart
---@field Knight ModelPart
---@field Rook ModelPart
---@field Queen ModelPart
---@field King ModelPart

---@class FOXChess.Assets
---@field model FOXChess.Model
local assets = {
	model = models --[[@as FOXChess.Model]],
	world = models:newPart("chess_world", "World"):scale(16),
	textures = {
		Black = textures:fromVanilla("chess_black", "textures/block/stripped_dark_oak_log.png"),
		White = textures:fromVanilla("chess_white", "textures/block/stripped_birch_log.png")
	},
}

for w in string.gmatch(... .. ".model", "[^./]+") do
	assets.model = assets.model[w] --[[@as FOXChess.Model]]
end

---@type table<string, function>
local pressed = {}
function events.world_tick()
	for _, func in pairs(pressed) do
		func()
	end
end

---TODO Move this elsewhere or rename this script
---@param entity Player|LivingEntity
function assets.press(entity)
	local uuid = entity:getUUID()

	if pressed[uuid] then return end
	if entity:isSwingingArm() or entity:isUsingItem() then
		pressed[uuid] = function()
			if entity:isSwingingArm() or entity:isUsingItem() then return end
			pressed[uuid] = nil
		end
		return true
	end
end

return assets
