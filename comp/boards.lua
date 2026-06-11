local states = require("./states")

---@class FOXChess.Boards
local boards = {}

---@class FOXChess.Board
---@field pieces FOXChess.Piece[][]
local class = {}
---@package
class.__index = class

---Creates a new chess board
---@param state string?
---@nodiscard
function boards.new(state)
	return setmetatable({}, class):loadState(state)
end

---Creates a chess board save state
---@return string
---@nodiscard
function class:saveState()
	return states.tbl_to_str(self.pieces)
end

---Loads a chess board save state
---
---A nil value resets the board
---@param state string?
---@return self
function class:loadState(state)
	state = type(state) == "string" and state or ";r*nbqkbnr*;p&8;&5P&8;R*NBQKBNR*"
	self.pieces = states.str_to_tbl(state)
	return self
end

return boards
