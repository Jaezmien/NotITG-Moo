proxy = {}

local proxies = {}

proxy.create_proxy = function(actor,copy,id)
    actor:SetTarget( copy )
    proxies[id] = {
        Proxy = actor,
        Original = copy
    }
end
proxy.remove_proxy = function(id)
    proxies[id] = nil
end
proxy.get_proxy = function(id) return proxies[id].Proxy end
proxy.get_original = function(id) return proxies[id].Original end