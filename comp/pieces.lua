---@class FOXChess.Pieces
local pieces = {}

---@class FOXChess.Piece
---@field key string
---@field name string
---@field color string
---@field is_black boolean
---@field is_special boolean
local class = {}
---@package
class.__index = class

local names = {
	P = "Pawn",
	B = "Bishop",
	N = "Knight",
	R = "Rook",
	Q = "Queen",
	K = "King",
}

---Creates a new chess piece
---@param key string
---@param is_black boolean
---@param is_special boolean
---@return FOXChess.Piece
---@nodiscard
function pieces.new(key, is_black, is_special)
	return setmetatable({
		key = key,
		name = names[key:upper()],
		color = is_black and "black" or "white",
		is_black = is_black,
		is_special = is_special,
	}, class)
end

return pieces
