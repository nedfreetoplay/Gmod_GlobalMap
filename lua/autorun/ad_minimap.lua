AddCSLuaFile()

---------------------------------Variables---------------------------------

local isSettingsOpen = false
local isMinimapOpen = false

---------------------------------Constans---------------------------------

local indent = 20
local LocalPlayer

---------------------------------Methods---------------------------------

local function isOpen()

	return isMinimapOpen

end

local function Close()

		if isMinimapOpen then
			Window:Close()
		end

end

local function Create( settings )

	local windowSize = ScrH() - indent*2
	local Settings = settings

	--
	--Create the window
	--
	local Window = vgui.Create( "DFrame" )
	Window:SetSize( mapSize, mapSize )
	Window:Center()
	Window:SetBackgroundBlur( Settings.backgroundBlur )
	Window:SetDraggable(false)
	Window:MakePopup()

	--
	--Create the image map
	--
	Image = vgui.Create( "DPanel", Window )
	Image:SetSize( mapSize - 8, mapSize - 31 )
	Image:SetPos( 4, 27 )

	--
	--Create the button settings
	--
	ButtonSettings = vgui.Create( "DButton", Window )
	ButtonSettings:SetPos( 2, 2 )
	ButtonSettings:SetSize( 90, 20 )
	ButtonSettings:SetText( "Настройки" )

	function ButtonSettings:DoClick()

		ButtonSettings:SetEnabled ( false )
		isSettingsOpen = true

		local WindowSettings = vgui.Create( "DFrame", Image )
		WindowSettings:SetSize( 300, 30 * 4 )
		WindowSettings:Center()
		WindowSettings:SetText( "Окно настроек" )

		local PlayerSize = vgui.Create( "DNumSlider", WindowSettings )
		PlayerSize:SetPos( 5, 10 )
		PlayerSize:SetSize( 200, 30 )
		PlayerSize:SetMinMax( 1, 20 )
		PlayerSize:SetValue( Settings["playerSize"] )
		PlayerSize:SetDecimals( 0 )

		local BackgroundBlur = vgui.Create( "DCheckBoxLabel", WindowSettings )
		BackgroundBlur:SetParent( DermaPanel )
		BackgroundBlur:SetPos( 25, 40 )
		BackgroundBlur:SetText( "Background Blur" )
		BackgroundBlur:SetValue( Settings["backgroundBlur"] )
		BackgroundBlur:SizeToContents()	

		local SaveSettings = vgui.Create( "DButton", WindowSettings )
		SaveSettings:SetPos( 5, 70 )
		SaveSettings:SetSize( 200, 30 )
		SaveSettings:SetText( "Применить" )

		function SaveSettings:DoClick()

			Settings["playerSize"] = PlayerSize:GetValue()
			Settings["backgroundBlur"] = BackgroundBlur:GetChecked()
			WindowSettings:Remove()

			SaveSettings( Settings )

		end

		function WindowSettings:OnClose()

			ButtonSettings:SetEnabled( true )
			isSettingsOpen = false

		end

	end

	function Image:Paint( w, h )

		local mapPoly = {
			{ x = 0,           y = 0,            u = 0, v = 0 },
			{ x = mapSize - 8, y = 0,            u = 1, v = 0 },
			{ x = mapSize - 8, y = mapSize - 31, u = 1, v = 1 },
			{ x = 0,           y = mapSize - 31, u = 0, v = 1 }
		}

		surface.SetDrawColor( color_white )
		surface.SetMaterial( Material( "vgui/rp_rockfordmap.png", "noclamp" ) )
		surface.DrawPoly( mapPoly )

	end

	function Window:OnClose()

		isMinimapOpen = false

		if isSettingsOpen then
			sMain:Close()
		end

	end

end

local function LoadSettings()

	local defaultSettings = {
		playerSize = 10,
		showPlayers = 0,
		backgroundBlur = true,
		sizeMap = 15216
	}

	if ( file.IsDir( "minimap.dat", "DATA" ) ) then
		return util.JSONToTable( file.Read( "minimap.dat", "DATA" ) )
	else
		return defaultSettings
	end

end

local function SaveSettings( s )

	file.Write( "minimap.dat", util.TableToJSON( s ) )

end

local function DrawPlayer( panel, ply, size, global )

	local sX, sY = panel:GetSize()
	local player = vgui.Create( "DButton", panel )
	local x = (sX / 2) + ply["x"]/global*sX/2
	local y = (sY / 2) + (-ply["y"])/global*sY/2
	player:SetText( "" )
	player:SetPos( ply["x"] - size/2, ply["y"] - size/2 )
	player:SetSize( size, size )
	return player

end

local function GetPlayersPos( p ) -- player.GetAll()

	local pos = {}

	for k,v in pairs( p ) do
		pos[k] = {}
		pos[k].name = v:GetName()
		pos[k].x = math.floor( v:GetPos().x )
		pos[k].y = math.floor( v:GetPos().y )
		pos[k].z = math.floor( v:GetPos().z )
	end

	return pos

end

---------------------------------Program---------------------------------

function GM:InitPostEntity()
	LocalPlayer = LocalPlayer()
end

hook.Add( "Think", "Client_Minimap_Open", function()

	if LocalPlayer == nil then return end

	if Minimap.isOpen() == false and input.IsKeyDown( KEY_M ) then
		Minimap.Create( LoadSettings() )
	end

end )

--[[local pos = GetPlayersPos()
for k,v in pairs(pos) do
	ply..k = DrawPlayer( map, v, 10, 15216 )
	function ply..k:DoClick()

	end
end]]
--OpenMap( 20, LoadSettings() )

--SaveSettings( LoadSettings() )