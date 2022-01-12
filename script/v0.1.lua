local Draw = Drawing
local DrawNew = Draw.new
local Helper = {}

local SquareProperties = {
	Visible = 'boolean',
	ZIndex = 'number',
	Transparency = 'number',
	Color = 'Color3',
	Remove = 'function',

	Thickness = 'number',
	Size = 'Vector2',
	Position = 'Vector2',
	Filled = 'boolean',
}
local RectangleProperties = {
	Name = 'string',
}

local function IDtype(Value)
	local type = type(Value)
	-- if type == 'number' or type == 'boolean' or type == 'function' or type == 'table' or type == 'string' or type == 'table' or type == 'nil' then
	-- 	return type
	-- end

	-- if type == 'userdata' then
	-- 	local typeof = typeof(Value)
		
	-- 	return typeof
	-- end

	return (type ~= 'userdata' and type) or typeof(Value)
end

function Helper:CreateObject(info)
	local Object = {__exists = true}

	function Object:Destroy()
		rawset(Object, '__exists', false)
		if Object.__drawing then
			Object.__drawing:Remove()
			rawset(Object, '__drawing', nil)
		end
	end

	return Object
end

function Helper:CreateRectangle(info)
	local Rectangle = Helper:CreateObject{}

	local Holder = {
		Visible = true,
		ZIndex = 0,
		Transparency = 1,
		Color = Color3.new(1, 1, 1),

		Thickness = 3,
		Size = Vector2.new(16, 16),
		Position = Vector2.new(16, 16),
		Filled = true,
	}

	for I, V in next, info do
		if I and (SquareProperties[I] or RectangleProperties[I]) then
			Holder[I] = V
		else
			return error('Failed to find "' .. tostring(I) .. '".', 2)
		end
	end

	Rectangle.__self = Holder

	local Drawing = DrawNew('Square')
	for I, V in next, Holder do
		if SquareProperties[I] then
			Drawing[I] = V
		end
	end

	Rectangle.__drawing = Drawing

	setmetatable(Rectangle, {
		__index = function(self, Index)
			if SquareProperties[Index] or RectangleProperties[Index] then
				return Holder[Index]
			end
		end,
		__newindex = function(self, Index, Value)
			local Expected = SquareProperties[Index] or RectangleProperties[Index]
			if Expected and IDtype(Value) == Expected then
				Holder[Index] = Value
				Drawing[Index] = Value
				return true
			else
				return error('Failed to find "' .. tostring(Index) .. '".', 2)
			end
		end,
		__tostring = function(self)
			return Holder.Name or ''
		end,
	})

	return Rectangle
end
