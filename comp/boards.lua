local states = require("./states")
local assets = require("./../assets/assets") ---@type FOXChess.Assets
local common = require("./common") ---@type FOXChess.Common
local hitbox = require("./hitbox")

---@class FOXChess.Boards
local boards = {}

---@class FOXChess.Board
---@field model ModelPart
---@field moving boolean
---@field pieces FOXChess.Piece[][]? TODO
local class = {}
---@package
class.__index = class

local EPSILON = 2.2204460492503131e-16
local dot = vectors.vec3().dot

---@param ray_pos Vector3
---@param ray_dir Vector3
---@param plane_pos Vector3
---@param plane_normal Vector3
---@return Vector3? intersection_point
local function intersectPlane(ray_pos, ray_dir, plane_pos, plane_normal)
	local denom = dot(plane_normal, ray_dir)
	if -denom < EPSILON then return end
	local d = plane_pos - ray_pos
	local t = dot(d, plane_normal) / denom
	if t < EPSILON then return end
	return ray_pos + ray_dir * t
end

---@param hit_pos Vector3
---@param plane_mat Matrix4
---@return Vector3
local function worldToLocal(hit_pos, plane_mat)
	local pos_mat = matrices.translate4(plane_mat:apply())
	local rot_mat = matrices.rotation4(0, 180, 0) * (pos_mat:inverted() * plane_mat):inverted()

	return (rot_mat * matrices.translate4(hit_pos - plane_mat:apply())):apply()
end

local inner = vec(1, 1)
local outer = vec(1.125, 1.125)

---Creates a new chess board
---@param state string?
---@nodiscard
function boards.new(state)
	local self = setmetatable({
		model = assets.model.Board:copy("Board"):moveTo(assets.world),
		moving = false,
	}, class)

	self:loadState(state):render()

	function self.model.preRender(delta)
		if self.moving then return end

		local mat = self.model:partToWorldMatrix()

		local viewer = client.getViewer()
		local ray_pos = viewer:getPos(delta)
			:add(0, viewer:getEyeHeight(), 0)
			:add(viewer:getVariable("eyePos"))
		local ray_dir = viewer:getLookDir()

		local hit = intersectPlane(ray_pos, ray_dir, mat:apply(), mat:applyDir(0, 1, 0))
		if not hit then return end

		local rel_pos = (worldToLocal(hit, mat) / 32).xz --[[@as Vector2]]

		local pressed = common.press(viewer, "board")
		local hover_inner = -inner <= rel_pos and rel_pos <= inner
		local hover_outer = -outer <= rel_pos and rel_pos <= outer

		if hover_inner then
			local y, x = (rel_pos * -4 + 4):ceil():unpack()
			host:actionbar(string.char(x + 64) .. y .. (self.pieces[y][x] and ": " .. self.pieces[y][x].color .. " " .. self.pieces[y][x].name or ""))
		elseif hover_outer then
			if pressed then
				hitbox.new(viewer, self)
			end
		end
	end

	return self
end

---Creates a chess board save state
---@return string
---@nodiscard
function class:saveState()
	return states.tbl_to_str(self.pieces)
end

---Loads a chess board save state
---
---A nil or invalid state resets the board
---@param state string?
---@return self
function class:loadState(state)
	state = type(state) == "string" and state or ";r*nbqkbnr*;p&8;&5P&8;R*NBQKBNR*"
	self.pieces = states.str_to_tbl(state)
	return self
end

---Forces the board to render its pieces
---@return self
function class:render()
	for y = 1, 8 do
		for x = 1, 8 do
			if self.model[y .. x] then
				self.model[y .. x]:remove()
			end

			local piece = self.pieces[y][x]

			if piece then
				assets.model[piece.name] --[[@as ModelPart]]
					:copy(y .. x)
					:moveTo(self.model)
					:pos(y * 8 - 36, 0, x * 8 - 36)
					:rot(0, piece.is_black and 180 or 0, 0)
					:primaryTexture("CUSTOM", assets.textures[piece.color])
					:visible(true)
			end
		end
	end
	return self
end

return boards
