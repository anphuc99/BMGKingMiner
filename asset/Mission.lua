function self:onOpen(p)
    self.Image.onMouseClick = function() 
        PackageHandlers.sendClientHandler("getMission")
    end
    PackageHandlers.registerClientHandler("receivedMission", function(player, packet)
        print("lalalaalal")
        self.Image:setImage("gameres|asset/Texture/Gui/nhận nv.png")
    end)
    if p.received then
        self.Image:setImage("gameres|asset/Texture/Gui/nhận nv.png")
    else
        self.Image:setImage("gameres|asset/Texture/Gui/có nv.png")
    end
    PackageHandlers.registerClientHandler("MissionComplate", function(player, packet)
        self.Image:setImage("gameres|asset/Texture/Gui/hoàn thành nv.png")        
    end)
end