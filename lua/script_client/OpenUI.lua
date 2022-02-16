local Material = require("script_common.database.Material")
PackageHandlers.registerClientHandler("UI", function(player, packet)
    UI:openWindow(packet.UI,nil,nil,packet)
end)
PackageHandlers.registerClientHandler("Player_enter", function(player, packet)
    -- PackageHandlers.sendClientHandler("setLanguage", {lang = Lang:toText("lang")})
end)
PackageHandlers.registerClientHandler("sendTip", function(player, packet)
    if  UI:isOpenWindow("messenger") then
        UI:closeWindow("messenger")
    end
    UI:openWindow("messenger",nil,nil,packet)
end)