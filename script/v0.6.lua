local CreateEvent = assert(loadstring(game:HttpGet'https://raw.githubusercontent.com/TechHog8984/Event-Manager/main/src.lua')(), 'Failed to get CreateEvent function.')

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

	Descendants = 'table',

	MouseEnter = 'Event',
	MouseLeave = 'Event',
	MouseButton1Down = 'Event',
	MouseButton1Up = 'Event',
	MouseButton1Click = 'Event',
	MouseButton2Down = 'Event',
	MouseButton2Up = 'Event',
	MouseButton2Click = 'Event',
	Changed = 'Event',
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

	'Descendants',

	'MouseEnter',
	'MouseLeave',
	'MouseButton1Down',
	'MouseButton1Up',
	'MouseButton1Click',
	'MouseButton2Down',
	'MouseButton2Up',
	'MouseButton2Click',
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
			Object = {},
		},
		Line = {
			Drawing = {
				Thickness = 'number',
				From = 'Vector2',
				To = 'Vector2',
			},
			Object = {}
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
			Object = {}
		},
		Image = {
			Drawing = {
				Data = 'string',
				Size = 'Vector2',
				Position = 'Vector2',
				Rounding = 'number',
			},
			Object = {}
		},
		Circle = {
			Drawing = {
				Thickness = 'number',
				NumSides = 'number',
				Radius = 'number',
				Filled = 'boolean',
				Position = 'Vector2',	
			},
			Object = {}
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
			Object = {},
		},
		Triangle = {
			Drawing = {
				Thickness = 'number',
				PointA = 'Vector2',
				PointB = 'Vector2',
				PointC = 'Vector2',
				Filled = 'boolean',
			},
			Object = {}
		},
		TextButton = {
			Drawing = {
				Thickness = 'number',
				Size = 'Vector2',
				Position = 'Vector2',
				Filled = 'boolean',
			},
			Object = {
				Text = 'string',
				TextColor = 'Color3',
				TextTransparency = 'number',
				TextXAlignment = 'string',
				TextYAlignment = 'string',
			},
		},
		TextLabel = {
			Drawing = {
				Thickness = 'number',
				Size = 'Vector2',
				Position = 'Vector2',
				Filled = 'boolean',
			},
			Object = {
				Text = 'string',
				TextColor = 'Color3',
				TextTransparency = 'number',
				TextXAlignment = 'string',
				TextYAlignment = 'string',
			},
		},
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
		},
		TextButton = {
			Drawing = {
				Thickness = 3,
				Size = Vector2.new(16, 16),
				Position = Vector2.new(16, 16),
				Filled = true,
			},
			Object = {
				ClassName = 'TextButton',
				Name = 'TextButton',
				Text = 'TextButton',
				TextColor = Color3.new(1,1,1),
				TextTransparency = 1,
				TextXAlignment = 'Center',
				TextYAlignment = 'Center',
			},
		},
		TextLabel = {
			Drawing = {
				Thickness = 3,
				Size = Vector2.new(16, 16),
				Position = Vector2.new(16, 16),
				Filled = true,
			},
			Object = {
				ClassName = 'TextLabel',
				Name = 'TextLabel',
				Text = 'TextLabel',
				TextColor = Color3.new(1,1,1),
				TextTransparency = 1,
				TextXAlignment = 'Center',
				TextYAlignment = 'Center',
			},
		},
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
	TextButton = 'Square',
	TextLabel = 'Square',
}

local function IDtype(Value)
	local typeof = typeof(Value)

	--will have support for Drawing.Fonts and other types
	return (typeof == 'table' and rawget(Value, '__type')) or (typeof == 'userdata' and Value.__type) or typeof
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
		for I, Descendant in next, Object.Descendants do
			if Descendant then
				Descendant:Destroy()
			end
		end
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

for Type, DrawingType in next, SupportedObjects do
	local DefaultProperties = Helper.Properties.Default[Type].Object
	local Aliases = Helper.Properties.Aliases[Type]

	local AllowedDrawingProperties = tablecombine(ExpectedDrawingProperties, Helper.Properties.Expected[Type].Drawing)
	local ExpectedProperties = tablecombine(ExpectedObjectProperties, AllowedDrawingProperties, Helper.Properties.Expected[Type].Object)

	local ReadOnlyProperties = tablecombine(DefaultReadOnlyProperties, Helper.Properties.ReadOnly[Type] or {})
	if Type == 'Image' then
		ExpectedProperties.Color = nil
	end

	local DrawingProperties = Helper.Properties.Default[Type].Drawing

	local IsTextObject = Type and Type ~= 'Text' and string.sub(Type, 1, 4) == 'Text'
	Helper['Create' .. Type] = function(self, info)
		local Object = Helper:CreateObject{}
		Object.__type = 'object'

		local Holder = tablecombine(DefaultDrawingProperties, DrawingProperties, DefaultProperties)
		if Type == 'Image' then
			Holder.Color = nil
		end
		local Drawing = DrawNew(DrawingType)

		Holder.Descendants = {}

		if IsTextObject then
			local TextObject = Helper:CreateText{Text = Holder.Text}
			Object.__text = TextObject

			table.insert(Holder.Descendants,  TextObject)
		end

		for I,V in next, Holder do
			if AllowedDrawingProperties[I] then
				Drawing[I] = V
			end
		end
		-- for Index, Value in next, info do
		-- 	local Alias = (Aliases and Aliases[Index])
		-- 	if ExpectedProperties[Alias or Index] then
		-- 		Holder[Alias or Index] = Value
		-- 		if AllowedDrawingProperties[Alias or Index] then
		-- 			Drawing[Alias or Index] = Value
		-- 		end
		-- 	end
		-- end

		Holder.Changed = CreateEvent{Name = tostring(Object) .. '-Changed'}
		Holder.MouseEnter = CreateEvent{Name = tostring(Object) .. '-MouseEnter'}
		Holder.MouseLeave = CreateEvent{Name = tostring(Object) .. '-MouseLeave'}
		Holder.MouseButton1Down = CreateEvent{Name = tostring(Object) .. '-MouseButton1Down'}
		Holder.MouseButton1Up = CreateEvent{Name = tostring(Object) .. '-MouseButton1Up'}
		Holder.MouseButton1Click = CreateEvent{Name = tostring(Object) .. '-MouseButton1Click'}
		Holder.MouseButton2Down = CreateEvent{Name = tostring(Object) .. '-MouseButton2Down'}
		Holder.MouseButton2Up = CreateEvent{Name = tostring(Object) .. '-MouseButton2Up'}
		Holder.MouseButton2Click = CreateEvent{Name = tostring(Object) .. '-MouseButton2Click'}


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
							local TextObject = Object.__text
							local SetTextProperty = false
							if TextObject and string.sub(Index, 1, 4) == 'Text' then
								if Index == 'Text' then
									TextObject.Text = Value
									SetTextProperty = true
								elseif TextObject[string.sub(Index, 5, -1)] then
									TextObject[string.sub(Index, 5, -1)] = Value
									SetTextProperty = true
								-- elseif Helper.Properties.Expected.TextButton.Object[Index] then

								end
							end
							Holder[Alias or Index] = Value

							local Expected = AllowedDrawingProperties[Alias or Index]
							if Expected and ValidateType(Value, Expected) then
								Drawing[Alias or Index] = Value
							end

							if Holder.Changed then
								Holder.Changed:Fire(Index, Value)
							end

							if TextObject then
								if Index == 'Position' or Index == 'Size' then
									local ObjectPosition = Object.Position
									local ObjectSize = Object.Size

									local LeftX = ObjectPosition.X
									local CenterX = ObjectPosition.X + ObjectSize.X / 2
									local RightX = ObjectPosition.X + ObjectSize.X

									local TopY = ObjectPosition.Y
									local CenterY = ObjectPosition.Y + ObjectSize.Y / 2 - TextObject.Size / 2
									local BottomY = ObjectPosition.Y + ObjectSize.Y - TextObject.Size

									local XAlignment = Object.TextXAlignment
									local YAlignment = Object.TextYAlignment

									TextObject.Position = Vector2.new((XAlignment == 'Left' and LeftX) or (XAlignment == 'Center' and CenterX) or (XAlignment == 'Right' and RightX), (YAlignment == 'Top' and TopY) or (YAlignment == 'Center' and CenterY) or (YAlignment == 'Bottom' and BottomY))
								elseif not SetTextProperty and not ExpectedObjectProperties['Text' .. Index] and ExpectedDrawingProperties[Index] or ExpectedObjectProperties[Index] or Helper.Properties.Expected.Text.Drawing[Index] then
									local Expected = ExpectedDrawingProperties[Index] or ExpectedObjectProperties[Index] or Helper.Properties.Expected.Text.Drawing[Index];
									if ValidateType(Value, Expected) then
										TextObject[Index] = Value
									end
								end
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

		for Index, Value in next, info do
			Object[Index] = Value
		end

		if rawget(Object, '__text') then
			for Prop, Value in next, tablecombine(Helper.Properties.Default.Text.Drawing, Helper.Properties.Default.Text.Object) do
				if not table.find(DefaultReadOnlyProperties, Prop) and not table.find(Helper.Properties.ReadOnly.Text or {}, Prop) then
					rawget(Object, '__text')[Prop] = Value
				end
			end
		end

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
				rawset(Object, '__canleftclick', false)
				rawset(Object, '__canrightclick', false)
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
		local MouseButton2 = UIT == Enum.UserInputType.MouseButton2
		if MouseButton1 or MouseButton2 then
			for I, Object in next, Helper.Objects do
				if Object and rawget(Object, '__exists') then
					if rawget(Object, '__hovering') then
						if MouseButton1 then
							rawset(Object, '__mousebutton1up', false)
							if not rawget(Object, '__mousebutton1down') and Object.MouseButton1Down then
								Object.MouseButton1Down:Fire()
							end
							rawset(Object, '__mousebutton1down', true)
							rawset(Object, '__canleftclick', true)
						elseif MouseButton2 then
							rawset(Object, '__mousebutton2up', false)
							if not rawget(Object, '__mousebutton2down') and Object.MouseButton2Down then
								Object.MouseButton2Down:Fire()
							end
							rawset(Object, '__mousebutton2down', true)
							rawset(Object, '__canrightclick', true)
						end
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
		local MouseButton2 = UIT == Enum.UserInputType.MouseButton2
		if MouseButton1 or MouseButton2 then
			for I, Object in next, Helper.Objects do
				if Object and rawget(Object, '__exists') then
					if MouseButton1 and rawget(Object, '__mousebutton1down') then
						rawset(Object, '__mousebutton1down', false)
						if not rawget(Object, '__mousebutton1up') and Object.MouseButton1Up then
							Object.MouseButton1Up:Fire()
						end
						if rawget(Object, '__canleftclick') and Object.MouseButton1Click then
							Object.MouseButton1Click:Fire()
						end
						rawset(Object, '__mousebutton1up', true)
					elseif MouseButton2 and rawget(Object, '__mousebutton2down')then
						rawset(Object, '__mousebutton2down', false)
						if not rawget(Object, '__mousebutton2up') and Object.MouseButton2Up then
							Object.MouseButton2Up:Fire()
						end
						if rawget(Object, '__canrightclick') and Object.MouseButton2Click then
							Object.MouseButton2Click:Fire()
						end
						rawset(Object, '__mousebutton2up', true)
					end
				else
					rawset(Helper.Objects, I, nil)
				end
			end
		end
	end
end)

if shared.DrApHe_DEBUG1 then --testing
	-- print'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
	local function RandomColor()
		local str = '0.' .. tostring(math.random(111111111, 999999999))
		return Color3.fromHSV(tonumber(str), 1, 1)
	end
	local function RandomText()
		local str = ''
		for i = 1, 5 do
			str ..= string.char(math.random(40, 50))
		end
		return str
	end

	local Rect 		=  Helper:CreateRectangle{}
	for I,V in next, {Color = RandomColor(), Position = Vector2.new(math.random(700, 900), math.random(400, 600)), Size = Vector2.new(100, 100)} do
		Rect[I] = V
	end

	local Line 		=  Helper:CreateLine{Color = RandomColor(), From = Vector2.new(200, 200), To = Vector2.new(math.random(100, 400), math.random(100, 400)), Thickness = 5}
	local Text 		=  Helper:CreateText{Color = RandomColor(), Position = Vector2.new(1200, math.random(300, 700)), Text = RandomText()}
	local Image 	=  Helper:CreateImage{Position = Vector2.new(math.random(700, 900), math.random(400, 600)), Size = Vector2.new(100, 100)}
	local Circle 	=  Helper:CreateCircle{Color = RandomColor(), Position = Vector2.new(math.random(1200, 1500), math.random(200, 350))}
	-- local Quad 		=  Helper:CreateQuad{PointA = Vector2.new(200, 300), PointB = Vector2.new(100, 300), PointC = Vector2.new(100, 500), PointD = Vector2.new(200, 500)}
	local Quad 		=  Helper:CreateQuad{Color = RandomColor(), TopLeft = Vector2.new(math.random(100, 250), math.random(550, 700)), BottomRight = Vector2.new(math.random(150, 300), math.random(700, 950))}
	local Triangle 	=  Helper:CreateTriangle{Color = RandomColor(), PointA = Vector2.new(math.random(300, 400), math.random(300, 400)), PointB = Vector2.new(math.random(300, 400), math.random(500, 600)), PointC = Vector2.new(math.random(350, 450), math.random(450, 550))}

	Quad.TopRight = Vector2.new(Quad.BottomRight.X, Quad.TopLeft.Y)
	Quad.BottomLeft = Vector2.new(Quad.TopLeft.X, Quad.BottomRight.Y)

	wait(2)
	Rect:Destroy()
	Line:Destroy()
	Text:Destroy()
	Image:Destroy()
	Circle:Destroy()
	Quad:Destroy()
	Triangle:Destroy()
end
if shared.DrApHe_DEBUG2 then
	local frame = Helper:CreateRectangle{Position = Vector2.new(810, 540), Color = Color3.new(.35,.35,.35), Size = Vector2.new(200, 200)}
	-- local frame = Helper:CreateQuad{TopLeft = Vector2.new(250, 550), BottomRight = Vector2.new(300, 800), Color = Color3.new(.35, .35, .35)}

	-- frame.TopRight = Vector2.new(frame.BottomRight.X + 30, frame.TopLeft.Y)
	-- frame.BottomLeft = Vector2.new(frame.TopLeft.X - 30, frame.BottomRight.Y)

	frame.MouseEnter:Connect(function()
		frame.Color = Color3.new(.35, .65, .35)
	end)
	frame.MouseLeave:Connect(function()
		frame.Color = Color3.new(.35, .35 ,.35)
	end)

	frame.MouseButton1Down:Connect(function()
		print'Frame button1down'
	end)
	frame.MouseButton1Up:Connect(function()
		print'Frame button1up'
	end)
	frame.MouseButton1Click:Connect(function()
		print'Frame button1click'
	end)

	frame.MouseButton2Down:Connect(function()
		print'Frame button2down'
	end)
	frame.MouseButton2Up:Connect(function()
		print'Frame button2up'
	end)
	frame.MouseButton2Click:Connect(function()
		print'Frame button2click'
	end)


	wait(5)
	frame:Destroy()
end
if shared.DrApHe_DEBUG3 then
	local frame = Helper:CreateRectangle{Position = Vector2.new(810, 540), Color = Color3.new(.35,.35,.35), Size = Vector2.new(200, 200)};

	local Suc,Res = pcall(frame.Changed.Destroy, frame.Changed);
	print(Suc, Res);

	wait(2);
	local Suc, Res = pcall(frame.Destroy, frame);
	print(Suc, Res);
end
if shared.DrApHe_DEBUG4 then
	local Button = Helper:CreateTextButton{Position = Vector2.new(810, 540), Color = Color3.new(.35,.35,.35), TextColor = Color3.new(1, 1, 1), Size = Vector2.new(200, 200)};
	local Label = Helper:CreateTextLabel{Position = Vector2.new(610, 540), Color = Color3.new(.55, .55, .55), TextColor = Color3.new(1, 1, 1), Size = Vector2.new(200, 100)};

	wait(1);
	Button.Visible = false;
	Label.Visible = false;
	wait(1);
	Button.Visible = true;
	Label.Visible = true;

	wait(1);
	Button:Destroy();
	Label:Destroy();
end

return Helper
