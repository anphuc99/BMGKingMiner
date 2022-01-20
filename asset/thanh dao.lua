function self:onOpen(p)
    print(Lib.pv(p))
    local progress = 1/p.real_speed
    self.ProgressBar:setProgress(0)
    local stop = false
    World.Timer(2, function ()
        if stop then
            self:close()
            return false
        end        
        self.ProgressBar:setProgress(self.ProgressBar:getProgress() + progress)
        return 1
    end)
    PackageHandlers.registerClientHandler("StopMine", function(player, packet)
        stop = true
    end)
end