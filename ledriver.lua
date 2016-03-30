ws2812pin = 2 --is currently ignored by ws2812 module
numPixels = 30 --max 255

ledTable = {}
fxcounter = 0
fxtimer = 1

sinetable = {6,13,19,25,31,38,44,50,56,62,68,74,80,86,92,98,104,109,115,121,126,132,137,142,147,152,157,162,167,172,176,
181,185,190,194,198,202,205,209,213,216,219,222,225,228,231,234,236,238,241,243,244,246,248,249,250,251,252,253,254,254,
255,255,255,255,255,254,254,253,252,251,250,248,247,245,243,242,239,237,235,232,230,227,224,221,218,214,211,207,203,200,
196,192,187,183,179,174,169,165,160,155,150,145,140,134,129,123,118,112,107,101,95,89,83,77,71,65,59,53,47,41,34,28,22,16,
9,3,-3,-9,-16,-22,-28,-34,-41,-47,-53,-59,-65,-71,-77,-83,-89,-95,-101,-107,-112,-118,-123,-129,-134,-140,-145,-150,-155,
-160,-165,-169,-174,-179,-183,-187,-192,-196,-200,-203,-207,-211,-214,-218,-221,-224,-227,-230,-232,-235,-237,-239,-242,
-243,-245,-247,-248,-250,-251,-252,-253,-254,-254,-255,-255,-255,-255,-255,-254,-254,-253,-252,-251,-250,-249,-248,-246,
-244,-243,-241,-238,-236,-234,-231,-228,-225,-222,-219,-216,-213,-209,-205,-202,-198,-194,-190,-185,-181,-176,-172,-167,
-162,-157,-152,-147,-142,-137,-132,-126,-121,-115,-109,-104,-98,-92,-86,-80,-74,-68,-62,-56,-50,-44,-38,-31,-25,-19,-13,-6,0
}


function goround255(value,add)
    if(value+add) > 255 then
        return ((value+add)-255)
    else
        return value+add
    end
end

function floor0(value)
    if value < 0 then
        return 0
    else
        return value
    end
end

function flowbow(step)
    fxcounter = goround255(fxcounter,step)
    setRainbow(fxcounter)
end


function setAll(r,g,b)
    tmr.stop(fxtimer)
    leds_grb = string.char(g,r,b) 
    ws2812.write(ws2812pin, leds_grb:rep(numPixels))
end

function setRainbow(offset)
    if offset == nil then
        offset = 1
        tmr.stop(fxtimer)
    end
    for i=0, numPixels-1 do
            ledTable[(i*3)+1] = string.char(floor0(sinetable[goround255(goround255(i,offset),85)])) -- offset by 120°  string.char(0)--
            ledTable[(i*3)+2] = string.char(floor0(sinetable[goround255(i,offset)]))
            ledTable[(i*3)+3] = string.char(floor0(sinetable[goround255(goround255(i,offset),170)])) -- offset by 240° string.char(0)--
    end

    output = table.concat(ledTable)
    ws2812.write(ws2812pin, output)
end

function setRunningRainbow(delay,step)
    tmr.alarm(fxtimer, delay, tmr.ALARM_AUTO, function() flowbow(step) end)
end
