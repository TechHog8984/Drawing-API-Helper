local Drawing = assert(Drawing or drawing, 'Could not find Drawing API. If you know you have access to a Drawing API, try adding \'Drawing = NameOfYourDrawingAPI\' at the top of your script.')
local Class = {}

Class.Properties = {
	Default = {
		__exists = false,
		__object = nil,
		__type = nil,

		Visible = false,

		Parent = nil,

		Children = {},
		Descendants = {},
	},
	Gui = {

	},
	Frame = {

	},
	TextButton = {

	},
	TextLabel = {

	},
}
Class.AllowedDrawingTypes = {
	Default = {
		Visible = 'boolean',
		ZIndex = 'number',
		Transparency = 'number',
		Color = 'Color3',
	},
	Line = {
		Thickness = 'number',
		From = 'Vector2',
		To = 'Vector2',
	},
	Text = {
		Text = 'string',
		Size = 'number',
		Center = 'boolean',
		Outline = 'boolean',
		OutlineColor = 'Color3',
		Position = 'Vector2',
		Font = 'Drawing.Font',
	},
	Image = {
		Data = 'string',
		Size = 'Vector2',
		Position = 'Vector2',
		Rounding = 'number',
	},
	Circle = {
		Thickness = 'number',
		NumSides = 'number',
		Radius = 'number',
		Filled = 'boolean',
		Position = 'Vector2',
	},
	Square = {
		Thickness = 'number',
		Size = 'Vector2',
		Position = 'Vector2',
		Filled = 'boolean',
	},
	Quad = {
		Thickness = 'number',
		PointA = 'Vector2',
		PointB = 'Vector2',
		PointC = 'Vector2',
		PointD = 'Vector2',
		Filled = 'boolean',
	},
	Triangle = {
		Thickness = 'number',
		PointA = 'Vector2',
		PointB = 'Vector2',
		PointC = 'Vector2',
		Filled = 'boolean',
	},

}

for I, Type in next, Class.Properties do
	for Property, Value in next, Class.Properties.Default do
		Type[Property] = Value
	end
end 
for I, Type in next, Class.AllowedDrawingTypes do
	for Property, Value in next, Class.AllowedDrawingTypes.Default do
		Type[Property] = Value
	end
end

local function tablegetlength(Table)
	local length = 0
	for I, V in next, Table do
		length += 1
	end
	return length
end
local function tablefindlower(Table, Value)
	for I, V in next, Table do
		if tostring(V):lower() == tostring(Value):lower() then
			return I, V
		end
	end
end
local function tablefindlowerByIndex(Table, Index)
	for I, V in next, Table do
		if tostring(I):lower() == tostring(Index):lower() then
			return I, V
		end
	end
end

function Class:SetObjectMT(object)
	local proxy = object

	object = {}

	local mt = {
		__index = function(self, key)
			return proxy[key]
		end,
		__newindex = function(self, key, value)
			proxy[key] = value
		end,
	}

	setmetatable(proxy, mt)
	return proxy
end

function Class:CreateDrawingObject(info)
	if info then
		if tablegetlength(info) > 0 then
			local ObjectType = info['type']
			if ObjectType then
				local RealType, Allowed = tablefindlowerByIndex(Class.AllowedDrawingTypes, ObjectType)
				if RealType then
					local FakeObject = {}
					local Object = nil

					local realinfo = info
					realinfo['type'] = nil
					for Index, Value in next, realinfo do
						local RealIndex, ExpectedType = tablefindlowerByIndex(Allowed, Index)
						if RealIndex then
							if typeof(Value) == ExpectedType or ExpectedType == 'Drawing.Font' then
								FakeObject[RealIndex] = Value
							else
								error( ('expected %s for %s, got %s'):format(ExpectedType, RealIndex, typeof(Value)) , 2)
								return
							end
						else
							error( ('expected property for %s, got \'%s\''):format(RealType, Index) , 2)
							return
						end
					end

					for I, V in next, FakeObject do
						Object = Object or Drawing.new(RealType)
						Object[I] = V
					end

					return Object
				else
					error( ('expected drawing object type, got \'%s\'. see documentation for drawing object types.'):format(ObjectType) , 2)
					return
				end
			else
				error('\'type\' is a required argument.', 2)
				return
			end
		else
			error('not enough arguments passed', 2)
			return
		end
	else
		error('improper syntax. try Class:CreateDrawingObject{}', 2)
		return
	end
end

function Class:CreateObject(info)
	if info then
		if tablegetlength(info) > 0 then
			local ObjectType = info['type']
			if ObjectType then
				local RealType, DefaultObject = tablefindlowerByIndex(Class.Properties, ObjectType)

				if RealType then
					--local object = Class:SetObjectMT(DefaultObject)
					local object = DefaultObject
					object.__type = RealType

					if RealType == 'Frame' then
						object.__object = Class:CreateDrawingObject('Square')
					end

					return object
				else
					error( ('expected object type, got \'%s\'. see documentation for object types.'):format(ObjectType) , 2)
				end
			else
				error('\'type\' is a required argument.', 2)
			end
		else
			error('not enough arguments passed.', 2)
		end
	else
		error('improper syntax. try Class:CreateObject{}', 2)
	end
end

--Class:CreateObject{type = 'Frame'}
local obj = Class:CreateDrawingObject{type = 'Square', Visible = true, Position = Vector2.new(840, 513.5), test = 'true'}

wait(1)
obj:Remove()

return Class
