require("script_client.OpenUI")    
require "script_client.Bus.ObjMaterial"
World.Timer(10, function()
    --local guiMgr = GUIManager:Instance()
	local window = UI:openWindow("shortcutBar")
    require "script_client.Bus.GameRun"
end)

