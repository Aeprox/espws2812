print("Starting http server in 10 seconds..")

tmr.alarm(0, 10000, tmr.ALARM_SINGLE, function() dofile("main.lua") end)