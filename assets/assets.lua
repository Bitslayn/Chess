---@class FOXChess.Model
---@field board ModelPart
---@field pawn ModelPart
---@field bishop ModelPart
---@field knight ModelPart
---@field rook ModelPart
---@field queen ModelPart
---@field king ModelPart

---@class FOXChess.Assets
---@field model FOXChess.Model
local assets = { model = models --[[@as FOXChess.Model]] }

for w in string.gmatch(... .. ".model", "[^./]+") do
	assets.model = assets.model[w] --[[@as FOXChess.Model]]
end

return assets
