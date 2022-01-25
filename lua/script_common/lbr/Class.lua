local function Class()
    local Class = {}
    function Class:create(nameClass, obj) 
        self.__className = nameClass
        self[nameClass] = obj 
    end
    function Class:new(...)     
        local cls = self[self.__className]()
        if(cls.__constructor ~= nil) then
            cls:__constructor(...)
        end
        return cls
    end
    function Class:extend()
        local super = {}
        local o = self[self.__className]()  
        for i, ii in pairs(o) do if type(ii) == 'function' then super[i] = ii end end
        return o, super
    end
    return Class
end
return Class
