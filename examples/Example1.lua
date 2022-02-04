local Helper = loadstring(game:HttpGet'https://raw.githubusercontent.com/TechHog8984/Drawing-API-Helper/main/script/v0.4.lua')()

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
