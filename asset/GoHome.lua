function self:onOpen(p)
    self.GoHome:setStepSize(1/(10*20))
    local buffId
    local stop = false
    PackageHandlers.sendClientHandler("addBuff", {buff = "myplugin/Buff_GoHom", time = 10*20},function (id)
        buffId = id
    end)
    World.Timer(1, function ()
        self.GoHome:step()
        if self.GoHome:getProgress() >= 1 then
            PackageHandlers.sendClientHandler("GoHome")            
            -- PackageHandlers.sendClientHandler("removeBuff",{buff = buffId})            
            self:close()
            return false
        end
        if stop then
            PackageHandlers.sendClientHandler("removeBuff",{buff = buffId})
            self:close()
            return false
        end
        return 0.5
    end)

    PackageHandlers.registerClientHandler("StopGoHome", function(player, packet)
        stop = true
    end)
end