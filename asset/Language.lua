function self:onOpen(p)
    local lg = require "script_common.language"
    local plLg = require "script_client.languagePlayer"

    for i = 1, 6, 1 do 
        if lg.language[i] then
            self.Image["lg" .. i]:setText(lg.language[i].motherLanguage)
            self.Image["lg" .. i].onMouseClick = function()         
                plLg[1] = lg.language[i].name
                PackageHandlers.sendClientHandler("setLanguage", {i = i}) 
                self:close()           
            end 
        end
    end
    self.Image.close.onMouseClick = function() self:close() end
end
