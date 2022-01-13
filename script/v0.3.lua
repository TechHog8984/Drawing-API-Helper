local function tableadd(...)
	local Result = {}

	for I, Table in next, {...} do
		for I, V in next, Table do
			table.insert(Result, V)
		end
	end

	return Result
end
local function tablecombine(...)
	local Result = {}

	for I, Table in next, {...} do
		for I, V in next, Table do
			Result[I] = V
		end
	end

	return Result
end

local Draw = Drawing
local DrawNew = Draw.new
local Fonts = Drawing.Fonts
local Helper = {}

local ExpectedDrawingProperties = {
	Visible = 'boolean',
	ZIndex = 'number',
	Transparency = 'number',
	Color = 'Color3',
}

local ExpectedObjectProperties = {
	Name = 'string',
	ClassName = 'string',
}

Helper.ExpectedDrawingProperties = ExpectedDrawingProperties
Helper.ExpectedObjectProperties = ExpectedObjectProperties

local ExpectedSquareProperties = {
	Thickness = 'number',
	Size = 'Vector2',
	Position = 'Vector2',
	Filled = 'boolean',
}
local ExpectedDrawingLineProperties = {
	Thickness = 'number',
	From = 'Vector2',
	To = 'Vector2',
}
local ExpectedDrawingTextProperties = {
	Text = 'string',
	Size = 'number',
	Center = 'boolean',
	Outline = 'boolean',
	OutlineColor = 'Color3',
	Position = 'Vector2',
	TextBounds = 'Vector2',
	Font = 'Drawing.Font,number',
}
local ExpectedDrawingImageProperties = {
	Data = 'string',
	Size = 'Vector2',
	Position = 'Vector2',
	Rounding = 'number',
}
local ExpectedDrawingCircleProperties = {
	Thickness = 'number',
	NumSides = 'number',
	Radius = 'number',
	Filled = 'boolean',
	Position = 'Vector2',
}
local ExpectedDrawingQuadProperties = {
	Thickness = 'number',
	PointA = 'Vector2',
	PointB = 'Vector2',
	PointC = 'Vector2',
	PointD = 'Vector2',
	Filled = 'boolean',
}

Helper.ExpectedSquareProperties = ExpectedSquareProperties
Helper.ExpectedDrawingLineProperties = ExpectedDrawingLineProperties
Helper.ExpectedDrawingTextProperties = ExpectedDrawingTextProperties
Helper.ExpectedDrawingImageProperties = ExpectedDrawingImageProperties
Helper.ExpectedDrawingCircleProperties = ExpectedDrawingCircleProperties
Helper.ExpectedDrawingQuadProperties = ExpectedDrawingQuadProperties

local DefaultRectangleProperties = {
	ClassName = 'Rectangle',
	Name = 'Rectangle',
}
local DefaultLineProperties = {
	ClassName = 'Line',
	Name = 'Line',
}
local DefaultTextProperties = {
	ClassName = 'Text',
	Name = 'Text',
}
local DefaultImageProperties = {
	ClassName = 'Image',
	Name = 'Image',
}
local DefaultCircleProperties = {
	ClassName = 'Circle',
	Name = 'Circle',
}
local DefaultQuadProperties = {
	ClassName = 'Quad',
	Name = 'Quad',
}

Helper.DefaultRectangleProperties = DefaultRectangleProperties
Helper.DefaultLineProperties = DefaultLineProperties
Helper.DefaultTextProperties = DefaultTextProperties
Helper.DefaultImageProperties = DefaultImageProperties
Helper.DefaultCircleProperties = DefaultCircleProperties
Helper.DefaultQuadProperties = DefaultQuadProperties

local DefaultDrawingProperties = {
	Visible = true,
	ZIndex = 0,
	Transparency = 1,
	Color = Color3.new(1, 1, 1),
}
local DefaultSquareProperties = {
	Thickness = 3,
	Size = Vector2.new(16, 16),
	Position = Vector2.new(16, 16),
	Filled = true,
}
local DefaultDrawingLinePropertes = {
	Thickness = 3,
}
local DefaultDrawingTextProperties = {
	Size = 18,
	Center = true,
	Outline = false,
	Font = Fonts.Monospace --3,
}
local DefaultDrawingImageProperties = {
	Data = game:HttpGet'https://x.synapse.to/favicon.ico',
}
local DefaultDrawingCircleProperties = {
	Thickness = 3,
	Radius = 70,
	Filled = true,
}
local DefaultDrawingQuadProperties = {
	Thickness = 3,
	Filled = true,
}

Helper.DefaultDrawingProperties = DefaultDrawingProperties
Helper.DefaultSquareProperties = DefaultSquareProperties
Helper.DefaultDrawingLinePropertes = DefaultDrawingLinePropertes
Helper.DefaultDrawingTextProperties = DefaultDrawingTextProperties
Helper.DefaultDrawingImageProperties = DefaultDrawingImageProperties
Helper.DefaultDrawingCircleProperties = DefaultDrawingCircleProperties
Helper.DefaultDrawingQuadProperties = DefaultDrawingQuadProperties

local SupportedObjects = {
	Rectangle = {
		DrawingType = 'Square',
		ExpectedDrawingProperties = ExpectedSquareProperties,
		DefaultDrawingProperties = DefaultSquareProperties,
	},
	Line = {
		ExpectedDrawingProperties = ExpectedDrawingLineProperties,
		DefaultDrawingProperties = DefaultDrawingLinePropertes,
	},
	Text = {
		ExpectedDrawingProperties = ExpectedDrawingTextProperties,
		DefaultDrawingProperties = DefaultDrawingTextProperties,
	},
	Image = {
		ExpectedDrawingProperties = ExpectedDrawingImageProperties,
		DefaultDrawingProperties = DefaultDrawingImageProperties,
	},
	Circle = {
		ExpectedDrawingProperties = ExpectedDrawingCircleProperties,
		DefaultDrawingProperties = DefaultDrawingCircleProperties,
	},
	Quad = {
		ExpectedDrawingProperties = ExpectedDrawingQuadProperties,
		DefaultDrawingProperties = DefaultDrawingQuadProperties,
	},
}

local function IDtype(Value)
	local typeof = typeof(Value)

	--will have support for Drawing.Fonts and other types
	return typeof
end
local function ValidateType(Value, Expected)
	local type = IDtype(Value):lower()

	for I,V in next, tostring(Expected):split(',') do
		if V and tostring(V):lower() == type then
			return true
		end
	end

	return false
end
Helper.IDtype = IDtype
Helper.ValidateType = ValidateType

function Helper:CreateObject(info)
	local Object = {__exists = true}

	function Object:Destroy()
		rawset(Object, '__exists', false)
		local Drawing = rawget(Object, '__drawing')
		if Drawing then
			Drawing:Remove()
			rawset(Object, '__drawing', nil)
		end
	end

	return Object
end

for Type, INFO in next, SupportedObjects do
	local DefaultProperties = Helper['Default' .. Type .. 'Properties']

	local AllowedDrawingProperties = tablecombine(ExpectedDrawingProperties, INFO.ExpectedDrawingProperties)
	local ExpectedProperties = tablecombine(ExpectedObjectProperties, AllowedDrawingProperties)
	if Type == 'Image' then
		ExpectedProperties.Color = nil
	end

	local DrawingType = INFO.DrawingType or Type
	local DrawingProperties = INFO.DefaultDrawingProperties

	local IsQuad = Type == 'Quad'
	Helper['Create' .. Type] = function(self, info)
		local Object = Helper:CreateObject{}

		local Holder = tablecombine(DefaultDrawingProperties, DrawingProperties, DefaultProperties)
		if Type == 'Image' then
			Holder.Color = nil
		end
		local Drawing = DrawNew(DrawingType)

		for I,V in next, Holder do
			if AllowedDrawingProperties[I] then
				Drawing[I] = V
			end
		end
		for I,V in next, info do
			if ExpectedProperties[I] then
				Holder[I] = V
				if AllowedDrawingProperties[I] then
					Drawing[I] = V
				end
			elseif IsQuad then
				if I == 'TopRight' then
					Holder.PointA = V
					Drawing.PointA = V
				elseif I == 'TopLeft' then
					Holder.PointB = V
					Drawing.PointB = V
				elseif I == 'BottomLeft' then
					Holder.PointC = V
					Drawing.PointC = V
				elseif I == 'BottomRight' then
					Holder.PointD = V
					Drawing.PointD = V
				end
			end
		end

		Object.__self = Holder
		Object.__drawing = Drawing

		setmetatable(Object, {
			__index = function(self, Index)
				if ExpectedProperties[Index] then
					return Holder[Index]
				end
			end,
			__newindex = function(self, Index, Value)
				if ExpectedProperties[Index] and ((Value ~= nil and ValidateType(Value, ExpectedProperties[Index])) or true) then
					Holder[Index] = Value
					if AllowedDrawingProperties[Index] and ValidateType(Value, AllowedDrawingProperties[Index]) then
						Drawing[Index] = Value
					end
					return true
				else
					if IsQuad then
						if Index == 'TopRight' then
							Holder.PointA = Value
							Drawing.PointA = Value
							return true
						elseif Index == 'TopLeft' then
							Holder.PointB = Value
							Drawing.PointB = Value
							return true
						elseif Index == 'BottomLeft' then
							Holder.PointC = Value
							Drawing.PointC = Value
							return true
						elseif Index == 'BottomRight' then
							Holder.PointD = Value
							Drawing.PointD = Value
							return true
						end
					end
					return error('Failed to set "' .. tostring(Index) .. '" to "' .. tostring(Value) .. '".', 2)
				end
			end,
			__tostring = function(self)
				return Object.Name or Object.ClassName or '[Failed to get object name]'
			end,
		})

		return Object
	end
end

if shared.DrApHe_DEBUG1 then --testing
	-- print'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
	local Rect 		=  Helper:CreateRectangle{Position = Vector2.new(math.random(700, 900), math.random(400, 600)), Size = Vector2.new(100, 100)}
	local Line 		=  Helper:CreateLine{From = Vector2.new(200, 200), To = Vector2.new(math.random(100, 400), math.random(100, 400)), Thickness = 5}
	local Text 		=  Helper:CreateText{Position = Vector2.new(1200, math.random(300, 700)), Text = ('%s%s%s%s%s'):format(string.char(math.random(40, 60)),string.char(math.random(40, 60)),string.char(math.random(40, 60)),string.char(math.random(40, 60)),string.char(math.random(40, 60)))}
	local Image 	=  Helper:CreateImage{Position = Vector2.new(math.random(700, 900), math.random(400, 600)), Size = Vector2.new(100, 100)}
	local Circle 	=  Helper:CreateCircle{Position = Vector2.new(math.random(1200, 1500), math.random(200, 350))}
	-- local Quad 		=  Helper:CreateQuad{PointA = Vector2.new(200, 300), PointB = Vector2.new(100, 300), PointC = Vector2.new(100, 500), PointD = Vector2.new(200, 500)}
	local Quad 		=  Helper:CreateQuad{TopLeft = Vector2.new(100, 300), TopRight = Vector2.new(200, 300), BottomLeft = Vector2.new(100, 500), BottomRight = Vector2.new(200, 500)}

	wait(2)
	Rect:Destroy()
	Line:Destroy()
	Text:Destroy()
	Image:Destroy()
	Circle:Destroy()
	Quad:Destroy()
end
return Helper
