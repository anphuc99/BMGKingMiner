PackageHandlers.registerClientHandler("UI", function(player, packet)
    UI:openWindow(packet.UI)
end)