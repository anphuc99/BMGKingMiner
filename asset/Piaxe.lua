function self:onOpen(p)
    self.Mine.onMouseClick = function() 
        PackageHandlers.sendClientHandler("PLAYER_BEGIN_MINE", {objID = p.objid})
    end
    PackageHandlers.registerClientHandler("HideMine", function(player, packet)        
        self.Mine:setVisible(false)
    end)
end