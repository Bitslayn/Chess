---@class FOXChess.Pieces
local pieces = {}

---@class FOXChess.Piece
---@field key string
---@field is_black boolean
---@field is_special boolean
local class = {}
---@package
class.__index = class

---Creates a new chess piece
---@param key string
---@param is_black boolean
---@param is_special boolean
---@return FOXChess.Piece
function pieces.new(key, is_black, is_special)
	return setmetatable({ key = key, black = is_black, special = is_special }, class)
end

return pieces
