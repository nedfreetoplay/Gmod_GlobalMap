local indent = 20
local mapSize = 500
local xPos, yPos = 1,1
local GlobalSizetoZero = 15343

if CLIENT and ScrH()>ScrW() then
	mapSize = ScrW() - indent*2
else
	mapSize = ScrH() - indent*2
end

local settings = {
	size = 5,
	allViewPly = false
}

concommand.Add( "cl_playerssize", function( ply, cmd, args )
	print(args[1])
end )

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
		sizePly:AddOption( "Увеличить", function()
			settings["size"] = settings["size"] + 1 
			print(settings["size"])
			end ):SetIcon( "icon16/add.png" )
		sizePly:AddOption( "Уменьшить", function()
			settings["size"] = settings["size"] - 1
			print(settings["size"])
		end ):SetIcon( "icon16/delete.png" )

		Settings:AddSpacer()

		local allView = Settings:AddOption( "Видеть всех игроков", function()
			if settings[allViewPly] then
				settings[allViewPly] = false
			else
				settings[allViewPly] = true
			end
		end )
		if settings[allViewPly] then
			allView:SetIcon( "icon16/accept.png" )
		else
			allView:SetIcon( "icon16/cancel.png" )
		end

		local SubMenu = Settings:AddSubMenu( "A Sub Settings" )
		SubMenu:AddOption( "Sub Option #1" ):SetIcon( "icon16/group.png" )

		Settings:Open()
	end
--[[
hook.Add( "PlayerButtonDown", "Cl_DoOpenMap", function( ply, button ) --( Player ply, number button ) 23 - Char "M"
	print(button)
	if button == 23 and CLIENT then
		local DFrameMap = vgui.Create( "DFrame" )
		DFrameMap:SetPos( indent, indent )
		DFrameMap:SetSize( mapSize, mapSize )
		DFrameMap:Center()
		DFrameMap:SetTitle( "Map "..game.GetMap() )
		DFrameMap:SetIcon("icon16/map.png")
		DFrameMap:SetDraggable( false )
		DFrameMap:MakePopup()

		local DPanelMap = vgui.Create( "DPanel", DFrameMap )
		DPanelMap:SetPos( 5, 28 )
		DPanelMap:SetSize( mapSize - 10, mapSize - 33 )

		local DImageMap = vgui.Create( "DImage", DPanelMap )
		DImageMap:SetPos( 3, 3 )
		DImageMap:SetSize( mapSize - 16, mapSize - 39 )
		DImageMap:SetName( "DImageMap" )
		DImageMap:SetImage( "ocrp/rockfordmap" )
	end
end )]]