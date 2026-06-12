local assets = require("./../assets/assets") ---@type FOXChess.Assets

---@class FOXChess.Common
local common = {}

---Creates a square using sprite tasks
---@param root ModelPart
---@param width number
---@param color Vector3|Vector4?
function common.square(root, width, color)
	for i = 0, 1 do
		root:newSprite(i .. "")
			:texture(assets.textures.Black, 16, 16)
			:renderType("LINES")
			:color(color)

			:size(1, 1)
			:pos(width / 2, 0, width / 2)
			:rot(-90 * (i * 2 - 1), -90 * i, 0)
			:scale(width)
	end
end

---@type table<string, boolean>
local was_pressed = {}

---Returns if the viewer is started swinging or using an item
---@param entity Player|LivingEntity
---@return boolean
function common.press(entity)
	local uuid = entity:getUUID()

	local is_pressed = entity:isSwingingArm() or entity:isUsingItem()
	if was_pressed[uuid] == is_pressed then return false end

	was_pressed[uuid] = is_pressed

	return is_pressed
end

return common
