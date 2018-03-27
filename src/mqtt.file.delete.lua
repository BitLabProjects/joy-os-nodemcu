local client, dataobj = ...

print("deleting file: "..dataobj.name)
file.remove(dataobj.name)

-- Send confirm
client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, opid=dataobj.opid, type="opend"}), 0, 0)