function load(filename)
  local file_lua = filename..".lua"
  if file.exists(file_lua) then
    node.compile(file_lua)
    file.remove(file_lua)
  end

  local file_lc = filename..".lc"
  if file.exists(file_lc) then
    return loadfile(file_lc)
  end
  return nil
end
function exec(filename)
  local f = load(filename)
  if f == nil then
    return false
  end
  f()
  return true
end

function main()
  if (not exec("lua_utils")) or 
     (not exec("joy_os")) then
    print("missing core files")
    return
  end

  joyOS = JoyOS:new()
  joyOS:run()
end

--Delayed 1 ms execution because i don't want the ">" output that's put automatically after the init
local delayed = tmr.create()
delayed:alarm(1, tmr.ALARM_SINGLE, main)
