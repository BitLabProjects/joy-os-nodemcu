local client, dataobj = ...

local startFlag = dataobj.start
local finishFlag = dataobj.finish

print("file.write, offset:"..dataobj.offset)

if startFlag then
  file.remove(dataobj.name)
  file.remove(dataobj.name .. ".tmp")
end

local content = encoder.fromBase64(dataobj.content)
file.open(dataobj.name .. ".tmp", "a+")
file.seek("set", dataobj.offset)
file.write(content)
file.close()

if finishFlag then
  file.rename(dataobj.name .. ".tmp", dataobj.name)
end

-- Send confirm
client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, opid=dataobj.opid, type="opend"}), 0, 0)
