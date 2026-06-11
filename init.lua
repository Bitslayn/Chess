local boards = require("./comp/boards")
local hitbox = require("./comp/hitbox")

function events.entity_init()
	local board = boards.new()
	hitbox.new(player, board)
end
