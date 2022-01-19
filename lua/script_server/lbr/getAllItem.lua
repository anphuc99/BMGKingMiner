return function(player)
    local entityTrays = player:tray()
    local filterTB = {Define.TRAY_TYPE.HAND_BAG}
    local trayTb = entityTrays:query_trays(filterTB)
    return trayTb
end

