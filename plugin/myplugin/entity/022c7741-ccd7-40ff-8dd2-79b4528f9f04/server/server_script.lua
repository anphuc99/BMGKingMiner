Trigger.RegisterHandler(this:cfg(), "ENTITY_CLICK", function(context)
    PackageHandlers.sendServerHandler(context.obj2, "UI", {UI = "Market", NPC = context.obj1:data("id")})

end)

this:setData("id", 1)