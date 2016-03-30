page = "index.html"
script = "cwheelmin.js"

-- init
if(sv==nil) then
    sv = net.createServer(net.TCP, 30)
end

sv:listen(80, function(socket)
    socket:on("receive", function(c, request)      
        local _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
    
        -- ignore favicon request
        if ((string.find(path,"favicon")) ~= nil) then
            socket:send("HTTP/1.1 404 File not found")
            socket:close()
            socket = nil
            collectgarbage()

        -- send colorwheel javascript file
        elseif (string.find(path,".js")) ~= nil then
            sendfile(socket,script)
            

        -- send html file and/or parse params    
        else
            local _GET = {}

            local vars = string.match(path,"?(.+)$")
            if (vars ~= nil)then
                for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                    _GET[k] = v
                end
            end
            
            print(method, path, vars)
            
            if ((string.find(path,"/rainbow$")) ~= nil) then
                setRainbow()
            elseif ((string.find(path,"/flowbow$")) ~= nil) then
                setRunningRainbow(50,5)
            elseif ((string.find(path,"/off$")) ~= nil) then
                setAll(0,0,0)
            elseif ((string.find(path,"/setAll")) ~= nil) then
                setAll(_GET["r"],_GET["g"],_GET["b"])
            elseif ((string.find(path,"/setAjax")) ~= nil) then
                setAll(_GET["r"],_GET["g"],_GET["b"])
                socket:send("HTTP/1.1 200 OK")
                socket:close()
                socket = nil
                collectgarbage()
                return
            elseif ((string.find(path,"/$")) ~= nil) then
                -- show index.html
            else
                print("Bad request")
                socket:send("HTTP/1.1 500 Bad request")
                socket:close()
                socket = nil
                collectgarbage()
                return
            end
            
            sendfile(socket,page)            
        end
    end)
end)


function sendfile(socket, filename)
    print("sending "..filename)
    -- check file size
    l = file.list()
    local files = {}
    for k,v in pairs(l) do
      files[k]=v
    end
    length = files[filename] 
    print(length)
    
    -- if larger than 1024 bytes, send in chunks
    if (length > 1024) then
        local currentchunk = 1 

        file.open(filename, mode)
        
        socket:on("sent", function(socket)
            print("sent chunk")
            if (length < (currentchunk-1)*1024) then -- if last chunk, close socket
                socket:close()
                file.close(filename)
                print("Socket closed, sent "..length.." bytes")
            else
                socket:send(readchunk(filename,length,currentchunk))
                print("sending chunk "..currentchunk)
                currentchunk = currentchunk +1
            end
        end)
        print("sending chunk "..currentchunk)
        socket:send(readchunk(filename,length,currentchunk))
        currentchunk = currentchunk + 1
    
    -- else just send as one  
    else 
        local filec = openfile(filename)
        socket:on("sent", function(socket)
            socket:close()
            print("Socket closed, sent "..string.len(filec).." bytes")
        end)
        socket:send(filec)
    end  
end

-- use file.read() ONLY FOR FILES UNDER 1024 bytes
function openfile(filename)
    file.open(filename)
    local content = file.read()
    file.close(filename)
    return content
end

function readchunk(filename, filesize, chunk)
    local linetable = {}
    local fline = ""
    local cchar = 1
    local cline = 1
    
   -- read till EOF or 1024 bytes
    fline=file.readline()
    while (fline ~= nil and cchar <= 1024) do
        linetable[cline]=fline
        cchar = cchar + string.len(fline)
        cline = cline + 1

        fline=file.readline()
    end

    return table.concat(linetable)
end
