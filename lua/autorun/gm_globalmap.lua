local indent = 20
local mapSize = 500
local xPos, yPos = 1,1
local globalSizeToZero = 15343

if CLIENT then
	if ScrH()>ScrW() then
		mapSize = ScrW() - indent*2
	else
		mapSize = ScrH() - indent*2
	end
end

local settings = {
	map = {
		path = "ocrp/rockfordmap",
		scale = 0
	},
	size = 5,
	allViewPly = false
}

function GM:ContextMenuOpen()
	return false
end

local function GetCenterMapToImage() --Return to xPos, yPos

end
--[[
local function LoadSettings()
	return util.JSONToTable( file.Read( "ad_globalmap.txt", "DATA" ) )
end

local function SaveSettings( settings )
	file.Write( "ad_globalmap.txt", "Test for...")
	--file.Write( "ad_globalmap.txt", util.TableToJSON( settings ))
end

if ( file.IsDir( "ad_globalmap", "DATA" ) ) then
	SaveSettings()
end]]
--[[
concommand.Add( "cl_playerssize", function( ply, cmd, args )
	if tonumber( args[1] ) == nil then
		Error( args[1].." is not a number!" )
	else
		settings[size] = tonumber( args[1] )
	end
	--SaveSettings()
end )]]

--SaveSettings()

function DrawMap( ply, cmd, args )

	local prev_settings = settings
	--settings = LoadSettings()

	if settings == nil then
		settings = prev_settings
	end

	PrintTable(settings)

	if (SERVER) then return end
	
	local DFrameMap = vgui.Create( "DFrame" )
	DFrameMap:SetSize( mapSize, mapSize )
	DFrameMap:Center()
	DFrameMap:SetTitle( "" )
	DFrameMap:SetDraggable( false )
	DFrameMap:MakePopup()

	local DImageButtonSettings = vgui.Create( "DImageButton", DFrameMap )
	DImageButtonSettings:SetImage( "icon16/cog.png" )
	DImageButtonSettings:SizeToContents()
	DImageButtonSettings:SetPos( 5, 5 )

	local DPanelMap = vgui.Create( "DPanel", DFrameMap )
	DPanelMap:SetPos( 5, 28 )
	DPanelMap:SetSize( mapSize - 10, mapSize - 33 )

	local DImageMap = vgui.Create( "DImage", DPanelMap )
	DImageMap:SetPos( 3, 3 )
	DImageMap:SetSize( mapSize - 16, mapSize - 39 )
	DImageMap:SetName( "DImageMap" )
	DImageMap:SetImage( "ocrp/rockfordmap" )

	local DermaButton = vgui.Create( "DButton", DImageMap )
	DermaButton:SetText( "" )
	DermaButton:SetPos( 25, 50 )
	DermaButton:SetSize( 10, 10 )
	DermaButton.DoClick = function()
		RunConsoleCommand( "say", "Hi" )
	end
--[[
	function DImageButtonSettings:DoClick()
		local Settings = DermaMenu()
		local sizePly = Settings:AddSubMenu( "Размер игроков" )
		sizePly:AddOption( "Увеличить", function() settings[size] = settings[size] + 1 end ):SetIcon( "icon16/add.png" )
		sizePly:AddOption( "Уменьшить", function() settings[size] = settings[size] - 1 end ):SetIcon( "icon16/delete.png" )

		if LocalPlayer():IsAdmin() then
			Settings:AddSpacer()
			local allView = Settings:AddOption( "Видеть всех игроков", 
				function() 
					if settings[allViewPly] then
						settings[allViewPly] = false
					else
						settings[allViewPly] = true
					end
				end 
			end )
		end
		if settings[allViewPly] then
			allView:SetIcon( "icon16/accept.png" )
		else
			allView:SetIcon( "icon16/cancel.png" )
		end

		local SubMenu = Settings:AddSubMenu( "A Sub Settings" )
		SubMenu:AddOption( "Sub Option #1" ):SetIcon( "icon16/group.png" )

		Settings:Open()
	end
	SaveSettings()]]
end

concommand.Add( "openmap", DrawMap( ply, cmd, args ))