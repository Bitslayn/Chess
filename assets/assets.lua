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
	world = models:newPart("chess_world", "World"):scale(16):primaryRenderType("TRANSLUCENT_CULL"),
	black = textures:fromVanilla("chess_black", "textures/block/stripped_dark_oak_log.png"),
	white = textures:fromVanilla("chess_white", "textures/block/stripped_birch_log.png")
}

for w in string.gmatch(... .. ".model", "[^./]+") do
	assets.model = assets.model[w] --[[@as FOXChess.Model]]
end

return assets
