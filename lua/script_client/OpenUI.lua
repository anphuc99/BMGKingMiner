local Material = require("script_common.database.Material")
local time
PackageHandlers.registerClientHandler("UI", function(player, packet)
    UI:openWindow(packet.UI,nil,nil,packet)
end)
PackageHandlers.registerClientHandler("Player_enter", function(player, packet)
    -- PackageHandlers.sendClientHandler("setLanguage", {lang = Lang:toText("lang")})
    PackageHandlers.sendClientHandler("getValuePlayer", nil, function (player)
        if player.tutorial < 6 then
            UI:openWindow("Tutorial",nil,nil,player)
        end
    end)
end)
require "script_client.senTip".sendTip = function (p)
    local win = UI:isOpenWindow("messenger")
    if not win then
        win = UI:openWindow("messenger")
        win:setProperty("AlwaysOnTop", "true")
        time = p.time or 80
        World.Timer(1, function ()
            if time == 0 then
                UI:closeWindow("messenger")
                return false
            else
                time = time - 1
                return 0.5
            end
        end)
    else
        time = p.time or 80
    end
    win.Text:setText(Lang:toText(p.Text))
    if p.Color ~= nil then
        win.Text:setTextColours(Color3.fromRGB(p.Color.r,p.Color.g,p.Color.b))
    end  
end
PackageHandlers.registerClientHandler("sendTip", function(player, p)
    require "script_client.senTip".sendTip(p)
end)
local soundID = require "script_client.senTip".SoundId

soundID = TdAudioEngine.Instance():play2dSound("asset/MP3/Loppy.mp3", true)
print(soundID,"wwwwwwwwwwwwwwwwsssssssssssss")


PackageHandlers.registerClientHandler("PlayMP3Loppy", function(player, packet)
    TdAudioEngine.Instance():stopSound(soundID)
    soundID = TdAudioEngine.Instance():play2dSound("asset/MP3/Loppy.mp3", true)
end)

PackageHandlers.registerClientHandler("PlayMP3Mine", function(player, packet)
    TdAudioEngine.Instance():stopSound(soundID)
    print("wwwwwwwwwwwwwwwwsssssssssssss",soundID)
    soundID = TdAudioEngine.Instance():play2dSound("asset/MP3/Mine.mp3", true)
end)