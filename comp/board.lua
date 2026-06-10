--[[
Pieces:
	Uppercase - Black
	Lowercase - White

	P - Pawn
	B - Bishop
	N - Knight
	R - Rook
	Q - Queen
	K - King

	P* - Pawn (En passant)
	R* - Rook (Castle-able)
	P&8 - Pawn (Repeated 8 times)

Marker:
	; - Next column
	. - Next row

Flags:
	* - Special
	& - Repeat
]]

local piece = require("./piece")

---@class FOXChess.Board
local board = {}

local symbols = "PBNRQKpbnrqk;.*&"

---@type table<string, integer>
local str_map = {}
---@type table<integer, string>
local int_map = {}

for i = 1, #symbols do
	local w = symbols:sub(i, i)
	str_map[w] = i - 1
	int_map[i - 1] = w
end

---@param str string
---@return table
function board.str_to_tbl(str)
	local tbl = {}
	local x, y = 0, 0

	for key, op in str:gmatch("(.)(%*?&?%d?)") do
		local is_piece = key:find("%a")
		local is_black = key:upper() == key
		local is_special = op == "*"

		for _ = 1, tonumber(op:match("&(%d)")) or 1 do
			if is_piece then
				tbl[y][x] = piece.new(key, is_black, is_special)
			elseif key == ";" then
				x, y = 0, y + 1
				tbl[y] = {}
			end

			x = x + 1
		end
	end

	return tbl
end

---@param tbl table
---@return string
function board.tbl_to_str(tbl)
	local raw = {}

	for y = 1, 8 do
		raw[#raw + 1] = ";"
		for x = 1, 8 do
			if next(tbl[y]) then
				raw[#raw + 1] = tbl[y][x] and tbl[y][x].key .. (tbl[y][x].special and "*" or "") or "."
			end
		end
	end

	local tokens = {}
	local last, count = nil, 1

	for i = 1, #raw + 1 do
		if last == raw[i] then
			count = count + 1
		else
			tokens[#tokens + 1] = last
			if count > 1 then
				tokens[#tokens + 1] = "&" .. count
			end
			last, count = raw[i], 1
		end
	end

	return table.concat(tokens)
end

---@param str string
---@return integer ...
function board.str_to_int(str)
	local nibbles = {}
	for w in str:gmatch(".") do
		nibbles[#nibbles + 1] = str_map[w] or tonumber(w)
	end

	local bits = {}
	for i, v in ipairs(nibbles) do
		local index = math.floor((i - 1) / 8) + 1
		bits[index] = bit32.replace(bits[index] or 0, v, ((i - 1) % 8) * 4, 4)
	end

	return table.unpack(bits)
end

---@param ... integer
---@return string
function board.int_to_str(...)
	local bits = { ... }
	local str = {}

	for _, bit in ipairs(bits) do
		for i = 0, 7 do
			local nibble = bit32.extract(bit, i * 4, 4)
			str[#str + 1] = str[#str] == "&" and nibble or int_map[nibble]
		end
	end

	return table.concat(str)
end

return board
