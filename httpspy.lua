local wrdreq = http_request or request or HttpPost or syn.request or http.request
local originalSynapse = wrdreq
local clonedSynapse = clonefunction(wrdreq)
local NC = newcclosure
local hookOnto = {pcall, xpcall}
for _,v in pairs(hookOnto) do
    local oldFunction;
    oldFunction = hookfunction(v, NC(function(self, ...)
        return oldFunction(self == clonedSynapse and originalSynapse or self, ...)
    end))
end
