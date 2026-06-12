local assets = require("./../assets/assets") ---@type FOXChess.Assets

---@class FOXChess.Hitbox
local hitbox = {}

---Attaches a chess board hitbox to an entity or player
---
---When this entity or player swings, the chess board will be placed at the hitbox's position, and the hitbox will be removed
---@param entity Player|LivingEntity
---@param board FOXChess.Board
function hitbox.new(entity, board)
	local part = assets.world:newPart("Hitbox")
	part:newSprite("ns")
		:texture(assets.textures.Black, 16, 16)
		:renderType("LINES")
		:size(1, 1)
		:pos(2.25, 0, 2.25)
		:rot(90, 0, 0)
		:scale(4.5)
	part:newSprite("ew")
		:texture(assets.textures.Black, 16, 16)
		:renderType("LINES")
		:size(1, 1)
		:pos(2.25, 0, 2.25)
		:rot(-90, -90, 0)
		:scale(4.5)

	function part.preRender(delta)
		-- Position hitbox

		local pos_a = entity:getPos(delta)
			:add(0, entity:getEyeHeight(), 0)
			:add(entity:getVariable("eyePos"))
		local pos_b = pos_a + entity:getLookDir() * 20

		local _, hit = raycast:block(pos_a, pos_b)
		local yaw = -entity:getRot(delta).y

		-- Snap to grid when crouching

		if entity:isCrouching() then
			hit = (hit * 2 + vec(0.5, 0, 0.5)):floor() / 2
			yaw = math.round(yaw / 22.5) * 22.5
		end

		-- Transform hitbox

		part:pos(hit):rot(0, yaw, 0)

		-- Place chess board

		if assets.press(entity) then
			board.model
				:pos(hit + vec(0, -1.75 + 1.75 / 16, 0))
				:rot(0, yaw - 90)
				:scale(1 / 16)
				:visible(true)
			part:remove()
		end
	end
end

return hitbox
