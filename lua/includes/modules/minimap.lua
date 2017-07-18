AddCSLuaFile()

--[[
f LoadSettings()
f SaveSettings( settings )
f DrawPlayer( panel, ply, size, global )
f GetPlayersPos()
f OpenMap( indent, settings )
]]

--[[
	Name: LoadSettings
	Desc: Загружает файл и помещает информацию из его в массив.
	Return: Table settings
]]
function LoadSettings()
	local defaultSettings = {
		playerSize = 10,
		showPlayers = 0,
		backGroundBlur = true,
		sizeMap = 15216
	}
	if ( file.IsDir( "minimap.dat", "DATA" ) ) then
		return util.JSONToTable( file.Read( "minimap.dat", "DATA" ) )
	else
		return defaultSettings
	end
end

--[[
	Name: SaveSettings
	Desc: Сохраняет настройки карты в файл.
	Parm: Table settings
]]
function SaveSettings( settings )
	file.Write( "minimap.dat", util.TableToJSON( settings ) )
end


--[[
	Name: DrawPlayer
	Desc: Служит для отрисовки игрока на карте в его местоположение и возвращает панель.
]]
function DrawPlayer( panel, ply, size, global )
	local sX, sY = panel:GetSize()
	local player = vgui.Create( "DButton", panel )
	local x = (sX / 2) + ply["x"]/global*sX/2
	local y = (sY / 2) + (-ply["y"])/global*sY/2
	player:SetText( "" )
	player:SetPos( ply["x"] - size/2, ply["y"] - size/2 )
	player:SetSize( size, size )
	return player
end

--[[
Выдаёт массив, содержащий информацию о имени игрока и его координаты.
]]
function GetPlayersPos() 
	local pos = {}

	for k,v in pairs( player.GetAll() ) do
		pos[k] = {}
		pos[k]["name"] = v:GetName()
		pos[k]["x"] = math.floor( v:GetPos().x )
		pos[k]["y"] = math.floor( v:GetPos().y )
	end

	return pos
end

function Settings( ... )

	if #arg < 4 or type( arg[4] ) ~= "table" then 
		Error("Usage: Settings( Panel parent, int xPos, int yPos, table Element1,table Element2, table Element3...)
		\nReturns: table settings
		\n<Elements> structure:
		\n<Label>: { \"DLabel\", string text }
		\n<NumSlider>: { \"DNumSlider\", int xSize, string text, int min, int max, int decimals}
		\n<NextElement>: { \"DNextElement\", ...}")
	end

	local function DerLabel( xPos, yPos, text)
		local DLabel = vgui.Create( "DLabel", arg[1] )
		DLabel:SetPos( xPos, yPos )
		DLabel:SetText( text )

		return DLabel
	end

	local function DerNumSlider( xPos, yPos, xSize, ySize, text, min, max, decimals )
		local DNumSlider = vgui.Create( "DNumSlider", arg[1] )
		DNumSlider:SetPos( xPos, yPos )
		DNumSlider:SetSize( xSize, ySize )
		DNumSlider:SetText( text )
		DNumSlider:SetMinMax( min, max )
		DNumSlider:SetDecimals( decimals )

		return DNumSlider
	end

	local function DrawMenu()
		
		local ind = 30
		local xPos, yPos = arg[2], arg[3]
		local obj = {}

		for k,v in pairs(arg) do
			local elem = v[k + 3]

			if elem[1] == "DLabel" then obj[k] = DerLabel( xPos, yPos + ind * k, elem[2] )
			elseif elem[1] == "DNumSlider" then obj[k] = DerNumSlider( xPos, yPos + ind * k, elem[2], yPos + ind * k, elem[3], elem[4], elem[5], elem[6]) end
		end
		return obj
	end
end

function OpenMap( indent, sett )
	local mapSize = ScrH() - indent*2
	local isSettingsOpen = false
	local sMain

	local main = vgui.Create( "DFrame" )
	main:SetSize( mapSize, mapSize )
	main:Center()
	main:SetBackgroundBlur( true )
	main:SetTitle( "MiniMap" )
	main:SetIcon( "icon16/world.png" )
	main:SetDraggable(false)
	main:MakePopup()

	local settings = vgui.Create( "DButton", main )
	settings:SetPos( 2, 2 )
	settings:SetSize( 90, 20 )
	settings:SetText( "Настройки" )

	local map = vgui.Create( "DPanel", main )
	map:SetSize( mapSize - 8, mapSize - 31 )
	map:SetPos( 4, 27 )

	settings.DoClick = function()
		settings:SetEnabled ( false )
		isSettingsOpen = true
		local yDis = 50

		sMain = vgui.Create( "DFrame" )
		sMain:SetPos( 5, 5 )
		sMain:SetSize( 400, 400 )
		sMain:SetDraggable(false)
		sMain:Center()
		sMain:MakePopup()

		local xSize, ySize = sMain:GetSize()
		local bgPlane = vgui.Create( "DPanel", sMain )
		bgPlane:SetPos( 5, 27 )
		bgPlane:SetSize( xSize - 10, ySize - 32 )

		local playerSize = vgui.Create( "DNumSlider", bgPlane )
		playerSize:SetText( "Размер игрока" )
		playerSize:SetPos( 5, 5 )
		playerSize:SetSize( 300, 100 )
		playerSize:SetMin( 1 )
		playerSize:SetMax( 20 )
		playerSize:SetDecimals( 0 )
		playerSize:SetValue( sett["playerSize"] )

		plyExample = vgui.Create( "DButton", bgPlane )
		plyExample:SetText( "" )
		plyExample:SetPos( 400, 5 )
		plyExample:SetSize( sett["playerSize"], sett["playerSize"] )

		function playerSize:OnValueChanged( v )
			v = math.Round( v )
			plyExample:SetSize( v, v )
			print( "playerSize changed to "..v )
		end


		function sMain:OnClose()
			settings:SetEnabled( true )
			isSettingsOpen = false
		end
	end

	function map:Paint( w, h )
		local mapPoly = {
			{ x = 0, 		   y = 0, 			 u = 0, v = 0 },
			{ x = mapSize - 8, y = 0, 			 u = 1, v = 0 },
			{ x = mapSize - 8, y = mapSize - 31, u = 1, v = 1 },
			{ x = 0, 		   y = mapSize - 31, u = 0, v = 1 }
		}
		surface.SetDrawColor( color_white )
		surface.SetMaterial( Material( "vgui/rp_rockfordmap.png", "noclamp" ) )
		surface.DrawPoly( mapPoly )
	end

	function main:OnClose()
		if isSettingsOpen then
			sMain:Close()
		end
	end
end
