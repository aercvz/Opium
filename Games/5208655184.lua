repeat task.wait() until game:IsLoaded()

--# services
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local httpService = game:GetService("HttpService")
local clientStorage = game:GetService("ReplicatedStorage")
local teleportService = game:GetService("TeleportService")
local debris = game:GetService("Debris")
--# global variables
local encrypt = syn.crypt.encrypt
local decrypt = syn.crypt.decrypt
local floor = math.floor
local format = string.format
local clamp = math.clamp
local sub = string.sub
local match = string.match
local lower = string.lower
local insert = table.insert
local vector2 = Vector2.new
local vector3 = Vector3.new
local findFirstChild = game.FindFirstChild
local findFirstChildOfClass = game.FindFirstChildOfClass
local waitForChild = game.WaitForChild
--# variables
local player = players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local worldToViewPortPoint = camera.WorldToViewportPoint
local configurationName = "default"
local keys = {W = 0, S = 0, D = 0, A = 0}
--# unkown variables
local character
local humanoid
local torso
local root
--# character loader
local function set_character()
	repeat task.wait() until player.Character
	character = player.Character
	humanoid = character:WaitForChild("Humanoid", 9e9)
	torso = character:WaitForChild("Torso", 9e9)
	root = character:WaitForChild("HumanoidRootPart", 9e9)
end
local function remove_character()
	character = nil
	humanoid = nil
	torso = nil
	root = nil
end

set_character()
player.CharacterAdded:Connect(set_character)
player.CharacterRemoving:Connect(remove_character)
---# modules
--# teleport module
local teleport_module = {}

function teleport_module.teleport(place_id)
	while task.wait(1.5) do
		teleportService:Teleport(place_id, player)
	end
end

---# modules end
local window
local library_components = {}
local config = {}
local key = "romaniandestroylonely"
local settingsFile = "opium/configs/%s.opium"
local defaultSettings = {
	--# toggles
	["ChatLogger"] = false;
	["FlightToggle"] = false;

	--# sliders
	["FlightSpeed"] = 10;

	--# keybinds
	["MenuKeybind"] = Enum.KeyCode.RightControl.Name,
	["FlightKeybind"] = Enum.KeyCode.T.Name,
	
	--# colors
	["MenuColor"] = {0, 0, 0}
}

if not isfolder("opium") then
	makefolder("opium")
end
if not isfolder("opium/configs") then
	makefolder("opium/configs")
end

if not pcall(function() readfile(string.format(settingsFile, "default")) end) then
	writefile(string.format(settingsFile, "default"), encrypt(httpService:JSONEncode(defaultSettings), key))
end

local function load_config(name)
	pcall(function()
		config = httpService:JSONDecode(decrypt(readfile(string.format(settingsFile, name)), key))
		for i, v in pairs(defaultSettings) do
			if not config[i] then
				config[i] = v
			end
		end
		for i, v in pairs(config) do
			for _, t in pairs(library_components) do
				if t[i] then
					local to_set = v
					if i:find("Keybind") then
						to_set = Enum.KeyCode[v]
					elseif i:find("Color") then
						to_set = Color3.fromRGB(table.unpack(v))
					end
					if i == "MenuColor" then
						t[i]:set(to_set)
						window:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
					else
						t[i]:set(to_set)
					end
				end
			end
		end
	end)
end
local function save_config(name)
	writefile(string.format(settingsFile, name), encrypt(httpService:JSONEncode(config), key))
end
load_config("default")
---# keybind handler
local keybinds = {
	["FlightKeybind"] = {
		connection = nil,
		value = config["FlightToggle"]
	}
}
userInput.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	for name, keycodeName in pairs(config) do
		if type(keycodeName) == "string" and Enum.KeyCode[keycodeName] and input.KeyCode == Enum.KeyCode[keycodeName] then
			if keybinds[name] then
				keybinds[name].value = not keybinds[name].value
				keybinds[name].connection:set(keybinds[name].value)
			end
		end
	end

	if input.KeyCode and keys[input.KeyCode.Name] then
		keys[input.KeyCode.Name] = 1
	end
end)
userInput.InputEnded:Connect(function(input, gpe)
	if gpe then
		return
	end

	if input.KeyCode and keys[input.KeyCode.Name] then
		keys[input.KeyCode.Name] = 0
	end
end)
---#
--#
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/splix"))()

window = library:new({
	textsize = 13.5,
	font = Enum.Font.RobotoMono,
	name = "opium",
	color = Color3.fromRGB(table.unpack(config["MenuColor"]))
})

local playerTab = window:page({
	name = "Player"
})

local playerTabLeft = playerTab:section({
	name = "",
	side = "left",
	size = 250
})

library_components["Toggles"] = {
	["FlightToggle"] = playerTabLeft:toggle({
		name = "Flight",
		def = config["FlightToggle"],
		callback = function(value)
			config["FlightToggle"] = value
		end,
	})
}
library_components["Sliders"] = {
	["FlightSpeed"] = playerTabLeft:slider({
		name = "Flight Speed",
		def = config["FlightSpeed"],
		min = 0,
		max = 300,
		rounding = true,
		ticking = false,
		callback = function(value)
			config["FlightSpeed"] = value
		end,
	})
}
keybinds["FlightKeybind"].connection = library_components["Toggles"]["FlightToggle"]

--# keybinds tab
local keybindsTab = window:page({
	name = "Keybinds"
})

local keybindsLeft = keybindsTab:section({
	name = "",
	side = "left",
	size = 250
})

keybindsLeft:keybind({
	name = "Flight",
	def = Enum.KeyCode[config["FlightKeybind"]],
	callback = function(key)
		config["FlightKeybind"] = key.Name
	end,
})
keybindsLeft:keybind({
	name = "Menu",
	def = Enum.KeyCode[config["MenuKeybind"]],
	callback = function(key)
		config["MenuKeybind"] = key.Name
		window.key = key
	end,
})

--# settings tab
local settingsTab = window:page({
	name = "Settings"
})

local settingsLeft = settingsTab:section({
	name = "Main",
	side = "left",
	size = 250
})

settingsLeft:button({
	name = "Save Configuration",
	callback = function()
		save_config(configurationName)
	end,
})
settingsLeft:button({
	name = "Load Configuration",
	callback = function()
		load_config(configurationName)
	end,
})
settingsLeft:textbox({
	name = "Configuration",
	def = configurationName,
	placeholder = configurationName,
	callback = function(value)
		configurationName = value
	end,
})

local guiColors = settingsTab:section({
	name = "Colors",
	side = "right",
	size = 250
})
library_components["ColorPickers"] = {
	["MenuColor"] = guiColors:colorpicker({
		name = "Menu Color",
		def = Color3.fromRGB(table.unpack(config["MenuColor"])),
		callback = function(value)
			config["MenuColor"][1] = math.floor(value.r * 255)
			config["MenuColor"][2] = math.floor(value.g * 255)
			config["MenuColor"][3] = math.floor(value.b * 255)
			window:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
		end,
	})
}

---# gui handler end
--# function handlers

runService.RenderStepped:Connect(function()
	if config["FlightToggle"] == true and character and torso and root then
		local direction = (camera.CFrame.RightVector * (keys.D - keys.A) + camera.CFrame.LookVector * (keys.W - keys.S));
		player.Character.HumanoidRootPart.Velocity = (direction * config["FlightSpeed"]);
	end
end)

--#
