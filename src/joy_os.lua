JoyOS = class()

function JoyOS:init()
end
function JoyOS:run()
  exec("blinky")

  if exec('devices') then
    devices = Devices:new()
    devices:create(Drv8833CtlDevice, 'Drv8833 #1', 0, 1)
    devices:create(Drv8833MotorDevice, 'Motor #1', 2, 3)
    devices:create(Drv8833MotorDevice, 'Motor #2', 5, 6)
  end
  
  local wifiCfg ={ssid="YourSSIDHere", pwd="YourPasswordHere"}
  
  wifi.setmode(wifi.STATION)
  wifi.sta.config(wifiCfg)
  wifi.sta.connect()
  print_n("Connecting to WiFi "..wifiCfg.ssid)
  tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
      print_n(".")
    else
      tmr.stop(1)
      print()
      --print("ESP8266 mode is: " .. wifi.getmode())
      --print("The module MAC address is: " .. wifi.ap.getmac())
      print("WiFi connected, IP is "..wifi.sta.getip())
      
      exec("mqtt")
    end
  end)
end
