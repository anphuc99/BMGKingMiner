local cupLv1 = "myplugin/P_cup-go_1"
local positionItem = require "script_common.positionItem"
this.addValueDef("new", false, false, false, true, false)
local PlayerProperty = {
    id = -1,
    money = 1000,
    balo = 6,
    idCard = 1,
    Lv = 1,
    exp = 0,
    lastLogin = os.time()            
}
this.addValueDef("PlayerItem", {
    {idPlayer = -1, idItem = cupLv1,cellNum = 1, num = 1, position = positionItem.hand, lv = 1},
}, false, false, true, false)
this.addValueDef("Player", PlayerProperty, false, false, true, false)