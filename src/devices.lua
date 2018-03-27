Device = class()
function Device:init(id, name)
  self.id = id
  self.name = name
end

Devices = class()
function Devices:init()
  self.devs = {}
  self.devsCount = 0
end
function Devices:create(type, name, ...)
  self.devsCount = self.devsCount + 1
  local dev = type:new(self.devsCount, name, ...)
  self.devs[dev.id] = dev
  return dev
end
function Devices:getById(id)
  if id < 1 or id > self.devsCount then
    return nil
  end

  return self.devs[id]
end


--Motor type device
MotorDevice = class(Device)
function MotorDevice:init(id, name, pin_direction, pin_speed)
  self.id = id
  self.name = name
  self.pin_direction = pin_direction
  self.pin_speed = pin_speed
  self.currValue = 0
  self.targetValue = 0
  self.timer = tmr.create()
  self.timer:register(10, tmr.ALARM_AUTO, function() self:ramp() end)
  gpio.mode(self.pin_direction, gpio.OUTPUT)
  gpio.write(self.pin_direction, gpio.LOW)
  pwm.setup(self.pin_speed, 1000, 0)
end
function MotorDevice:ramp()
  if self.currValue < self.targetValue then
    self.currValue = self.currValue + 1
  elseif self.currValue > self.targetValue then
    self.currValue = self.currValue - 1
  else
    print("MotorDevice:ramp! ramp completed")
    self.timer:stop()
    return
  end

  if self.currValue >= 0 then
    gpio.write(self.pin_direction, gpio.LOW)
  else
    gpio.write(self.pin_direction, gpio.HIGH)
  end
  pwm.setduty(self.pin_speed, (self.currValue / 100) * 1023)
end
function MotorDevice:out(value)
  --print('MotorDevice:out! value='..value)
  self.targetValue = value
  local running, mode = self.timer:state()
  if not running then
    print("MotorDevice:out! ramp started")
    self.timer:start()
  end
end

--Motor type device
Drv8833MotorDevice = class(Device)
function Drv8833MotorDevice:init(id, name, pin_in1, pin_in2)
  self.id = id
  self.name = name
  self.pin_in1 = pin_in1
  self.pin_in2 = pin_in2
  gpio.mode(self.pin_in1, gpio.OUTPUT)
  gpio.mode(self.pin_in2, gpio.OUTPUT)
  gpio.write(self.pin_in1, gpio.HIGH)
  gpio.write(self.pin_in2, gpio.HIGH)
end
function Drv8833MotorDevice:out(value)
  -- if value > 0 then
  --   gpio.write(self.pin_in1, gpio.HIGH)
  --   gpio.write(self.pin_in2, gpio.LOW)
  -- else
  --   gpio.write(self.pin_in1, gpio.LOW)
  --   gpio.write(self.pin_in2, gpio.HIGH)
  -- end
  if value > 0 then
    pwm.stop(self.pin_in1)
    gpio.mode(self.pin_in1, gpio.OUTPUT)
    gpio.write(self.pin_in1, gpio.LOW)
    pwm.setup(self.pin_in2, 1000, value)
    pwm.start(self.pin_in2)

  elseif value < 0 then
    pwm.setup(self.pin_in1, 1000, -value)
    pwm.start(self.pin_in1)
    pwm.stop(self.pin_in2)
    gpio.mode(self.pin_in2, gpio.OUTPUT)
    gpio.write(self.pin_in2, gpio.LOW)

  else
    pwm.stop(self.pin_in1)
    pwm.stop(self.pin_in2)
    gpio.mode(self.pin_in1, gpio.OUTPUT)
    gpio.mode(self.pin_in2, gpio.OUTPUT)
    gpio.write(self.pin_in1, gpio.LOW)
    gpio.write(self.pin_in2, gpio.LOW)
  end
end

--Motor type device
Drv8833CtlDevice = class(Device)
function Drv8833CtlDevice:init(id, name, pin_enable, pin_fault)
  self.id = id
  self.name = name
  self.pin_enable = pin_enable
  self.pin_fault = pin_fault
  gpio.mode(self.pin_enable, gpio.OUTPUT)
  gpio.write(self.pin_enable, gpio.LOW)
  gpio.mode(self.pin_fault, gpio.INPUT)
end
function Drv8833CtlDevice:out(value)
  if value > 0 then
    gpio.write(self.pin_enable, gpio.HIGH)
  else
    gpio.write(self.pin_enable, gpio.LOW)
  end
end