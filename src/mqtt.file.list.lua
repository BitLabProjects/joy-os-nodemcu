local client, dataobj = ...

print("received type:file.list")
local l = file.list();
for k,v in pairs(l) do
  print("sending name:"..k..", size:"..v)
  -- client:publish("/devices/joy.out", "{\"dst\":\""..dataobj.src.."\",\"type\":\"file\",\"name\":\""..k.."\",\"size\":"..v.."}", 0, 0)
  client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, opid=dataobj.opid, type="file", name=k, size=v}), 0, 0)
end
-- Send an empty file to mark file.list ended
-- client:publish("/devices/joy.out", "{\"dst\":\""..dataobj.src.."\",\"type\":\"opend\"}", 0, 0)
client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, opid=dataobj.opid, type="opend"}), 0, 0)

return