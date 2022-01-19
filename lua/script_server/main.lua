local Equipment = require "script_server.Model.Equipment"

local block= Block.GetNameCfg("myplugin/grass")
Trigger.RegisterHandler(block, "BLOCK_BREAK", function(context)
    Item.new("myplugin/bc498465-8619-4188-bc57-ff9a717a3787", 1)
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
    print("eeeeeeeeeeeeeeeeee")
end)

