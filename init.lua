local boards = require("./comp/boards")
local timers = require("./comp/timers")

function events.entity_init()
	local board = boards.new(player:getPos(), player:getBodyYaw())
end
