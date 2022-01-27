local typeItem = require "script_common.typeItem"
return {

    {
        id = "myplugin/M_Iron",
        name ="item_M_Iron",
        icon = "asset/Texture/Block/iron_ore.png",
        typeItem = typeItem.Material
    },

    {
        id = "myplugin/M_Tree",
        name ="item_M_Tree",
        icon = "asset/Texture/Block/cactus_side.png",
        typeItem = typeItem.Material
    },

    {
        id = "myplugin/Tr_cupLv1_1",
        name ="item_Tr_cupLv1_1",
        icon = "asset/Actor/Cedar Tree/bingxuejie_shu.tga",
        typeItem = typeItem.Trophy
    },

    {
        id = "myplugin/Tr_cupLv2_1",
        name ="item_Tr_cupLv2_1",
        icon = "asset/Actor/Agricultural Rake/gun_2004.tga",
        typeItem = typeItem.Trophy
    },

    {
        id = "myplugin/V_Vortex",
        name ="item_V_Vortex",
        icon = "asset/Actor/Aqua Blue Egg/egg_8.png",
        typeItem = typeItem.Vortex
    },

    option = {
        primaryKey = "id",        
    }
}