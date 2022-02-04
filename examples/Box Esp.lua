local Helper = loadstring(game:HttpGet'https://raw.githubusercontent.com/TechHog8984/Drawing-API-Helper/main/script/v0.4.lua')()
local Players = game:GetService'Players'

local PlayerObjects = {}
local function PlayerAdded(Player)
	PlayerObjects[Player] = {
		Box = Helper:CreateQuad{Name = Player.Name .. '-Box',
			Thickness = 5,
			Filled = false,
		}
	}
end
local function PlayerRemoving(Player)
	if PlayerObjects[Player] then
		for I, Object in next, PlayerObjects[Player] do
			if Object then Object:Destroy() end
		end
	end
	PlayerObjects[Player] = nil
end

local LocalPlayer = Players.LocalPlayer
for I, Player in next, Players:GetPlayers() do
	if Player and Player ~= LocalPlayer then
		if not Player.Character then
			Player.CharacterAdded:Wait()
		end
		PlayerAdded(Player)
	end
end
Players.PlayerAdded:Connect(function(Player)
	if Player and Player ~= LocalPlayer then
		if not Player.Character then
			Player.CharacterAdded:Wait()
		end
		PlayerAdded(Player)
	end
end)
Players.PlayerRemoving:Connect(function(Player)
	if Player and Player ~= LocalPlayer then
		PlayerRemoving(Player)
	end
end)

local Camera = workspace.CurrentCamera
game:GetService'RunService'.RenderStepped:Connect(function()
	for Player, Objects in next, PlayerObjects do
		if Player then
			if Objects.Box and rawget(Objects.Box, '__exists') then
				Objects.Box.Visible = false
				if not Player.Character then
					Player.CharacterAdded:Wait()
				end
				local Torso = Player.Character:FindFirstChild'HumanoidRootPart' or Player.Character:FindFirstChild'Torso'
				if Torso then
					local Position = Torso.Position
					local CFrame = Torso.CFrame
					local XVector = CFrame.XVector

					local FlatXV = Vector3.new(XVector.X, 0, XVector.Z) * 1.5
					local TopLeft, TopLeftVis = Camera:WorldToViewportPoint(Position + Vector3.new(0, 2) - FlatXV)
					Objects.Box.TopLeft = Vector2.new(TopLeft.X, TopLeft.Y)

					local TopRight, TopRightVis = Camera:WorldToViewportPoint(Position + Vector3.new(0, 2) + FlatXV)
					Objects.Box.TopRight = Vector2.new(TopRight.X, TopRight.Y)

					local BottomLeft, BottomLeftVis = Camera:WorldToViewportPoint(Position + Vector3.new(0, -3) - FlatXV)
					Objects.Box.BottomLeft = Vector2.new(BottomLeft.X, BottomLeft.Y)

					local BottomRight, BottomRightVis = Camera:WorldToViewportPoint(Position + Vector3.new(0, -3) + FlatXV)
					Objects.Box.BottomRight = Vector2.new(BottomRight.X, BottomRight.Y)

					Objects.Box.Visible = TopLeftVis or TopRightVis or BottomLeftVis or BottomRightVis
				end
			else
				PlayerRemoving(Player)
			end
		else
			PlayerRemoving(Player)
		end
	end
end)
