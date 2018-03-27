local client, dataobj = ...

for i=1,10 do
  local id = dataobj["id"..i]
  if id == nil then
    break
  end
  
  local dev = devices:getById(id)
  if dev == nil then
    --print('device id not valid: '..id)
  else
    local value = dataobj["value"..i]
    --print("device.out, id:"..id..", value:"..value)
    dev:out(value)
  end
end

-- Send confirm
client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, opid=dataobj.opid, type="opend"}), 0, 0)
