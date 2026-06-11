local boards = require("./comp/boards")
local timers = require("./comp/timers")

-- print(boards.new():saveState())

function events.entity_init()
	local black = timers.new(player, "Black", 10)

	function events.tick()
		black:tick()
	end
end
