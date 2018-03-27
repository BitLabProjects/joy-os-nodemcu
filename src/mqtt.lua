local CLIENT_ID = "esp8266_1"
local SERVER_IP = "192.168.1.196"

m = mqtt.Client(CLIENT_ID, 120)

local STATE_OFFLINE = 0
local STATE_CONNECTING = 1
local STATE_ONLINE = 2

local state = STATE_OFFLINE
local mqtt_connection_timer = tmr.create()

local mqtt_connect_callback = function (client) 
  state = STATE_ONLINE
  
  print("#mqtt online")
  -- subscribe topic with qos = 0
  client:subscribe("/hello", 0, function(client) print("subscribed to /hello") end)
  client:subscribe("/devices/joy.in", 0, function(client) print("subscribed to /devices/joy.in") end)
  -- publish a message with data = hello, QoS = 0, retain = 0

  local hello_msg = {src=CLIENT_ID, type="hello"}
  client:publish("/hello", sjson.encode(hello_msg), 0, 0)
end

local mqtt_offline_callback = function(client)
  state = STATE_OFFLINE
  print("#mqtt offline")

  mqtt_connection_timer:start()
end

local mqtt_connection_timer_callback = function () 
  state = STATE_CONNECTING
  print("#mqtt connecting")

  m:connect(SERVER_IP, 1883, 0, nil, mqtt_offline_callback)
end

mqtt_connection_timer:alarm(5000, tmr.ALARM_SEMI, mqtt_connection_timer_callback)

m:on("connect", mqtt_connect_callback)
m:on("offline", mqtt_offline_callback)

m:on("message", function(client, topic, data)
  if blinky ~= nil then blinky:blink() end
  
  if topic == "/devices/joy.in" then
    if data ~= nil then
      local dataobj = sjson.decode(data)

      local handler_filename = "mqtt."..dataobj.type
      local handler = load(handler_filename)
      if handler ~= nil then
        print("executing handler: "..handler_filename)
        handler(client, dataobj)
      else
        print("handler not found: "..handler_filename)
      end
      return
    end

    print("unsupported command: " .. topic .. ":" ) 
    if data ~= nil then
      print(data)
    end
    
  else
    print(topic .. ":" ) 
    if data ~= nil then
      print(data)
    end
  end
end)

mqtt_connection_timer:start()