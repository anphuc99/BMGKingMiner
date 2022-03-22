local gameReport = Game.GetService("GameReport")
local Context = require "script_common.lbr.Context"
Trigger.addHandler(this:cfg(), "PLAYER_END_MINE", function(context)
    local name = Context:new("Item"):where("id",context.item):firstData().name
    gameReport:reportGameData("mine", "the player has mine 1 "..name, context.obj1)
end)