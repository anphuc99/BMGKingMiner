return function (player,packet)
    packet.UI = "messenger"
    PackageHandlers.sendServerHandler(player, "sendTip", packet)
end