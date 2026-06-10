---@class FOXChess.Timers
local timer = {}

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
function timer.new(entity, color, time)
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
		part:pos(entity:getPos(delta))
	end

	return setmetatable({ part = part, task = task, color = color, time = time }, class)
end

---Runs the countdown timer
function class:tick()
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

return timer
