local states = require("./states")
local assets = require("./../assets/assets") ---@type FOXChess.Assets

---@class FOXChess.Boards
local boards = {}

---@class FOXChess.Board
---@field model ModelPart
---@field pieces FOXChess.Piece[][]
local class = {}
---@package
class.__index = class

---Creates a new chess board
---@param pos Vector3
---@param yaw number
---@param state string?
---@nodiscard
function boards.new(pos, yaw, state)
	return setmetatable({
		model = assets.model.Board
			:copy("Board")
			:moveTo(assets.world)
			:pos(pos + vec(0, -1.75 + 1.75 / 16, 0))
			:rot(0, yaw)
			:scale(1 / 16)
			:visible(true),
		hash = "",
	}, class):loadState(state):render()
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
					:pos(y * -8 + 36, 0, x * 8 - 36)
					:rot(0, piece.is_black and 0 or 180, 0)
					:primaryTexture("CUSTOM", assets[piece.color])
					:visible(true)
			end
		end
	end
	return self
end

return boards
