local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt,false)
mt.__namecall = newcclosure(function(self, ...)
  local args = {...}
  if getnamecallmethod() == 'InvokeServer' and args[1] == "Slash" then
    args[3] = "Nape"
  end
  return old(self, unpack(args))
end)
