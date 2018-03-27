function class(base, new)
  local klass = {}
  klass.__index = klass
  if base ~= nil then
    setmetatable(klass, base)
  end
  function klass:new(...)
    local obj = {}
    setmetatable(obj,klass)
    obj:init(...)
    return obj
  end
  return klass
end

function print_n(msg)
  uart.write(0, msg)
end