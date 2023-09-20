--@name Labyrinth visualizer
--@author Elias

if SERVER then
    local ent=chip():isWeldedTo()
    
    if ent then
        ent:linkComponent(chip())
    end
    
    net.receive("sv_song",function(_,ply)
        net.start("cl_song")
        net.writeTable(table.add(net.readTable(),{ply:getName()}))
        net.send()
    end)
    
    net.receive("sv_sync",function()
        net.start("cl_sync")
        net.writeTable(net.readTable())
        net.send()
    end)
else
    local icons={
        ["resultset_first"]=material.createFromImage("icon16/resultset_first.png",""),
        ["resultset_next"]=material.createFromImage("icon16/resultset_next.png",""),
        ["arrow_refresh"]=material.createFromImage("icon16/arrow_refresh.png",""),
        ["cursor"]=material.createFromImage("icon16/cursor.png","")
    }
    local h1=render.createFont("DermaLarge",20,1000)
    local iterator={}
    local hitboxes={}
    local data={
        songs={
            [1]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1135754862311784559/Backroom_Labyrinth.mp3",
                "Backroom Labyrinth",
                "Oliver Buckland",
                "2:54"
            },
            [2]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1135970304317984809/Let_Me_Carve_Your_Way.mp3",
                "Let Me Carve Your Way",
                "NAOKI",
                "6:00"
            },
            [3]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136847535332401232/death_note_2.mp3",
                "What's up, people?!",
                "MAXIMUM THE HORMONE",
                "4:10"
            },
            [4]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136848426122879016/undertale_playlist.mp3",
                "Undertale playlist",
                "litikce",
                "17:26"
            },
            [5]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136850356769398875/Pandora_Palace.mp3",
                "Pandora Palace",
                "RichaadEB",
                "3:34"
            },
            [6]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136851002830622771/Requiem.mp3",
                "Requiem",
                "Naoki Hashimoto",
                "4:50"
            },
            [7]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136852585177939978/hentai_dude.mp3",
                "Tokyo Chopp",
                "Hentai Dude",
                "3:07"
            },
            [8]={
                "https://dl.dropboxusercontent.com/s/5plu0lzs5jguawb7rapjs/DiosLifeless.mp3?rlkey=ln0dliruiqjy3ef7y69pbtoaz&dl=0",
                "Lifeless",
                "Dios",
                "3:30"
            },
            [9]={
                "https://dl.dropboxusercontent.com/s/61dixogfzkjwgh7s8awe0/Ado.mp3?rlkey=918i742h5cnbb7hu1bigwijef&dl=0",
                "Odori",
                "Ado",
                "3:30"
            },
            [10]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136871914917335040/bad_example.mp3",
                "Bad Example",
                "Takayian",
                "1:44"
            },
            [11]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136872586547056660/how_to_eat_life.mp3",
                "How To Eat Life",
                "Eve MV",
                "3:50"
            },
            [12]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1136873383657746484/kaikaikitan.mp3",
                "Kaikaikitan",
                "Eve MV",
                "3:43"
            },
            [13]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137131723277205634/wheres_your_head_at.mp3",
                "Where's Your Head At",
                "Basement Jaxx",
                "4:46"
            },
            [14]={
                "https://cdn.discordapp.com/attachments/483006214897139712/1137136173219840160/silly_cat_playlist.mp3",
                "Silly cat playlist",
                "Pastel Sataniko",
                "53:02"
            },
            [15]={
                "https://dl.dropboxusercontent.com/s/1z36ufduvjr75qf/supercell%20-%20%E5%90%9B%E3%81%AE%E7%9F%A5%E3%82%89%E3%81%AA%E3%81%84%E7%89%A9%E8%AA%9E.mp3?dl=0",
                "Kimi No Shiranai Monogatari",
                "Supercell",
                "5:44"
            },
            [16]={
                "https://cdn.discordapp.com/attachments/483006214897139712/1137242690203951144/space_confort.mp3",
                "Space Comfort",
                "Zombie",
                "42:17"
            },
            [17]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137443352082661589/see_tinh.mp3",
                "See Tinh",
                "Hoang Thuy Linh",
                "2:45"
            },
            [18]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137490615769251860/meow.mp3",
                "meow",
                "Ivusm #aia2023",
                "2:23"
            },
            [19]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137493014596567101/HOME_-_Resonance.mp3",
                "HOME - Resonance",
                "Electronic Gems",
                "3:32"
            },
            [20]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137607817440804955/Yakuza_0_-_Friday_Night_Extended_Tempest_Studio.mp3",
                "Friday Night - Extended",
                "Onkarian",
                "15:32"
            },
            [21]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1135705559253925938/TheLivingTombstone_-_FNAF_1_Song_Frank_Sinatra_A.I_Cover.mp3",
                "Frank Sinatra FNAF",
                "Yuuto Ichika",
                "3:43"
            },
            [22]={
                "https://cdn.discordapp.com/attachments/1135647931962237090/1137832795700482098/The_Hourglass.mp3",
                "The Hourglass",
                "NAOKI",
                "4:24"
            },
            [23]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1137914240796196994/YT2mp3.info_-_AC_DC_-_Back_In_Black_Official_Video_128kbps.mp3",
                "Back In Black",
                "AC/DC",
                "4:13"
            },
            [24]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1138575299177619526/y2mate.is_-_laurindo_almeida___the_lamp_is_low__slowed___reverbed___rain_-XdRyU1JPYC8-128k-1691527696.mp3",
                "The lamp is low",
                "Laurindo Almeida",
                "14:00"
            },
            [25]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1138669400698920970/YT2mp3.info_-_Out_of_Touch_128kbps.mp3",
                "Out of touch",
                "Daryl Hall & John Oates",
                "4:10"
            },
            [26]={
                "https://cdn.discordapp.com/attachments/1120967741801762919/1139955961277202442/Downtown.mp3",
                "Downtown",
                "Macklemore & Ryan Lewis",
                "4:52"
            }
        },
        scrollOffset=0,
        timeline=0,
        playlist=0,
        author="",
        length=0,
        extra=true,
        lines=5,
        scale=32,
        title="",
        song="",
        time=0,
        mag=2000,
        rgb=false
    }
    local x,y
    
    for i=1, data.lines do
        iterator[i]={}
    end
    
    --if owner()!=player() then return end
    
    local debugging=false
    
    function drawHitbox(id,x,y,x2,y2,callBack,hoverFunction,closeEvent)
        if hitboxes[id] then
            if hitboxes[id][4] and hoverFunction then
                hoverFunction()
            end
            
            if closeEvent then
                closeEvent()
            end
            
            return
        end
        
        hitboxes[id]={
            Vector(x,y),
            Vector(x+x2,y+y2),
            callBack,
            true
        }
    end
    
    function numPanel(offset,var,max,min)
        render.setColor(Color(0,0,0))
        render.drawRect(21,25+offset,140,12)
        render.setColor(Color(150,150,150,data.playlist))
        render.drawRectOutline(21,25+offset,140,12,1)
        render.drawText(34,24+offset,"+"..max,1)
        render.drawText(34+24,24+offset,"+"..min,1)
        render.drawText(24+70,24+offset,var,1)
        render.drawText(34+94,24+offset,"-"..min,1)
        render.drawText(34+116,24+offset,"-"..max,1)
    end
    
    function sync(time)
        net.start("sv_sync")
        net.writeTable({data.rgb,time})
        net.send()
    end
    
    net.receive("cl_sync",function()
        local packet=net.readTable()
        
        data.rgb=packet[1]
        
        if packet[2] then
            data.snd:setTime(packet[2])
        end
    end)
    
    net.receive("cl_song",function()
        packet=net.readTable()
        data.requestedBy=packet[5]
        data.author=packet[3]
        data.title=packet[2]
        data.song=packet[1]
        
        bass.loadURL(data.song, "3d noblock", function(snd,_,err)
            if data.snd then 
                data.snd:stop() 
            end
            
            if snd then
                data.length=snd:getLength()
                data.snd=snd
                data.snd:play()
                
                hook.add("think","",function()
                    data.time=data.snd:getTime()
                    snd:setPos(chip():getPos())
    
                    for i=1, data.lines do
                        local ii=math.floor(i)
                        
                        iterator[data.lines-(ii-1)]=iterator[data.lines-ii]
                    end
                    
                    iterator[1]=snd:getFFT(6-128/data.scale)
                end)
            else
                print(err)
            end
        end)
    end)
    
    hook.add("render","",function()
        if !data.srcx then
            data.srcx=render.getScreenInfo(render.getScreenEntity())["RatioX"]
        end
        
        for i=1, data.lines do
            if !iterator[i] then
                iterator[i]={}
            end
            
            local n=math.clamp(95-(95/data.lines)*i,0,95)

            for ii=0, data.scale do
                
                render.setColor(data.rgb and Color(timer.realtime()*math.min(data.lines*16,1000)-i*30,1,n/100):hsvToRGB() or Color(n,n,n))
                
                if ii>0 then
                    render.draw3DLine(Vector((ii-1)*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii-1] or 0)*data.mag-40-(data.timeline/3-60),(i-1)*50),Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii] or 0)*data.mag-40-(data.timeline/3-60),(i-1)*50))
                end

                if data.extra and iterator[i+1] then
                    local m=math.clamp(70-(70/data.lines)*i-25,0,70)
                    
                    render.setColor(data.rgb and Color(timer.realtime()*math.min(data.lines*16,1000)-i*30,1,m/100):hsvToRGB() or Color(m,m,m))
                    render.draw3DLine(Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[i][ii] or 0)*data.mag-40-(data.timeline/3-60),(i-1)*50),Vector(ii*10.2/1.28*64/data.scale/data.srcx,512-i*20-(iterator[math.clamp(i+1,1,data.lines)][ii] or 0)*data.mag-60-(data.timeline/3-60),(i-1)*50+50))
                end
            end
        end
        
        data.playlist=x and math.clamp(255-Vector(x,0,0):getDistance(Vector(90,0,0))*2+120,0,255) or 0
        
        render.setFont("DermaDefault")
        render.setColor(Color(110,110,110,data.playlist))
        render.drawLine(20,20,200,20)
        
        if data.playlist>0 then
            for i=1,math.min(#data.songs,21) do
                render.setColor(Color(40,40,40,data.playlist))
                render.drawLine(20,41.5+(i-1)*20,200,41+(i-1)*20)
                
                if data.title!=data.songs[i+data.scrollOffset][2] then
                    render.setColor(Color(100,100,100,data.playlist))
                else
                    render.setColor(Color(150,150,150,data.playlist))
                end
                
                render.drawText(50,25+(i-1)*20,data.songs[i+data.scrollOffset][4],2)
                --render.drawText(20,25+(i-1)*20,data.songs[i][3],3)
                render.drawText(80,25+(i-1)*20,string.sub(data.songs[i+data.scrollOffset][2],1,21),3)
                
                drawHitbox(12+i,20.5,25+(i-1)*20,181,13,function()
                    net.start("sv_song")
                    net.writeTable(data.songs[i+data.scrollOffset])
                    net.send()
                end)
            end
            
            if data.extra then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25,12,12,1)
            render.drawText(7.75,24,"E")
            
            drawHitbox(12+#data.songs+1,4.5,25,12,12,function()
                data.extra=not data.extra
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25,140,12)
                render.setColor(Color(150,150,150))
                render.drawRectOutline(21,25,140,12,1)
                render.drawText(24,24,"Disable extra line rendering.")
            end)
            
            if !data.rgb then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25+21,12,12,1)
            render.drawText(7.75,24+21,"R")
            
            drawHitbox(12+#data.songs+2,4.5,25+21,12,12,function()
                data.rgb=not data.rgb
                sync()
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25+21,140,12)
                render.setColor(Color(150,150,150))
                render.drawRectOutline(21,25+21,140,12,1)
                render.drawText(24,24+21,"Enable RGB colors.")
            end)
            
            if !debugging then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25+42,12,12,1)
            render.drawText(7.75,24+42,"D")
            
            drawHitbox(12+#data.songs+3,4.5,25+42,12,12,function()
                debugging=not debugging
                sync()
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25+42,140,12)
                render.setColor(Color(150,150,150))
                render.drawRectOutline(21,25+42,140,12,1)
                render.drawText(24,24+42,"Enable debugging.")
            end)
            
            if !data.linePanel then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25+81,12,12,1)
            render.drawText(7.75,24+81,"L")
            
            drawHitbox(12+#data.songs+4,4.5,25+81,12,12,function()
                if Vector(x,y):withinAABox(Vector(4.5,25+81),Vector(4.5+12,25+81+12)) then
                    data.linePanel=not data.linePanel
                end
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25+81,140,12)
                render.setColor(Color(150,150,150,data.playlist))
                render.drawRectOutline(21,25+81,140,12,1)
                render.drawText(24,24+81,"Shows panel for line control.")
            end)
            
            if data.linePanel then
                numPanel(81,"Lines: "..data.lines,10,1)
            
                drawHitbox(1,28,24+80,20,16,function()
                    data.lines=data.lines+10
                end)
                
                drawHitbox(2,28+23,24+80,20,16,function()
                    data.lines=data.lines+1
                end)
                
                drawHitbox(3,19+99,24+80,20,16,function()
                    data.lines=data.lines-1
                end)
                
                drawHitbox(4,19+115,24+80,20,16,function()
                    data.lines=data.lines-10
                end)
                
                data.lines=math.max(data.lines,0)
            else
                hitboxes[1]=nil
                hitboxes[2]=nil
                hitboxes[3]=nil
                hitboxes[4]=nil
            end
            
            if !data.scalePanel then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25+101,12,12,1)
            render.drawText(7.75,24+101,"S")
            
            drawHitbox(12+#data.songs+5,4.5,25+101,12,12,function()
                if Vector(x,y):withinAABox(Vector(4.5,25+101),Vector(4.5+12,25+101+12)) then
                    data.scalePanel=not data.scalePanel
                end
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25+101,140,12)
                render.setColor(Color(150,150,150,data.playlist))
                render.drawRectOutline(21,25+101,140,12,1)
                render.drawText(24,24+101,"Shows panel for scaling.")
            end)
            
            if data.scalePanel then
                numPanel(101,"Scale: "..data.scale,32,16)
            
                drawHitbox(5,28,24+100,20,16,function()
                    data.scale=data.scale+32
                end)
                
                drawHitbox(6,28+23,24+100,20,16,function()
                    data.scale=data.scale+16
                end)
                
                drawHitbox(7,19+99,24+100,20,16,function()
                    data.scale=data.scale-16
                end)
                
                drawHitbox(8,19+115,24+100,20,16,function()
                    data.scale=data.scale-32
                end)
                
                data.scale=math.max(data.scale,0)
            else
                hitboxes[5]=nil
                hitboxes[6]=nil
                hitboxes[7]=nil
                hitboxes[8]=nil
            end
            
            if !data.magPanel then
                render.setColor(Color(100,100,100,data.playlist))
            else
                render.setColor(Color(150,150,150,data.playlist))
            end
            
            render.drawRectOutline(4.5,25+121,12,12,1)
            render.drawText(6.75,24+121,"M")
            
            drawHitbox(12+#data.songs+6,4.5,25+121,12,12,function()
                if Vector(x,y):withinAABox(Vector(4.5,25+121),Vector(4.5+12,25+121+12)) then
                    data.magPanel=not data.magPanel
                end
            end,function()
                render.setColor(Color(0,0,0))
                render.drawRect(21,25+121,140,12)
                render.setColor(Color(150,150,150,data.playlist))
                render.drawRectOutline(21,25+121,140,12,1)
                render.drawText(24,24+121,"Shows panel for magnifying.")
            end)
            
            if data.magPanel then
                numPanel(121,"Mag: "..data.mag/1000 .."k",1 .."k",0.5 .."k")
            
                drawHitbox(9,28,24+120,20,16,function()
                    data.mag=data.mag+1000
                end)
                
                drawHitbox(10,28+23,24+120,20,16,function()
                    data.mag=data.mag+500
                end)
                
                drawHitbox(11,19+99,24+120,20,16,function()
                    data.mag=data.mag-500
                end)
                
                drawHitbox(12,19+115,24+120,20,16,function()
                    data.mag=data.mag-1000
                end)
                
                data.mag=math.max(data.mag,0)
            else
                hitboxes[9]=nil
                hitboxes[10]=nil
                hitboxes[11]=nil
                hitboxes[12]=nil
            end
        end
        
        data.timeline=y and math.clamp(255-Vector(0,y,0):getDistance(Vector(0,470,0))*3+100,0,255) or 0
        
        if data.timeline>0 then
            render.setColor(Color(100,100,100,data.timeline))
            render.drawLine(100,450,512/data.srcx-100,450)
            
            render.drawText(50,450,math.round(data.time),1)
            --render.drawText(data.srcx-50,450,tonumber(data.length)-tonumber(data.time),1)
            
            drawHitbox(12+#data.songs+7,100,442.5,512/data.srcx-200,15,function()
                if data.snd then
                    sync(data.length*((1000/(512/data.srcx-200))*(x-100)/(1024)))
                end
            end)
            
            local lapsed=math.max((data.time*(100/data.length)/(100/(512/data.srcx-200))),0)
            
            render.setColor(Color(150,150,150,data.timeline))
            render.drawRect(100+lapsed,450-7.5,2,15)
            
            render.setColor(Color(140,140,140,data.timeline))
            render.drawLine(100,450,100+lapsed,450)
            
            --drawHitbox(12+#data.songs+8,100,442.5,512/data.srcx-200,15,function()
            --end)
        end
        
        if data.requestedBy then
            render.setFont("DebugFixedSmall")
            render.setColor(Color(100,100,100,data.playlist))
            render.drawText(111,4,"Request <= "..data.requestedBy,1)
        end
        
        render.setFont(h1)
        render.setColor(Color(100,100,100))
        render.drawText(512/data.srcx-25,50,data.author,2)
        render.setFont("DermaLarge")
        render.drawText(512/data.srcx-25,20,data.title,2)
        
        x,y=render.cursorPos(player())
        
        if x then
            render.setMaterial(icons["cursor"])
            render.setColor(Color(0,0,0))
            render.drawTexturedRect(x-4.2,y-1,14,14)
            render.setColor(Color(255,255,255))
            render.drawTexturedRect(x-3.2,y,12,12)
        end
        
        if !debugging then 
            return 
        end
        
        for id, hitbox in pairs(hitboxes) do
            local topLeft=hitbox[1]
            local bottomRight=hitbox[2]
            
            render.setColor(Color(id*3,1,1):hsvToRGB())
            render.drawLine(topLeft[1],topLeft[2],bottomRight[1],bottomRight[2])
            render.drawRectOutline(topLeft[1],topLeft[2],bottomRight[1]-topLeft[1],bottomRight[2]-topLeft[2],1)
        end
    end)
    
    hook.add("think","cl_hitboxes",function()
        for i, hitbox in pairs(hitboxes) do
            if Vector(x,y):withinAABox(hitbox[1],hitbox[2]) then
                if !hitbox[4] then
                    hitbox[4]=true
                    
                    if hitbox[3] then
                        hook.add("inputPressed","hitId_"..i,function(key)
                            if key==107 then
                                hitbox[3]()
                                return
                            end
                            
                            if key==108 then
                                return
                            end
                        end)
                    end
                    
                    for ii=i+1, #hitboxes do
                        hook.remove("inputPressed","hitId_"..ii)
                    end
                    
                    return
                end
            else
                if hitbox[4] then
                    hitbox[4]=false
                    
                    hook.remove("inputPressed","hitId_"..i)
                end
            end
        end
    end)
    
    hook.add("mouseWheeled","cl_mouse",function(rotate) --create into temeplate function later, too much text wall here
        if Vector(x,y):withinAABox(Vector(20,20),Vector(200,41+(math.min(#data.songs,21)-1)*20)) then 
            data.scrollOffset=math.clamp(data.scrollOffset-rotate,0,#data.songs-21) --may have a bug at a very specific count of folders
            
            table.empty(hitboxes)
            
            return 
        end
    end)
end