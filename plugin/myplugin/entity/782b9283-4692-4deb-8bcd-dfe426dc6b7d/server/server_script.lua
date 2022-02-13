Trigger.RegisterHandler(this:cfg(), "ENTITY_CLICK", function(context)
    PackageHandlers.sendServerHandler(context.obj2, "UI", {UI = "Market", NPC = 1})

end)