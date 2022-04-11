local mytable = setmetatable({key1 = "wwwwww"}, {
	__index = function(mytable, key)
	 
	   if key == "key1" then
		  return "metatablevalue"
	   end
	end
 })
 
