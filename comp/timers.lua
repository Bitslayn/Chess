---@class FOXChess.Timers
local timers = {}

--[[Ideas:
To the viewer, their timer will not be visible next to them but instead will show above the board(s) they're playing
To onlookers, they will have a timer next to them only if they're looking towards the board or sumn
]]

---@class FOXChess.Timer
---@field private part ModelPart
---@field private task TextTask
---@field color string Color to show
---@field time integer Current time in ticks
local class = {}
---@package
class.__index = class

local root = models:newPart("chess_world", "World"):scale(16)

---Attaches a new timer to an entity or player
---@param entity Player|Entity
---@param color string
---@param time integer
---@return FOXChess.Timer
---@nodiscard
function timers.new(entity, color, time)
	-- Setup rendering to align to entity position in world space

	local part = root:newPart(entity:getUUID()):scale(1 / 16)

	local pivot = part
		:newPart("pivot"):pos(0, 21) -- World space
		:newPart("pivot", "Camera") -- Billboard
		:newPart("pivot"):pos(-12) -- Camera space

	local task = pivot
		:newText("task")
		:pos(0, 9.5 * 0.4)
		:scale(0.4)
		:background(true)

	function part.preRender(delta)
		-- Move to entity position
		-- Hide if entity isn't rendering or UI is hidden 

		if entity:isLoaded() then
			part:pos(entity:getPos(delta))
			task:visible(client.isHudEnabled())
		else
			task:visible(false)
		end
	end

	-- Set timer text and return (Add a tick to simulate a full second passing)

	local self = setmetatable({ part = part, task = task, color = color, time = math.floor(time * 60) * 20 + 1 }, class)
	self:tick()
	return self
end

---Runs the countdown timer
function class:tick()
	-- Change timer text only after a full second has elapsed

	self.time = math.max(self.time - 1, 0)

	local min = self.time / 20 / 60
	local sec = self.time / 20 % 60

	if sec % 1 ~= 0 then return end

	self.task:text(string.format("%s\n⏳ %02d:%02d", self.color, min, sec))
end

---Removes this timer from rendering
function class:remove()
	self.part:remove()
end

return timers
