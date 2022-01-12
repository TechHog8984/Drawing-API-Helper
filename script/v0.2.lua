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
local Helper = {}

local ExpectedDrawingProperties = {
	Visible = 'boolean',
	ZIndex = 'number',
	Transparency = 'number',
	Color = 'Color3',
}
local ExpectedSquareProperties = {
	Thickness = 'number',
	Size = 'Vector2',
	Position = 'Vector2',
	Filled = 'boolean',
}

local ExpectedObjectProperties = {
	Name = 'string',
}
local ExpectedRectangleProperties = {}

Helper.ExpectedDrawingProperties = ExpectedDrawingProperties
Helper.ExpectedObjectProperties = ExpectedObjectProperties
Helper.ExpectedSquareProperties = ExpectedSquareProperties
Helper.ExpectedRectangleProperties = ExpectedRectangleProperties

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

Helper.DefaultDrawingProperties = DefaultDrawingProperties
Helper.DefaultSquareProperties = DefaultSquareProperties

local function IDtype(Value)
	local typeof = typeof(Value)

	--will have support for Drawing.Fonts and other types
	return typeof
end
Helper.IDtype = IDtype

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

local AllowedRectangleProperties = tablecombine(ExpectedObjectProperties, ExpectedRectangleProperties)
local AllowedSquareProperties = tablecombine(ExpectedDrawingProperties, ExpectedSquareProperties)
local DefaultRectangleProperties = tablecombine(DefaultDrawingProperties, DefaultSquareProperties)
function Helper:CreateRectangle(info)
	local Rectangle = Helper:CreateObject{}

	local Holder = tablecombine(DefaultDrawingProperties, DefaultSquareProperties)
	local Drawing = DrawNew('Square')

	for I,V in next, Holder do
		Drawing[I] = V
	end
	for I, V in next, info do
		if AllowedRectangleProperties[I] then
			Holder[I] = V
		end
		if AllowedSquareProperties[I] then
			Drawing[I] = V
			Holder[I] = V
		end
	end

	Rectangle.__self = Holder
	Rectangle.__drawing = Drawing

	setmetatable(Rectangle, {
		__index = function(self, Index)
			if DefaultRectangleProperties[I] then
				return Holder[Index]
			end
		end,
		__newindex = function(self, Index, Value)
			local Expected = DefaultRectangleProperties[I]
			if Expected and IDtype(Value) == Expected then
				Holder[Index] = Value
				Drawing[Index] = Value
				return true
			else
				return error('Failed to set "' .. tostring(Index) .. '" to "' .. tostring(Value) .. '".', 2)
			end
		end,
		__tostring = function(self)
			return Holder.Name or ''
		end,
	})

	return Rectangle
end

return Helper
