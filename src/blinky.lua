local Blinky = class()

function Blinky:init(pin_led)
  self.pin_led = pin_led
  self.isOn = true
  gpio.mode(self.pin_led, gpio.OUTPUT)
  gpio.write(self.pin_led, gpio.LOW) --Low means on

  self.timer = tmr.create()
  self.timer:alarm(1000, tmr.ALARM_AUTO, function() self:blink() end)
end
function Blinky:blink()
  self.isOn = not self.isOn
  if self.isOn then
    gpio.write(self.pin_led, gpio.HIGH)
  else
    gpio.write(self.pin_led, gpio.LOW)
  end
end

blinky = Blinky:new(4)
