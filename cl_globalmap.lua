local settings = {
	size = 5,
	allViewPly = false
}

local function LoadSettings()
	return util.JSONToTable( file.Read( "ad_globalmap.json", "DATA" ) )
end

local function SaveSettings( settings )
	file.Write( "ad_globalmap.json", util.TableToJSON( settings ))
end

concommand.Add( "cl_playerssize", function( ply, cmd, args )
	if tonumber( args[1] ) == nil then
		Error( "arg is not a number" )
	else
		settings["size"] = tonumber( args[1] )
	end
	SaveSettings()
end )

SaveSettings()

concommand.Add( "cl_openmap", function( ply, cmd, args )
	if SERVER then return nil end

	settings = LoadSettings()

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
	SaveSettings()
end )