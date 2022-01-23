return function (player,slot)
    local filterTB = {
        Define.TRAY_TYPE.HAND_BAG
    }
    local entityTrays = player:tray()
    local trayTb = entityTrays:query_trays(filterTB)
    for tid, _tray in pairs(trayTb) do
        _tray.tray:remove_item(slot)
    end
end