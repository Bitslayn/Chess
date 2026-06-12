local assets = require("./../assets/assets") ---@type FOXChess.Assets
local common = require("./common") ---@type FOXChess.Common

---@class FOXChess.Hitbox
local hitbox = {}

---Attaches a chess board hitbox to an entity or player
---
---When this entity or player swings, the chess board will be placed at the hitbox's position, and the hitbox will be removed
---@param entity Player|LivingEntity
---@param board FOXChess.Board
function hitbox.new(entity, board)
	local part = assets.world:newPart("Hitbox")
	common.square(part, 4.5, vec(1, 1, 1))

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

		if common.press(entity) then
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
