local board = require("./comp/board")
local timers = require("./comp/timer")

local default = ";r*nbqkbnr*;p&8;&5P&8;R*NBQKBNR*"

-- print(board.int_to_str(board.str_to_int(board)))

function events.entity_init()
	local black = timers.new(player, "Black", 10 * 60 * 20)

	function events.tick()
		black:tick()
	end
end
