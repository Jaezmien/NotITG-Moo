local proxies = {}
proxy = setmetatable(
	{
		get_proxy = function(self, id) return proxies[id].Proxy end,
		get_original = function(self, id) return proxies[id].Original end,
	},
	{
	__index = function(self, key) return proxies[is_actor(key) and tostring(key) or key] end, __newindex = function() end,
	__call = function(self, actor, target, id )
		actor:SetTarget( target )
		proxies[ id or tostring(actor) ] = { Proxy = actor, Original = target }
	end,
})