function self:onOpen(p)
    Blockman.Instance().player:updateUpperAction('minig',-1)
    local progress = 1/p.real_speed
    self.ProgressBar:setProgress(0)
    self.ProgressBar:setStepSize(progress)
    local entity = World.CurWorld:getObject(p.objId)
    World.Timer(1, function ()
        local plaPos = Me:curBlockPos()
        local MaPos = entity:curBlockPos()
        local distance = math.abs(math.sqrt((plaPos.x - MaPos.x)^2+(plaPos.y - MaPos.y)^2+(plaPos.z - MaPos.z)^2))
        if distance > 2 then                    
            self:close()
            return false
        end
        if entity:isDead() then
            self:close()
            return false
        end
        if self.ProgressBar:getProgress() >= 1 then
            Blockman.Instance().player:updateUpperAction('minig',0)
            PackageHandlers.sendClientHandler("PLAYER_END_MINE", p)
            self:close()
            return false
        end        
        self.ProgressBar:step()
        return true
    end)
end