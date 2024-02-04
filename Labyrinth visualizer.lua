--@name Labyrinth visualizer
--@author Elias
       
version=2.4
repo="https://raw.githubusercontent.com/grammyy/Labyrinth-visualizer/main/version"

http.get("https://raw.githubusercontent.com/grammyy/SF-linker/main/linker.lua?time="..timer.realtime(),function(packet)
    loadstring(packet)()
    
    load({
        ["https://raw.githubusercontent.com/grammyy/Playlist-SF-LIB/main/playlist%20lib.lua"]=function()
            if CLIENT then
                data.scrollOffset=0
                data.scale=32
                data.lines=4
                data.mag=2000
                data.extra=true
                data.rgb=false
                
                sndFFT=function(FFT)
                    for i=0, data.lines do
                        iterator[data.lines-(i-1)]=iterator[data.lines-i]
                    end
                    
                    iterator[0]=FFT
                end
            end
        end
    })
    
    if CLIENT then
        load({
            "https://raw.githubusercontent.com/grammyy/SF-linker/main/public%20libs/version%20changelog.lua",
            ["https://raw.githubusercontent.com/grammyy/hitbox-lib-SF/main/lib/hitbox_lib.lua"]=function()
                hitboxes.filter=function(key)
                    if key==15 then
                        return true
                    end
                end
            end
        })
    end
end)

if SERVER then
    local ent=chip():isWeldedTo()
    
    if ent then
        ent:linkComponent(chip())
    end
else
    local icons={
        ["resultset_first"]=material.createFromImage("icon16/resultset_first.png",""),
        ["resultset_next"]=material.createFromImage("icon16/resultset_next.png",""),
        ["arrow_refresh"]=material.createFromImage("icon16/arrow_refresh.png",""),
        ["cursor"]=material.createFromImage("icon16/cursor.png","")
    }
    local h1=render.createFont("DermaLarge",20,1000)
    iterator={}
    
    function increment(increments,int,decrease)
        data[increments[1]]=data[increments[1]]+(decrease and -increments[int] or increments[int])
    
        data.lines=math.max(data.lines,1)
        data.scale=math.max(data.scale,1)
    end
    
    function incrementHitbox(y,id,increments,offset,format,textX,text,int,decrease)
        hitboxes.create(1,id,y,24+offset-1,20,16,function()
            increment(increments,int,decrease)
        end,function()
            render.setColor(Color(200,200,200,data.playlist))
        end,function()
            render.drawText(textX,24+offset,text,1)
            render.setColor(Color(150,150,150,data.playlist))
        end)
    end

    function setting(sync,y,name,id,info,invert,increments,offset,format)
        if (invert and data[name] or not data[name]) then
            render.setColor(Color(100,100,100,data.playlist))
        else
            render.setColor(Color(150,150,150,data.playlist))
        end
        
        render.drawRectOutline(4.5,y,12,12,1)
        render.drawText(4.5+1,y-1,string.upper(name[1]))
        
        if increments and data[name] then
            render.setColor(Color(0,0,0,data.playlist))
            render.drawRect(21,25+offset,140,12)
            render.setColor(Color(150,150,150,data.playlist))
            render.drawRectOutline(21,25+offset,140,12,1)
            render.drawText(94,24+offset,increments[2],1)
            
            incrementHitbox(25,id*4-1,increments,offset,format,34,"+"..(format and increments[4]/1000 .."k" or increments[4]),4)
            incrementHitbox(25+23,id*4-2,increments,offset,format,34+24,"+"..(format and increments[3]/1000 .."k" or increments[3]),3)
            incrementHitbox(19+98,id*4-3,increments,offset,format,34+94,"-"..(format and increments[3]/1000 .."k" or increments[3]),3,true)
            incrementHitbox(19+122,id*4-4,increments,offset,format,34+116,"-"..(format and increments[4]/1000 .."k" or increments[4]),4,true)
        end
        
        hitboxes.create(3,id,4.5,y,12,12,function(key)
            data[name]=not data[name]
            hitboxes.debug=data.debugging
            
            if sync==true or (sync=="owner" and data.sender==owner():getName())then
                enviorment={
                    lock=data.lock,
                    rgb=data.rgb
                }
                
                netSend({})
            end
            
            if data.lock then
                hitboxes.purge()
            else
                hitboxes.clear(1)
            end
        end,function()
            render.setColor(Color(0,0,0))
            render.drawRect(4.5+16.5,y,140,12)
            render.setColor(Color(150,150,150))
            render.drawRectOutline(4.5+16.5,y,140,12,1)
            render.drawText(24,y-1,info)
        end)
    end

    hook.add("render","",function()
        if !data or !hitboxes then
            return
        end

        if !data.srcx then
            data.srcx=render.getScreenInfo(render.getScreenEntity()).RatioX
        end

        data.timeline=(y and data.time and data.length and !data.lock) and math.clamp(255-Vector(0,y,0):getDistance(Vector(0,470,0))*3+100,0,255) or 0
        data.playlist=(x) and math.clamp(255-Vector(x,0,0):getDistance(Vector(90,0,0))*2+120,0,255) or 0

        for i=0, data.lines do
            if !iterator[i] then
                iterator[i]={}
            end
            
            local n=math.clamp(95-(95/data.lines)*i,0,95)

            for ii=0, data.scale do
                
                render.setColor(data.rgb and Color(timer.realtime()*math.min(data.lines*16,1000)-i*30,1,n/100):hsvToRGB() or Color(n,n,n))
                
                if ii>0 then
                    render.draw3DLine(Vector((ii-1)*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii+1] or 0)*data.mag-60-(data.timeline/3-60),i*50),Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii+2] or 0)*data.mag-60-(data.timeline/3-60),i*50))
                end
                
                if data.extra and iterator[i+1] then
                    local m=math.clamp(70-(70/data.lines)*i-25,0,70)
                    
                    render.setColor(data.rgb and Color(timer.realtime()*math.min(data.lines*16,1000)-i*30,1,m/100):hsvToRGB() or Color(m,m,m))
                    render.draw3DLine(Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii+2] or 0)*data.mag-60-(data.timeline/3-60),i*50),Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[math.clamp(i+1,1,data.lines)][ii+2] or 0)*data.mag-80-(data.timeline/3-60),i*50+50))
                end
            end
        end
        
        render.setFont("DermaDefault")
        
        if data.playlist>0 and !data.lock and data.songs then
            render.setColor(Color(0,0,0,math.min(data.playlist,150)))
            render.drawRectFast(0,0,200,41+(21)*20)
            
            render.setColor(Color(110,110,110,data.playlist))
            render.drawLine(20,20,200,20)
            
            for i=1,math.min(#data.songs,21) do
                render.setColor(Color(40,40,40,data.playlist))
                render.drawLine(20,41.5+(i-1)*20,200,41+(i-1)*20)
                
                if data.song and data.song.title==data.songs[i+data.scrollOffset].title then
                    render.setColor(Color(150,150,150,data.playlist))
                else
                    render.setColor(Color(100,100,100,data.playlist))
                end
                
                render.drawText(50,25+(i-1)*20,data.songs[i+data.scrollOffset][4],2)
                render.drawText(80,25+(i-1)*20,string.sub(data.songs[i+data.scrollOffset][2],1,21),3)
                
                hitboxes.create(4,i,20.5,25+(i-1)*20,181,13,function(key)
                    if key!=15 then
                        return
                    end
                    
                    netSend({
                        song=data.songs[i+data.scrollOffset]
                    })
                end)
            end
            
            if data.sender then
                render.setFont("DebugFixedSmall")
                render.setColor(Color(100,100,100,data.playlist))
                render.drawText(111,4,"Requested <= "..data.sender,1)
                render.setFont("DermaDefault")
            end
        end

        setting("owner",5,"lock",1,"Lock controls")
        
        if !data.lock then
            setting(false,25,"extra",2,"Disable extra line rendering.")
            setting(true,46,"rgb",3,"Enable RGB colors.")
            setting(false,67,"debugging",4,"Enable debugging.")
            setting(false,106,"linePanel",5,"Shows panel for line control.",false,{"lines","Lines: "..data.lines,1,10},81)
            setting(false,126,"scalePanel",6,"Shows panel for scaling.",false,{"scale","Scale: "..data.scale,16,32},101)
            setting(false,146,"magPanel",7,"Shows panel for scaling.",false,{"mag","Mag: "..data.mag/1000 .."k",500,1000},121,true)
        end
            
        if !data.songs then
            return
        end
        
        if data.timeline>0 then
            render.setColor(Color(100,100,100,data.timeline))
            render.drawLine(100,451,512/data.srcx-100,450)
            
            render.drawText(50,444,string.toHoursMinutesSeconds(data.time),1)
            render.drawText((512/data.srcx)-50,444,string.toHoursMinutesSeconds(data.length-data.time),1)
            
            hitboxes.create(2,1,100,442.5,512/data.srcx-200,15,function(key)
                if data.snd then
                    netSend({
                        time=data.length*((1000/(512/data.srcx-200))*(x-100)/(1024))
                    })
                end
            end)
            
            local lapsed=math.max((data.time*(100/data.length)/(100/(512/data.srcx-200))),0)
            
            render.setColor(Color(150,150,150,data.timeline))
            render.drawRect(100+lapsed,451-7.5,2,15)
            
            render.setColor(Color(140,140,140,data.timeline))
            render.drawLine(100,451,100+lapsed,450)
        end
        
        render.setFont(h1)
        render.setColor(Color(100,100,100))
        render.drawText(512/data.srcx-25,50,data.song and data.song.author or "",2)
        render.setFont("DermaLarge")
        render.drawText(512/data.srcx-25,20,data.song and data.song.title or "",2)
        
        if x and !data.lock then
            render.setMaterial(icons["cursor"])
            render.setColor(Color(0,0,0))
            render.drawTexturedRect(x-4.2,y-1,14,14)
            render.setColor(Color(255,255,255))
            render.drawTexturedRect(x-3.2,y,12,12)
        end
    end)
    
    hook.add("mouseWheeled","cl_mouse",function(delta)
        if data and hitboxes and data.songs and Vector(x,y):withinAABox(Vector(20,20),Vector(200,41+(math.min(#data.songs,21)-1)*20)) then 
            data.scrollOffset=math.clamp(data.scrollOffset-delta,0,#data.songs-21)
            
            hitboxes.clear(2)
            
            return 
        end
    end)
end