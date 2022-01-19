return function (entity,pos)
    entity:startAI()
    local control = entity:getAIControl()
    control:setAiData("homeSize", 50)
    control:setAiData("enableNavigate", true)
    entity:setAITargetPos(pos, true)
end