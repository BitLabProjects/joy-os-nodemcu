local client, dataobj = ...

print("sending statistics")

-- Send confirm
client:publish("/devices/joy.out", sjson.encode({dst=dataobj.src, 
                                                 opid=dataobj.opid, 
                                                 type="opend",
                                                 chipID=node.chipid(), 
                                                 flashID=node.flashid(),
                                                 flashSize=node.flashsize(), 
                                                 heap=node.heap(),
                                                 info=node.info(), 
                                                 bootreason=node.bootreason()}), 0, 0)