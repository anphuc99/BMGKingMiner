PackageHandlers.registerClientHandler("UI", function(player, packet)
    UI:openWindow(packet.UI,nil,nil,packet)
end)