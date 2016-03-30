dofile("ledriver.lua")
dofile("server.lua")


tmr.alarm(3,60000,tmr.ALARM_SINGLE, function() print("Available heap: "..node.heap()) end)
