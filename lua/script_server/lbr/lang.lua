local language = require "script_common.language"
return function (player,messager)
    local lang = player:data("lang")
    local msg = language[messager[1]][lang]
    for i = 2, #messager, 1 do
         msg = msg:gsub("%{.}",messager[i],1)
    end
    return msg
end