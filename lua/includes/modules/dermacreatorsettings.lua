--[[Settings( 5, 5, 
	{ "Label", "Настройки карты."},
	{ "DNumSlider", 300, 100, "Размер игрока", 1, 20, 0, 10},
	{ "DCheckBoxLabel", "Показывать всех игроков.", 0}
)]]

function Settings( ... )

	if #arg < 4 or type( arg[4] ) ~= "table" then
		Error("Usage: Settings( int xPos, int yPos, table Element1,table Element2, table Element3...)
		\nReturns: table
		\n<Elements> structure:
		\n<Label>: {\"DLabel\", string text}
		\n<NumSlider>: {\"DNumSlider\", int xSize, ySize, string text, int min, int max, int decimals, int value}
		\n<Button>: {\"DButton\", int xSize, int ySize, string text}
		\n<DerCheckBoxLabel>: {\"DCheckBoxLabel\", string text, int value}")
	end

	--[[
	Name: DermaLabel
	Desc: Создаёт надпись в заданых координатах.
	]]
	local function DermaLabel( par, xPos, yPos, text)
		local DLabel = vgui.Create( "DLabel", par )
		DLabel:SetPos( xPos, yPos )
		DLabel:SetText( text )

		return DLabel
	end

	--[[
	Name: DermaNumSlider
	Desc: Создаёт слайдер для выбора значения в определённом диапазоне.
	]]
	local function DermaNumSlider( par, xPos, yPos, xSize, ySize, text, min, max, decimals, value )
		local DNumSlider = vgui.Create( "DNumSlider", par )
		DNumSlider:SetPos( xPos, yPos )
		DNumSlider:SetSize( xSize, ySize )
		DNumSlider:SetText( text )
		DNumSlider:SetMinMax( min, max )
		DNumSlider:SetDecimals( decimals )
		playerSize:SetValue( value )

		return DNumSlider
	end

	--[[
	Name: DermaButton
	Desc: Создаёт кнопку, которую можно использовать в каком либо событии.
	]]
	local function DermaButton( par, xPos, yPos, xSize, ySize, text, sizeToContents )
		local DButton = vgui.Create( "DButton", par )
		DButton:SetText( text )
		DButton:SetPos( xPos, yPos )
		DButton:SetSize( xSize, ySize )
		if sizeToContents then
			DButton:SizeToContents()
		end

		return DButton
	end

	--[[
	Name: DermaCheckBoxLabel
	Desc: Создаёт чек бокс, который содержит в себе boolean значение.
	]]
	local function DermaCheckBoxLabel( par, xPos, yPos, text, value )
		local DCheckbox = vgui.Create( "DCheckBoxLabel", par )
		DCheckbox:SetPos( xPos, yPos )
		DCheckbox:SetText( text )
		DCheckbox:SetValue( value )
		DCheckbox:SizeToContents()

		return DCheckbox
	end

	--[[local function getValue( p )
		local name = p:GetName()
		if name == "DNumSlider" then return p:GetValue()
			elseif name == "DCheckBoxLabel" then 
		end
	end]]

	local obj = {}
	local settings = {}
	local ind = 30
	local xSize, ySize = 300, (#arg - 4) * ind + ind

	local main = vgui.Create( "DFrame" )
	main:SetSize( xSize, ySize )
	main:SetDraggable(false)
	main:Center()
	main:MakePopup()

	local DSett = vgui.Create( "DPanel", main )
	DSett:SetPos( 5, 27 )
	DSett:SetSize( xSize - 10, ySize - 32 )
	local xPos, yPos = arg[2], arg[3]

	for i=1, #arg - 4 do
		local elem = arg[k + 4]
		local classname = elem[1]

		if classname == "DLabel" then DermaLabel( main, xPos, yPos + ind * k, elem[2] )
			elseif classname == "DNumSlider" then DermaNumSlider( main, xPos, yPos + ind * k, elem[2], elem[3], elem[4], elem[5], elem[6], elem[7], elem[8])
			elseif classname == "DButton" then DermaButton( main, xPos, yPos + ind * k, elem[2], elem[3], elem[4])
			elseif classname == "DCheckBoxLabel" then DermaCheckBoxLabel( main, xPos, yPos + ind * k, elem[2], elem[3])
		end
	end

	DermaButton( xPos, yPos + ind * #a, 300, 100, "Сохранить" )
	return main
end