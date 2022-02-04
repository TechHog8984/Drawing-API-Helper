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
local Helper = {
	Objects = {},
}

local ExpectedDrawingProperties = {
	Visible = 'boolean',
	ZIndex = 'number',
	Transparency = 'number',
	Color = 'Color3',
}

local ExpectedObjectProperties = {
	Name = 'string',
	ClassName = 'string',

	MouseEnter = 'event',
	MouseLeave = 'event',
	MouseButton1Down = 'event',
	MouseButton1Up = 'event',
	MouseButton1Click = 'event',
	Changed = 'event',
}

Helper.ExpectedDrawingProperties = ExpectedDrawingProperties
Helper.ExpectedObjectProperties = ExpectedObjectProperties

local DefaultDrawingProperties = {
	Visible = true,
	ZIndex = 0,
	Transparency = 1,
	Color = Color3.new(1, 1, 1),
}

Helper.DefaultDrawingProperties = DefaultDrawingProperties

local DefaultReadOnlyProperties = {
	'ClassName',

	'MouseEnter',
	'MouseLeave',
	'MouseButton1Down',
	'MouseButton1Up',
	'MouseButton1Click',
	'Changed',
}

local Properties = {
	Expected = {
		Rectangle = {
			Drawing = {
				Thickness = 'number',
				Size = 'Vector2',
				Position = 'Vector2',
				Filled = 'boolean',
			},
			Object = nil,
		},
		Line = {
			Drawing = {
				Thickness = 'number',
				From = 'Vector2',
				To = 'Vector2',
			},
			Object = nil
		},
		Text = {
			Drawing = {
				Text = 'string',
				Size = 'number',
				Center = 'boolean',
				Outline = 'boolean',
				OutlineColor = 'Color3',
				Position = 'Vector2',
				TextBounds = 'Vector2',
				Font = 'Drawing.Font,number',
			},
			Object = nil
		},
		Image = {
			Drawing = {
				Data = 'string',
				Size = 'Vector2',
				Position = 'Vector2',
				Rounding = 'number',
			},
			Object = nil
		},
		Circle = {
			Drawing = {
				Thickness = 'number',
				NumSides = 'number',
				Radius = 'number',
				Filled = 'boolean',
				Position = 'Vector2',	
			},
			Object = nil
		},
		Quad = {
			Drawing = {
				Thickness = 'number',
				PointA = 'Vector2',
				PointB = 'Vector2',
				PointC = 'Vector2',
				PointD = 'Vector2',
				Filled = 'boolean',
			},
			Object = nil,
		},
		Triangle = {
			Drawing = {
				Thickness = 'number',
				PointA = 'Vector2',
				PointB = 'Vector2',
				PointC = 'Vector2',
				Filled = 'boolean',
			},
			Object = nil
		}
	},
	Default = {
		Rectangle = {
			Drawing = {
				Thickness = 3,
				Size = Vector2.new(16, 16),
				Position = Vector2.new(16, 16),
				Filled = true,
			},
			Object = {
				ClassName = 'Rectangle',
				Name = 'Rectangle',
			},
		},
		Line = {
			Drawing = {
				Thickness = 3,
			},
			Object = {
				ClassName = 'Line',
				Name = 'Line',
			}
		},
		Text = {
			Drawing = {
				Size = 18,
				Center = true,
				Outline = false,
				Font = Fonts.Monospace --3,
			},
			Object = {
				ClassName = 'Text',
				Name = 'Text',
			}
		},
		Image = {
			Drawing = {
				Data = game:HttpGet'https://x.synapse.to/favicon.ico',
			},
			Object = {
				ClassName = 'Image',
				Name = 'Image',
			}
		},
		Circle = {
			Drawing = {
				Thickness = 3,
				Radius = 70,
				Filled = true,
			},
			Object = {
				ClassName = 'Circle',
				Name = 'Circle',
			}
		},
		Quad = {
			Drawing = {
				Thickness = 3,
				Filled = true,
			},
			Object = {
				ClassName = 'Quad',
				Name = 'Quad',
			}
		},
		Triangle = {
			Drawing = {
				Thickness = 3,
				Filled = true,
			},
			Object = {
				ClassName = 'Triangle',
				Name = 'Triangle',
			}
		}
	},
	Aliases = {
		Quad = {
			TopRight = 'PointA',
			TopLeft = 'PointB',
			BottomLeft = 'PointC',
			BottomRight = 'PointD',
		}
	},
	ReadOnly = {

	},
}
Helper.Properties = Properties

local SupportedObjects = {
	Rectangle = 'Square',
	Line = 'Line',
	Text = 'Text',
	Image = 'Image',
	Circle = 'Circle',
	Quad = 'Quad',
	Triangle = 'Triangle',
}

local function IDtype(Value)
	local typeof = typeof(Value)

	--will have support for Drawing.Fonts and other types
	return (typeof == 'table' and rawget(Value, '__type')) or typeof
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

local ObjectDestroy = function(Object)
	if Object and type(Object) == 'table' then
		if rawget(Object, '__candestroy') then
			rawset(Object, '__exists', false)
			local Drawing = rawget(Object, '__drawing')
			if Drawing then
				Drawing:Remove()
				rawset(Object, '__drawing', nil)
			end
		else
			return error('Attempt to destroy an object which cannot be destroyed.', 2)
		end
	else
		return error('Expected ":" when calling Destroy, not "." (first arg was not an Object)', 2)
	end
end
function Helper:CreateObject(info)
	local Object = {__exists = true, __candestroy = true}

	if type(info.CanDestroy) == 'boolean' then
		Object.__candestroy = info.CanDestroy
	end

	Object.Destroy = ObjectDestroy

	return Object
end

local function ConnectionDisconnect(Connection)
	if Connection and type(Connection) == 'table' and rawget(Connection, '__type') == 'connection' then
		if Connection.Event and Connection.Event.Connections and table.find(Connection.Event.Connections, Connection) then
			Connection.Connected = false
			table.remove(Connection.Event.Connections, (table.find(Connection.Event.Connections, Connection)))
		else
			return error('Failed to get Connection.Event / Connection.Event doesn\'t have Connections table / Connection isn\'t found in Connections table.', 2)
		end
	else
		return error('Expected ":" when calling Disconnect, not "." (first arg was not a Connection.', 2)
	end
end
local EventConnect = function(Event, Func)
	if Func and type(Func) == 'function' then
		if Event and type(Event) == 'table' and rawget(Event, '__type') == 'event' then
			if rawget(Event, '__exists') then
				local Connections = Event.Connections
				if Connections then
					local Connection = {
						__type = 'connection',
						Func = Func,
						Disconnect = ConnectionDisconnect,
						Event = Event,
						Connected = true,
					}
					table.insert(Connections, Connection)
					return Connection
				end
			else
				return error('Attempt to connect an Event which no longer exists.', 2)
			end
		else
			return error('Expected ":" when calling Connect, not "." (first arg was not an Event.)', 2)
		end
	else
		return error('Expected function for arg 2 when calling Connect, got ' .. tostring(Func), 2)
	end
end
local EventFire = function(Event, ...)
	local Args = {...}
	if Event and type(Event) == 'table' and rawget(Event, '__type') == 'event' then
		if rawget(Event, '__exists') then
			local Connections = Event.Connections
			if Connections then
				for I, Con in next, Connections do
					if Con and Con.Func and Con.Connected then
						local Suc, Err = pcall(task.spawn, Con.Func, table.unpack(Args))
						if not Suc and Err then
							error('From Event.Fire: ' .. tostring(Err), 3)
						end
					end
				end
			end
		else
			return error('Attempt to fire an Event which no longer exists.', 2)
		end
	else
		return error('Expected ":" when calling Fire, not "." (first arg was not an Event)', 2)
	end
end
function Helper:CreateEvent(info)
	local Event = Helper:CreateObject{CanDestroy = info.CanDestroy}

	Event.__type = 'event'
	Event.ClassName = 'Event'

	Event.Connections = {}
	Event.Connect = EventConnect
	Event.Fire = EventFire

	for I,V in next, info do
		Event[I] = V
	end

	return Event
end

for Type, DrawingType in next, SupportedObjects do
	local DefaultProperties = Helper.Properties.Default[Type].Object
	local Aliases = Helper.Properties.Aliases[Type]

	local AllowedDrawingProperties = tablecombine(ExpectedDrawingProperties, Helper.Properties.Expected[Type].Drawing)
	local ExpectedProperties = tablecombine(ExpectedObjectProperties, AllowedDrawingProperties)

	local ReadOnlyProperties = tablecombine(DefaultReadOnlyProperties, Helper.Properties.ReadOnly[Type] or {})
	if Type == 'Image' then
		ExpectedProperties.Color = nil
	end

	local DrawingProperties = Helper.Properties.Default[Type].Drawing

	Helper['Create' .. Type] = function(self, info)
		local Object = Helper:CreateObject{}
		Object.__type = 'object'

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
		for Index, Value in next, info do
			local Alias = (Aliases and Aliases[Index])
			if ExpectedProperties[Alias or Index] then
				Holder[Alias or Index] = Value
				if AllowedDrawingProperties[Alias or Index] then
					Drawing[Alias or Index] = Value
				end
			end
		end

		Holder.Changed = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-Changed'}
		Holder.MouseEnter = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-MouseEnter'}
		Holder.MouseLeave = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-MouseLeave'}
		Holder.MouseButton1Down = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-MouseButton1Down'}
		Holder.MouseButton1Up = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-MouseButton1Up'}
		Holder.MouseButton1Click = Helper:CreateEvent{CanDestroy = false, Name = tostring(Object) .. '-MouseButton1Click'}

		Object.__self = Holder
		Object.__drawing = Drawing

		setmetatable(Object, {
			__index = function(self, Index)
				local Alias = (Aliases and Aliases[Index])
				if ExpectedProperties[Alias or Index] then
					return Holder[Alias or Index]
				end
			end,
			__newindex = function(self, Index, Value)
				if table.find(ReadOnlyProperties, Index) then
					return error('Attempt to set a readonly property! (' .. tostring(Index) .. ')', 2)
				else
					local Alias = (Aliases and Aliases[Index])
					local Expected = ExpectedProperties[Alias or Index]
					if Expected then
						if ValidateType(Value, Expected) then
							Holder[Alias or Index] = Value
							local Expected = AllowedDrawingProperties[Alias or Index]
							if Expected and ValidateType(Value, Expected) then
								Drawing[Alias or Index] = Value
							end

							if Holder.Changed then
								Holder.Changed:Fire(Index, Value)
							end

							return true
						else
							return error('Failed to set property of ' .. tostring(Object) .. ' :invalid type "' .. IDtype(Value) .. '" for "' .. Index .. '".', 2)
						end
					else
						return error('Failed to set property of ' .. tostring(Object) .. ' :"' .. Index .. '" is not a valid property name.', 2)
					end
				end
			end,
			__tostring = function(self)
				return Object.Name or Object.ClassName or '[Failed to get object name]'
			end,
		})

		table.insert(Helper.Objects, Object)

		return Object
	end
end

-- local Players = game:GetService'Players'
-- local LocalPlayer = Players.LocalPlayer
-- local Mouse = LocalPlayer.GetMouse(LocalPlayer)

local GuiInset = game:GetService'GuiService':GetGuiInset().Y
local UIS = game:GetService'UserInputService'
local gml = UIS.GetMouseLocation
local function GetMouseLocation(...)
	return gml(UIS, ...)
end

local function IsHovering(Object, MousePos)
	local ObjectPos = Object.Position
	local DrawingSize = Object.Size or (Object.Radius and {X = Object.Radius, Y = Object.Radius})

	if ObjectPos and DrawingSize and typeof(DrawingSize) == 'Vector2' then
		return MousePos.X >= ObjectPos.X and MousePos.X <= ObjectPos.X + DrawingSize.X and MousePos.Y >= ObjectPos.Y and MousePos.Y <= ObjectPos.Y + DrawingSize.Y
	elseif Object.ClassName == 'Quad' then
		local TopRight = Object.TopRight
		local TopLeft = Object.TopLeft
		local BottomRight = Object.BottomRight
		local BottomLeft = Object.BottomLeft

		if MousePos and TopRight and TopLeft and BottomRight and BottomLeft then
			return (MousePos.X >= TopLeft.X or MousePos.X >= BottomLeft.X) and (MousePos.X <= TopRight.X or MousePos.X <= BottomRight.X) and (MousePos.Y <= BottomRight.Y or MousePos.Y <= BottomLeft.Y) and (MousePos.Y >= TopRight.Y or MousePos.Y >= TopLeft.Y)
		end
	end
	return false;
end

local OldMousePos = GetMouseLocation()
local function MouseMoved(Position)
	local Delta = Position - OldMousePos
	local AmountMoved = Delta.Magnitude
	
	for I, Object in next, Helper.Objects do
		if Object and rawget(Object, '__exists') then
			local Old = rawget(Object, '__hovering')

			local Hovering = IsHovering(Object, Position)

			if Object.MouseEnter and Hovering and not Old then
				Object.MouseEnter:Fire()
			elseif Object.MouseLeave and Old and not Hovering then
				Object.MouseLeave:Fire()
				rawset(Object, '__canclick', false)
			end

			rawset(Object, '__hovering', Hovering)
		else
			rawset(Helper.Objects, I, nil)
		end
	end

	OldMousePos = Position
end

UIS.InputBegan:Connect(function(Input)
	if Input then
		local UIT = Input.UserInputType
		local MouseButton1 = UIT == Enum.UserInputType.MouseButton1
		if MouseButton1 then
			for I, Object in next, Helper.Objects do
				if Object and rawget(Object, '__exists') then
					if rawget(Object, '__hovering') then
						rawset(Object, '__mousebutton1up', false)
						if not rawget(Object, '__mousebutton1down') and Object.MouseButton1Down then
							Object.MouseButton1Down:Fire()
						end
						rawset(Object, '__mousebutton1down', true)
						rawset(Object, '__canclick', true)
					end
				else
					rawset(Helper.Objects, I, nil)
				end
			end
		end
	end
end)
UIS.InputChanged:Connect(function(Input)
	if Input and Input.UserInputType == Enum.UserInputType.MouseMovement then
		MouseMoved(GetMouseLocation())
	end
end)
UIS.InputEnded:Connect(function(Input)
	if Input then
		local UIT = Input.UserInputType
		local MouseButton1 = UIT == Enum.UserInputType.MouseButton1
		if MouseButton1 then
			for I, Object in next, Helper.Objects do
				if Object and rawget(Object, '__exists') then
					if rawget(Object, '__mousebutton1down') then
						rawset(Object, '__mousebutton1down', false)
						if not rawget(Object, '__mousebutton1up') and Object.MouseButton1Up then
							Object.MouseButton1Up:Fire()
						end
						if rawget(Object, '__canclick') and Object.MouseButton1Click then
							Object.MouseButton1Click:Fire()
						end
						rawset(Object, '__mousebutton1up', true)
					end
				else
					rawset(Helper.Objects, I, nil)
				end
			end
		end
	end
end)

return Helper
