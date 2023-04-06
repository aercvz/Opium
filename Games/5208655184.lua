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
local esps = {}
local recent_parts = {}
local roblox_materials = {"Plastic"; "SmoothPlastic"; "Neon"; "Wood"; "WoodPlanks"; "Marble"; "Slate"; "Concrete"; "Granite"; "Brick"; "Pebble"; "Cobblestone"; "CorrodedMetal"; "DiamondPlate"; "Foil"; "Metal"; "Grass"; "Sand"; "Fabric"; "Ice"; "ForceField"; "Glass"}
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
--# utility module
local utility = {}

function utility.get_weapon()
	local hilt = character:WaitForChild("Hilt")
	local weapon = hilt:FindFirstChildWhichIsA("MeshPart") or torso:FindFirstChildWhichIsA("MeshPart") or nil
	return weapon
end

---# modules end
getgenv().config = {}
character.Archivable = true
local character_decoy = character:Clone()
local window, chat_logger
local library_components = {}
local key = "romaniandestroylonely"
local settingsFile = "opium/configs/%s.opium"
local defaultSettings = {
	--# toggles
	["ChatLoggerToggle"] = false;
	["FlightToggle"] = false;
	["NoFallToggle"] = false;
	["WeaponCustomizationToggle"] = false;
	["NoClipToggle"] = false;

	--# sliders
	["FlightSpeed"] = 10;
	["WeaponCustomizationTransparency"] = 0;
	
	--# text boxes
	["MenuSize"] = "0, 500, 0, 500";
	["ChatLoggerSize"] = "0, 500, 0, 300";

	--# keybinds
	["MenuKeybind"] = Enum.KeyCode.RightControl.Name;
	["FlightKeybind"] = Enum.KeyCode.T.Name;
	["NoClipKeybind"] = Enum.KeyCode.T.Name;
	
	--# colors
	["MenuColor"] = {0, 0, 0};
	["WeaponCustomizationColor"] = {255, 255, 255};
	
	--# strings
	["WeaponCustomizationMaterial"] = "Metal"
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
					if not window then
						repeat task.wait() until window
					end
					if not chat_logger then
						repeat task.wait() until chat_logger
					end
					if i == "MenuColor" then
						t[i]:set(to_set)
						window:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
						chat_logger:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
					elseif i == "MenuSize" then
						window:setsize(string.split(config["MenuSize"]:gsub("%p", ""), " "))
					elseif i == "ChatLoggerSize" then
						chat_logger:setsize(string.split(config["ChatLoggerSize"]:gsub("%p", ""), " "))
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
	},
	["NoClipKeybind"] = {
		conection = nil,
		value = config["NoClipToggle"]
	}
}
userInput.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	for name, keycodeName in pairs(config) do
		if name:find("Keybind") and Enum.KeyCode[keycodeName] and input.KeyCode == Enum.KeyCode[keycodeName] then
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
--# funcs
local function create_esp(chr)
	if chr ~= character then
		local hum = chr:WaitForChild("Humanoid")
		local rootPart = chr:WaitForChild("HumanoidRootPart")

		local text = Drawing.new("Text")
		text.Visible = false
		text.Center = true--config["PlayerESPTextCentered"]
		text.Outline = true--config["PlayerESPTextOutline"]
		text.Font = 1--config["PlayerESPTextFont"]
		text.Color = Color3.fromRGB(255,255,255)--Color3.fromRGB(table.unpack(config["PlayerESPColor"]))
		text.Size = 18--config["PlayerESPTextSize"]

		local text_connections = {}
		esps[text] = {
			Text = text,
			Character = chr
		}

		local function disconnect()
			text.Visible = false
			text:Remove()
			esps[text] = nil
			for _, connection in pairs(text_connections) do
				connection:Disconnect()
			end
		end

		text_connections[1] = chr.AncestryChanged:Connect(function(_, parent)
			if not parent then
				disconnect()
			end
		end)
		text_connections[2] = hum.Died:Connect(disconnect)
	end
end
--#
--#
local chatLoggerLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/ChatLogger"))()
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/splix"))()

chat_logger = chatLoggerLibrary:new({
	size = string.split(config["ChatLoggerSize"]:gsub("%p", ""), " "),
	textsize = 13.5,
	font = Enum.Font.RobotoMono,
	name = "Chat Logger",
	color = Color3.fromRGB(table.unpack(config["MenuColor"]))
})

window = library:new({
	size = string.split(config["MenuSize"]:gsub("%p", ""), " "),
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

--# misc tab

local miscTab = window:page({
	name = "Misc"
})

local miscTabLeft = miscTab:section({
	name = "Main",
	side = "left",
	size = 250
})

--# esp tab

local espTab = window:page({
	name = "ESP"
})

local espTabLeft = espTab:section({
	name = "Main",
	side = "left",
	size = 250
})

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
			chat_logger:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
		end,
	}),
	["WeaponCustomizationColor"] = miscTabLeft:colorpicker({
		name = "Weapon Color",
		def = Color3.fromRGB(table.unpack(config["WeaponCustomizationColor"])),
		callback = function(value)
			config["WeaponCustomizationColor"][1] = math.floor(value.r * 255)
			config["WeaponCustomizationColor"][2] = math.floor(value.g * 255)
			config["WeaponCustomizationColor"][3] = math.floor(value.b * 255)
		end,
	}),
}

--# components

library_components["Toggles"] = {
	["FlightToggle"] = playerTabLeft:toggle({
		name = "Flight",
		def = config["FlightToggle"],
		callback = function(value)
			config["FlightToggle"] = value
		end,
	}),
	["NoClipToggle"] = playerTabLeft:toggle({
		name = "NoClip",
		def = config["NoClipToggle"],
		callback = function(value)
			config["NoClipToggle"] = value
		end,
	}),
	["NoFallToggle"] = playerTabLeft:toggle({
		name = "No Fall",
		def = config["NoFallToggle"],
		callback = function(value)
			config["NoFallToggle"] = value
		end,
	}),
	["ChatLoggerToggle"] = playerTabLeft:toggle({
		name = "Chat Logger",
		def = config["ChatLoggerToggle"],
		callback = function(value)
			config["ChatLoggerToggle"] = value
		end,
	}),
	["PlayerEspToggle"] = espTabLeft:toggle({
		name = "Player ESP",
		def = config["PlayerEspToggle"],
		callback = function(value)
			config["PlayerEspToggle"] = value
		end,
	}),
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
	}),
	["WeaponCustomizationTransparency"] = miscTabLeft:slider({
		name = "Weapon Transparency",
		def = config["WeaponCustomizationTransparency"],
		min = 0,
		max = 1,
		rounding = false,
		ticking = false,
		callback = function(value)
			config["WeaponCustomizationTransparency"] = value
		end,
	})
}
library_components["TextBoxes"] = {
	["MenuSize"] = guiColors:textbox({
		name = "Menu Size",
		def = config["MenuSize"],
		placeholder = config["MenuSize"],
		callback = function(value)
			config["MenuSize"] = value
			window:setsize(string.split(config["MenuSize"]:gsub("%p", ""), " "))
		end,
	}),
	["ChatLoggerSize"] = guiColors:textbox({
		name = "Chat Logger Size",
		def = config["ChatLoggerSize"],
		placeholder = config["ChatLoggerSize"],
		callback = function(value)
			config["ChatLoggerSize"] = value
			chat_logger:setsize(string.split(config["ChatLoggerSize"]:gsub("%p", ""), " "))
		end,
	}),
	["WeaponCustomizationMaterial"] = miscTabLeft:dropdown({
		name = "Weapon Material",
		def = config["WeaponCustomizationMaterial"],
		max = #roblox_materials,
		options = roblox_materials,
		callback = function(value)
			config["WeaponCustomizationMaterial"] = value
		end,
	})
}
keybinds["FlightKeybind"].connection = library_components["Toggles"]["FlightToggle"]
keybinds["NoClipKeybind"].connection = library_components["Toggles"]["NoClipToggle"]

library_components["Toggles"]["WeaponCustomizationToggle"] = miscTabLeft:toggle({
	name = "Customized Weapon",
	def = config["WeaponCustomizationToggle"],
	callback = function(value)
		config["WeaponCustomizationToggle"] = value
	end,
})

---# gui handler end
--# function handlers

runService.RenderStepped:Connect(function()
	chat_logger:update(config["ChatLoggerToggle"])
	if config["FlightToggle"] == true and character and torso and root then
		local direction = (camera.CFrame.RightVector * (keys.D - keys.A) + camera.CFrame.LookVector * (keys.W - keys.S));
		player.Character.HumanoidRootPart.Velocity = (direction * config["FlightSpeed"]);
	end
	if config["WeaponCustomizationToggle"] == true and utility.get_weapon() then
		local weapon = utility.get_weapon()
		weapon.Color = Color3.fromRGB(table.unpack(config["WeaponCustomizationColor"]))
		weapon.Transparency = config["WeaponCustomizationTransparency"]
		weapon.Material = config["WeaponCustomizationMaterial"]
	end
	if config["NoClipToggle"] == true and character and torso and root then
		character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)

		local partsInPart = workspace:GetPartsInPart(root)
		for _, part in pairs(partsInPart) do
			if recent_parts[part] or (not part:IsDescendantOf(character) and part.CanCollide == true) then
				recent_parts[part] = tick()
				part.CanCollide = false
			end
		end
	else
		for i, v in pairs(recent_parts) do
			i.CanCollide = true
		end
		table.clear(recent_parts)
	end
end)

clientStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering").OnClientEvent:Connect(function(object)
	if object.Message ~= "" then
		chat_logger:insert_label(string.format("[%s]: %s", object.FromSpeaker, object.Message))
	end
end)

loadstring([[
local oldCall
oldCall = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(event, ...)
	if not checkcaller() then
		print(config["NoFallToggle"])
		local arguments = {...}
		if config["NoFallToggle"] == true and arguments[1] and arguments[1][1] and typeof(arguments[1][1]) == "number" and arguments[1][1] < 1 then
			return
		end
	end
	
	return oldCall(event, ...)
end))
]])()

--#
