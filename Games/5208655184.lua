--[[
BookOfPondus has a WKA
--]]

local PLAYERS = game:GetService("Players")
local CLIENT_STORAGE = game:GetService("ReplicatedStorage")
local RUN_SERVICE = game:GetService("RunService")
local SCRIPT_CONTEXT = game:GetService("ScriptContext")
local USER_INPUT = game:GetService("UserInputService")
local TWEEN_SERVICE = game:GetService("TweenService")
local HTTP_SERVICE = game:GetService("HttpService")

local EVENTS = CLIENT_STORAGE:WaitForChild("Events")
local REPLICATE_CAMERA = EVENTS:WaitForChild("ReplicateCamera")
local DAMAGE_EVENT = EVENTS:WaitForChild("HitPart")
local CONTROL_TURN = EVENTS:WaitForChild("ControlTurn")

local PLAYER = PLAYERS.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local CHARACTER, ROOT, HUMANOID, HEAD
local PLAYER_GUI = PLAYER.PlayerGui
local HUD = PLAYER_GUI:WaitForChild("GUI")
local CROSSHAIRS_GUI = HUD:WaitForChild("Crosshairs")
local CLIENT_SCRIPT = PLAYER_GUI:WaitForChild("Client")
local CLIENT_ENVIRONMENT = getsenv(CLIENT_SCRIPT)

local CAMERA = workspace.CurrentCamera

local SET_CONFIGURATION = "default"
local UNLOCKED_SKINS = false
local SPIN_CURRENT = 0
local KNIVES = {
	"Karambit"; "Knife"; "Bayonet"
}
local LAST_SHOOT = tick()
local LAST_KNIFE = tick()
local TO_HIT = nil

local HITBOXES = {
	Head = {"Head"};
	Chest = {"UpperTorso", "LowerTorso"};
	Arms = {"LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"};
	Legs = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"};
}

local LIBRARY = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/Games/5208655184.lua"))()

pcall(function() 
	for _, CONNECTION in pairs(getconnections(SCRIPT_CONTEXT.Error)) do 
		CONNECTION:Disable();
	end 
end)

local SILENTAIM_FOV_CIRCLE = Drawing.new("Circle")
SILENTAIM_FOV_CIRCLE.Thickness = 1
SILENTAIM_FOV_CIRCLE.Visible = false
SILENTAIM_FOV_CIRCLE.Color = Color3.fromRGB(255, 255,255)
SILENTAIM_FOV_CIRCLE.Filled = false

getgenv().CONFIG = {
	["KNIFE_BOT"] = false;
	["BHOP"] = false;
	["THIRD_PERSON"] = false;
	["SPIN_BOT"] = false;
	["HIDE_SCOPE"] = false;
	["TRIGGER_BOT_ENABLED"] = false;
	["KILL_AURA_ENABLED"] = false;
	["SILENT_AIM_ENABLED"] = false;
	["SILENT_AIM_FOV_CIRCLE"] = false;
	["NO_FALL_DAMAGE"] = false;
	["HIT_SOUND_ENABLED"] = false;
	["BULLET_TRACER_ENABLED"] = false;
	["PLAYER_ESP_TOGGLE"] = false;
	["PLAYER_ESP_BOX_TOGGLE"] = false;
	["PLAYER_ESP_HEALTH_BAR_TOGGLE"] = false;
	["PLAYER_ESP_TEAM_COLOR_TOGGLE"] = false;
	["PLAYER_ESP_IGNORE_TEAM_TOGGLE"] = false;
	["SILENT_AIM_USE_KNIFE_TOGGLE"] = false;
	
	
	["BHOP_SPEED"] = 10;
	["SILENT_AIM_FOV"] = 150;
	["SILENT_AIM_HIT_CHANCE"] = 100;
	["PLAYER_ESP_TEXT_SIZE"] = 15;
	["PLAYER_ESP_TEXT_FONT"] = 1;
	
	["TRIGGER_BOT_HIT_PART"] = "Head";
	["SILENT_AIM_HIT_PART"] = "Head";
	["HIT_SOUND_ID"] = "";
	
	["PLAYER_ESP_PRIMARY_COLOR"] = {255, 255, 255};
	["MENU_COLOR"] = {0, 0, 0};
}

local DEFAULT_CONFIG = CONFIG

local WINDOW = LIBRARY:new({
	textsize = 13.5;
	font = Enum.Font.RobotoMono;
	name = "*";
	color = Color3.fromRGB(table.unpack(CONFIG.MENU_COLOR));
})

local COMBAT_TAB = WINDOW:page({
	name = "COMBAT";
})
local VISUALS_TAB = WINDOW:page({
	name = "VISUALS";
})
local MOVEMENT_TAB = WINDOW:page({
	name = "MOVEMENT";
})
local MISC_TAB = WINDOW:page({
	name = "MISC";
})
local SETTINGS_TAB = WINDOW:page({
	name = "SETTINGS";
})

local SILENT_AIM = COMBAT_TAB:section({
	name = "SILENT AIM";
	side = "left";
	size = 150;
})
local SILENT_AIM_ENABLED = SILENT_AIM:toggle({
	name = "Enabled";
	def = CONFIG.SILENT_AIM_ENABLED;
})
local SILENT_AIM_USE_KNIFE_TOGGLE = SILENT_AIM:toggle({
	name = "Allow Knife";
	def = CONFIG.SILENT_AIM_USE_KNIFE_TOGGLE;
})
local SILENT_AIM_HIT_CHANCE = SILENT_AIM:slider({
	name = "Hit Chance";
	def = CONFIG.SILENT_AIM_HIT_CHANCE;
	min = 0; max = 100;
	rounding = true;
})
local SILENT_AIM_FOV_CIRCLE = SILENT_AIM:toggle({
	name = "Show FOV Circle";
	def = CONFIG.SILENT_AIM_FOV_CIRCLE;
})
local SILENT_AIM_FOV = SILENT_AIM:slider({
	name = "FOV";
	def = CONFIG.SILENT_AIM_FOV;
	min = 0; max = 300;
	rounding = true;
})

local SILENT_AIM_HIT_PART = SILENT_AIM:dropdown({
	name = "Hitbox";
	def = CONFIG.SILENT_AIM_HIT_PART;
	max = 4;
	options = {
		"Head";
		"Chest";
		"Arms";
		"Legs";
	};
})

local TRIGGER_BOT = COMBAT_TAB:section({
	name = "TRIGGER BOT";
	side = "right";
	size = 150;
})
local TRIGGER_BOT_ENABLED = TRIGGER_BOT:toggle({
	name = "Enabled";
	def = CONFIG.TRIGGER_BOT_ENABLED;
})
local TRIGGER_BOT_HIT_PART = TRIGGER_BOT:dropdown({
	name = "Hitbox";
	def = CONFIG.TRIGGER_BOT_HIT_PART;
	max = 2;
	options = {
		"Head";
		"HumanoidRootPart";
	};
})

local KILL_AURA = COMBAT_TAB:section({
	name = "KILL AURA";
	side = "left";
	size = 150;
})
local KILL_AURA_ENABLED = KILL_AURA:toggle({
	name = "Enabled";
	def = CONFIG.KILL_AURA_ENABLED;
})

local PLAYER_ESP_SECTION = VISUALS_TAB:section({
	name = "PLAYER ESP";
	side = "left";
	size = 150;
})
local PLAYER_ESP_TOGGLE = PLAYER_ESP_SECTION:toggle({
	name = "Enabled";
	def = CONFIG.PLAYER_ESP_TOGGLE;
})
local PLAYER_ESP_BOX_TOGGLE = PLAYER_ESP_SECTION:toggle({
	name = "Boxes";
	def = CONFIG.PLAYER_ESP_BOX_TOGGLE;
})
local PLAYER_ESP_HEALTH_BAR_TOGGLE = PLAYER_ESP_SECTION:toggle({
	name = "Health Bar";
	def = CONFIG.PLAYER_ESP_HEALTH_BAR_TOGGLE;
})
local PLAYER_ESP_IGNORE_TEAM_TOGGLE = PLAYER_ESP_SECTION:toggle({
	name = "Ignore Team";
	def = CONFIG.PLAYER_ESP_IGNORE_TEAM_TOGGLE;
})
local PLAYER_ESP_TEAM_COLOR_TOGGLE = PLAYER_ESP_SECTION:toggle({
	name = "Team Color";
	def = CONFIG.PLAYER_ESP_TEAM_COLOR_TOGGLE;
})
local PLAYER_ESP_TEXT_SIZE = PLAYER_ESP_SECTION:slider({
	name = "Text Size";
	def = CONFIG.PLAYER_ESP_TEXT_SIZE;
	min = 0; max = 20;
	rounding = true;
})
local PLAYER_ESP_TEXT_FONT = PLAYER_ESP_SECTION:slider({
	name = "Text Font";
	def = CONFIG.PLAYER_ESP_TEXT_FONT;
	min = 0; max = 3;
	rounding = true;
})
local PLAYER_ESP_PRIMARY_COLOR = PLAYER_ESP_SECTION:colorpicker({
	name = "Color";
	def = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR));
	cpname = nil;
})

local OTHER_SECTION = VISUALS_TAB:section({
	name = "OTHERS";
	side = "right";
	size = 150;
})
local HIDE_SCOPE = OTHER_SECTION:toggle({
	name = "Hide Scope";
	def = CONFIG.HIDE_SCOPE;
})

local MOVEMENT_SECTION = MOVEMENT_TAB:section({
	name = "";
	side = "left";
	size = 150;
})

local BHOP = MOVEMENT_SECTION:toggle({
	name = "BHop";
	def = CONFIG.BHOP;
})
local BHOP_SPEED = MOVEMENT_SECTION:slider({
	name = "BHop Speed";
	def = CONFIG.BHOP_SPEED;
	min = 0; max = 300;
	rounding = true;
})
local SPIN_BOT = MOVEMENT_SECTION:toggle({
	name = "Spin Bot";
	def = CONFIG.SPIN_BOT;
})

local MISC_SECTION = MISC_TAB:section({
	name = "";
	side = "left";
	size = 150;
})

local THIRD_PERSON = MISC_SECTION:toggle({
	name = "Third Person";
	def = CONFIG.THIRD_PERSON;
})

local KNIFE_BOT = MISC_SECTION:toggle({
	name = "Knife Bot";
	def = CONFIG.KNIFE_BOT;
})
local NO_FALL_DAMAGE = MISC_SECTION:toggle({
	name = "No Fall Damage";
	def = CONFIG.NO_FALL_DAMAGE;
})
local BULLET_TRACER_ENABLED = MISC_SECTION:toggle({
	name = "Bullet Tracer";
	def = CONFIG.BULLET_TRACER_ENABLED;
})
local HIT_SOUND_ENABLED = MISC_SECTION:toggle({
	name = "Hit Sound";
	def = CONFIG.HIT_SOUND_ENABLED;
})
local HIT_SOUND_ID = MISC_SECTION:textbox({
	name = "Hit Sound ID";
	def = CONFIG.HIT_SOUND_ID;
	placeholder = CONFIG.HIT_SOUND_ID;
	callback = function(ID)
		CONFIG.HIT_SOUND_ID = ID
	end;
})
MISC_SECTION:button({
	name = "UNLOCK ALL SKINS";
	callback = function()
		if not UNLOCKED_SKINS then
			UNLOCKED_SKINS = true
			loadstring(game:HttpGet("https://pastebin.com/raw/bjkeLmVr"))()
		end
	end;
})

local MAIN_SETTINGS_SECTION = SETTINGS_TAB:section({
	name = "";
	side = "left";
	size = 150;
})

local CONFIGURATION_NAME_BOX = MAIN_SETTINGS_SECTION:textbox({
	name = "Configuration";
	def = SET_CONFIGURATION;
	placeholder = SET_CONFIGURATION;
	callback = function(value)
		SET_CONFIGURATION = value;
	end;
})
local SAVE_CONFIGURATION_BUTTON = MAIN_SETTINGS_SECTION:button({
	name = "Save Configuration";
	callback = function()
		SAVE_CONFIG(SET_CONFIGURATION);
	end;
})
local LOAD_CONFIGURATION_BUTTON = MAIN_SETTINGS_SECTION:button({
	name = "Load Configuration";
	callback = function()
		LOAD_CONFIG(SET_CONFIGURATION);
	end;
})

local MENU_COLOR = MAIN_SETTINGS_SECTION:colorpicker({
	name = "Menu Color";
	def = Color3.fromRGB(table.unpack(CONFIG.MENU_COLOR));
	cpname = nil;
})
--# LOGIC

--// config

local CONFIG_PATH = "opium/configs/%s.opium"

if not isfolder("opium") then
	makefolder("opium")
end
if not isfolder("opium/configs") then
	makefolder("opium/configs")
end

if not pcall(function() readfile(string.format(CONFIG_PATH, "default")) end) then
	writefile(string.format(CONFIG_PATH, "default"), HTTP_SERVICE:JSONEncode(CONFIG))
end

function LOAD_CONFIG(CONFIG_NAME)
	local LOADED_CONFIG = HTTP_SERVICE:JSONDecode(readfile(string.format(CONFIG_PATH, CONFIG_NAME)))
	--# set new settings if it doesnt have them
	--[[for KEY, VALUE in pairs(DEFAULT_CONFIG) do
		if not LOADED_CONFIG[KEY] then
			LOADED_CONFIG[KEY] = VALUE
		end
	end]]
	--#
	local CORRESPONDS = {
		["KNIFE_BOT"] = KNIFE_BOT;
		["BHOP"] = BHOP;
		["THIRD_PERSON"] = THIRD_PERSON;
		["SPIN_BOT"] = SPIN_BOT;
		["HIDE_SCOPE"] = HIDE_SCOPE;
		["TRIGGER_BOT_ENABLED"] = TRIGGER_BOT_ENABLED;
		["KILL_AURA_ENABLED"] = KILL_AURA_ENABLED;
		["SILENT_AIM_ENABLED"] = SILENT_AIM_ENABLED;
		["SILENT_AIM_FOV_CIRCLE"] = SILENT_AIM_FOV_CIRCLE;
		["NO_FALL_DAMAGE"] = NO_FALL_DAMAGE;
		["HIT_SOUND_ENABLED"] = HIT_SOUND_ENABLED;
		["BULLET_TRACER_ENABLED"] = BULLET_TRACER_ENABLED;
		["PLAYER_ESP_TOGGLE"] = PLAYER_ESP_TOGGLE;
		["PLAYER_ESP_BOX_TOGGLE"] = PLAYER_ESP_BOX_TOGGLE;
		["PLAYER_ESP_HEALTH_BAR_TOGGLE"] = PLAYER_ESP_HEALTH_BAR_TOGGLE;
		["PLAYER_ESP_TEAM_COLOR_TOGGLE"] = PLAYER_ESP_TEAM_COLOR_TOGGLE;
		["PLAYER_ESP_IGNORE_TEAM_TOGGLE"] = PLAYER_ESP_IGNORE_TEAM_TOGGLE;
		["SILENT_AIM_USE_KNIFE_TOGGLE"] = SILENT_AIM_USE_KNIFE_TOGGLE;

		["BHOP_SPEED"] = BHOP_SPEED;
		["SILENT_AIM_FOV"] = SILENT_AIM_FOV;
		["SILENT_AIM_HIT_CHANCE"] = SILENT_AIM_HIT_CHANCE;
		["PLAYER_ESP_TEXT_SIZE"] = PLAYER_ESP_TEXT_SIZE;
		["PLAYER_ESP_TEXT_FONT"] = PLAYER_ESP_TEXT_FONT;

		["TRIGGER_BOT_HIT_PART"] = TRIGGER_BOT_HIT_PART;
		["SILENT_AIM_HIT_PART"] = SILENT_AIM_HIT_PART;
		["HIT_SOUND_ID"] = HIT_SOUND_ID;

		["PLAYER_ESP_PRIMARY_COLOR"] = PLAYER_ESP_PRIMARY_COLOR;
		["MENU_COLOR"] = MENU_COLOR;
	}

	for KEY, VALUE in pairs(LOADED_CONFIG) do
		if CORRESPONDS[KEY] then
			local TO_SET = VALUE
			if typeof(VALUE) == "table" then
				TO_SET = Color3.fromRGB(table.unpack(VALUE))
			end
			print(tostring(KEY), " = ", tostring(VALUE))
			CORRESPONDS[KEY]:set(TO_SET)
		end
	end
end
function SAVE_CONFIG(CONFIG_NAME)
	writefile(string.format(CONFIG_PATH, CONFIG_NAME), HTTP_SERVICE:JSONEncode(CONFIG))
end

--//

BHOP.callback = function(value)
	CONFIG.BHOP = value;
end
KNIFE_BOT.callback = function(value)
	CONFIG.KNIFE_BOT = value;
end
THIRD_PERSON.callback = function(value)
	CONFIG.THIRD_PERSON = value;
end
SPIN_BOT.callback = function(value)
	CONFIG.SPIN_BOT = value;
end
BHOP_SPEED.callback = function(value)
	CONFIG.BHOP_SPEED = value;
end
HIDE_SCOPE.callback = function(value)
	CONFIG.HIDE_SCOPE = value;
end
TRIGGER_BOT_ENABLED.callback = function(value)
	CONFIG.TRIGGER_BOT_ENABLED = value;
end
TRIGGER_BOT_HIT_PART.callback = function(value)
	CONFIG.TRIGGER_BOT_HIT_PART = value;
end
KILL_AURA_ENABLED.callback = function(value)
	CONFIG.KILL_AURA_ENABLED = value;
end
SILENT_AIM_ENABLED.callback = function(value)
	CONFIG.SILENT_AIM_ENABLED = value;
end
SILENT_AIM_FOV.callback = function(value)
	CONFIG.SILENT_AIM_FOV = value;
end
SILENT_AIM_FOV_CIRCLE.callback = function(value)
	CONFIG.SILENT_AIM_FOV_CIRCLE = value;
end
SILENT_AIM_HIT_PART.callback = function(value)
	CONFIG.SILENT_AIM_HIT_PART = value;
end
NO_FALL_DAMAGE.callback = function(value)
	CONFIG.NO_FALL_DAMAGE = value;
end
HIT_SOUND_ENABLED.callback = function(value)
	CONFIG.HIT_SOUND_ENABLED = value;
end
BULLET_TRACER_ENABLED.callback = function(value)
	CONFIG.BULLET_TRACER_ENABLED = value;
end
SILENT_AIM_HIT_CHANCE.callback = function(value)
	CONFIG.SILENT_AIM_HIT_CHANCE = value;
end
PLAYER_ESP_TOGGLE.callback = function(value)
	CONFIG.PLAYER_ESP_TOGGLE = value;
end
PLAYER_ESP_BOX_TOGGLE.callback = function(value)
	CONFIG.PLAYER_ESP_BOX_TOGGLE = value;
end
PLAYER_ESP_HEALTH_BAR_TOGGLE.callback = function(value)
	CONFIG.PLAYER_ESP_HEALTH_BAR_TOGGLE = value;
end
PLAYER_ESP_TEXT_SIZE.callback = function(value)
	CONFIG.PLAYER_ESP_TEXT_SIZE = value;
end
PLAYER_ESP_TEXT_FONT.callback = function(value)
	CONFIG.PLAYER_ESP_TEXT_FONT = value;
end
PLAYER_ESP_PRIMARY_COLOR.callback = function(value)
	CONFIG.PLAYER_ESP_PRIMARY_COLOR = {
		math.floor(value.R * 255),
		math.floor(value.G * 255),
		math.floor(value.B * 255)
	}
end
MENU_COLOR.callback = function(value)
	CONFIG.MENU_COLOR = {
		math.floor(value.R * 255),
		math.floor(value.G * 255),
		math.floor(value.B * 255)
	}
	WINDOW:settheme("accent", value)
end
PLAYER_ESP_TEAM_COLOR_TOGGLE.callback = function(value)
	CONFIG.PLAYER_ESP_TEAM_COLOR_TOGGLE = value;
end
PLAYER_ESP_IGNORE_TEAM_TOGGLE.callback = function(value)
	CONFIG.PLAYER_ESP_IGNORE_TEAM_TOGGLE = value;
end

local function CHARACTER_ADDED()
	CHARACTER = PLAYER.Character
	if CHARACTER then
		ROOT = CHARACTER:WaitForChild("HumanoidRootPart")
		HUMANOID = CHARACTER:WaitForChild("Humanoid")
		HEAD = CHARACTER:WaitForChild("Head")
	end
end
local function CHARACTER_REMOVED()
	CHARACTER = nil; ROOT = nil; HUMANOID = nil; HEAD = nil
end
CHARACTER_ADDED()
PLAYER.CharacterAdded:Connect(CHARACTER_ADDED)
PLAYER.CharacterRemoving:Connect(CHARACTER_REMOVED)

function CREATE_BULLET_TRACER(FROM, TO)
	local BEAM = Instance.new("Part")
	BEAM.Anchored = true
	BEAM.CanCollide = false
	BEAM.Material = Enum.Material.ForceField
	BEAM.Color = Color3.fromRGB(28, 187, 255)
	BEAM.Size = Vector3.new(0.1, 0.1, (FROM - TO).Magnitude)
	BEAM.CFrame = CFrame.lookAt(FROM, TO) * CFrame.new(0, 0, -BEAM.Size.Z / 2)
	BEAM.Parent = workspace.Debris
	task.delay(2, function()
		TWEEN_SERVICE:Create(BEAM, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Transparency = 1;
		}):Play()
		task.delay(0.5, game.Destroy, BEAM)
	end)
	return BEAM
end

local function HAS_KNIFE(CHARACTER)
	local EQUIPPED_TOOL = CHARACTER:WaitForChild("EquippedTool")
	for _, MATCH in pairs(KNIVES) do
		if EQUIPPED_TOOL.Value:find(MATCH) then
			return true
		end
	end
	return false
end

local function GET_CLOSEST_TO_MOUSE(RADIUS)
	local OPP = nil
	for _, TARGET in pairs(workspace:GetChildren()) do
		if TARGET ~= CHARACTER and ROOT and TARGET:IsA("Model") and TARGET:FindFirstChild("Humanoid") and TARGET:FindFirstChild("HumanoidRootPart")and TARGET:FindFirstChild("Head") and PLAYERS:FindFirstChild(tostring(TARGET)) and PLAYERS:FindFirstChild(tostring(TARGET)).Team ~= PLAYER.Team and TARGET:FindFirstChild("Humanoid").Health > 0 then
			--# is alive
			for _, HITBOX in pairs(HITBOXES[CONFIG.SILENT_AIM_HIT_PART]) do
				if TARGET[HITBOX] then
					local POSITION, VISIBLE = CAMERA:WorldToViewportPoint(TARGET[HITBOX].Position)
					local MAGNITUDE = (Vector2.new(POSITION.X, POSITION.Y) - Vector2.new(MOUSE.X, MOUSE.Y)).Magnitude
					if VISIBLE and MAGNITUDE < RADIUS then
						OPP = TARGET[HITBOX]
						RADIUS = MAGNITUDE
					end
				end
			end
		end
	end	
	return OPP
end

local function CAN_PENETRATE(PART)
	if PART.Transparency == 1 or PART.CanCollide == false or tostring(PART) == "Glass" or tostring(PART) == "Cardboard" or PART:IsDescendantOf(workspace.Ray_Ignore) or PART:IsDescendantOf(workspace.Debris) or PART and PART.Parent and tostring(PART.Parent) == "Hitboxes" then
		return true
	end
	return false
end

local function GET_CLOSEST_OPP(RADIUS)
	local OPP = nil
	for _, TARGET in pairs(workspace:GetChildren()) do
		if TARGET ~= CHARACTER and ROOT and TARGET:IsA("Model") and TARGET:FindFirstChild("Humanoid") and TARGET:FindFirstChild("HumanoidRootPart") and TARGET:FindFirstChild("Head") and PLAYERS:FindFirstChild(tostring(TARGET)) and PLAYERS:FindFirstChild(tostring(TARGET)).Team ~= PLAYER.Team and TARGET:FindFirstChild("Humanoid").Health > 0 then
			--# IS ALIVE
			local TARGET_ROOT = TARGET:FindFirstChild("HumanoidRootPart")
			local MAGNITUDE = (ROOT.Position - TARGET_ROOT.Position).Magnitude
			if MAGNITUDE < RADIUS then
				MAGNITUDE = RADIUS
				OPP = TARGET
			end
		end
	end
	return OPP
end

local META_TABLE = getrawmetatable(game)
setreadonly(META_TABLE, false)
local OLD_INDEX = META_TABLE.__index
local OLD_NEWINDEX = META_TABLE.__newindex
local OLD_NAMECALL


OLD_NAMECALL = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local METHOD = getnamecallmethod()
	local ARGUMENTS = {...}
	
	if METHOD == "FindPartOnRayWithIgnoreList" then
		if CONFIG.SILENT_AIM_ENABLED and TO_HIT and math.random(0, 100) <= CONFIG.SILENT_AIM_HIT_CHANCE and (CONFIG.SILENT_AIM_USE_KNIFE_TOGGLE and CHARACTER.EquippedTool.Value:find("Knife") or CHARACTER.EquippedTool.Value:find("Karambit") or CHARACTER.EquippedTool.Value:find("Bayonet")) then
			ARGUMENTS[1] = Ray.new(CAMERA.CFrame.Position, (TO_HIT.Position + Vector3.new(0, (CAMERA.CFrame.Position - TO_HIT.Position).Magnitude/500, 0) - CAMERA.CFrame.Position).Unit * 500)
			return OLD_NAMECALL(self, unpack(ARGUMENTS))	
		elseif CONFIG.KILL_AURA_ENABLED and TO_HIT then
			ARGUMENTS[1] = Ray.new(CAMERA.CFrame.Position, (TO_HIT.Position + Vector3.new(0, (CAMERA.CFrame.Position - TO_HIT.Position).Magnitude/500, 0) - CAMERA.CFrame.Position).Unit * 500)
			return OLD_NAMECALL(self, unpack(ARGUMENTS))
		end
	end
	
	if METHOD == "FireServer" then
		if self.Name == "FallDamage" and CONFIG.NO_FALL_DAMAGE then
			return
		end
		if self.Name == "HitPart" then
			task.spawn(function()
				local HIT_PLAYER = PLAYERS:FindFirstChild(tostring(ARGUMENTS[1].Parent))
				if HIT_PLAYER then
					if CONFIG.HIT_SOUND_ENABLED then
						local HIT_SOUND = Instance.new("Sound")
						HIT_SOUND.SoundId = CONFIG.HIT_SOUND_ID
						HIT_SOUND.PlayOnRemove = true
						HIT_SOUND.Volume = 1.75
						HIT_SOUND.Parent = workspace
						HIT_SOUND:Destroy()
					end
				end
				if CONFIG.BULLET_TRACER_ENABLED and CAMERA:FindFirstChild("Arms") then
					CREATE_BULLET_TRACER(HEAD.Position, ARGUMENTS[2])
				end
			end)
		end
	end
	
	return OLD_NAMECALL(self, ...)
end))
META_TABLE.__newindex = newcclosure(function(self, property, value)
	if self == CROSSHAIRS_GUI and CONFIG.HIDE_SCOPE and CHARACTER and CHARACTER:FindFirstChild("ADS").Value == true and tostring(property) == "Position" then
		return UDim2.new(0, 0, 0, 0)
	end
	
	return OLD_NEWINDEX(self, property, value)
end)

--// esp

local CACHE = {}

local function DRAW(CLASS, PROPERTIES)
	local DRAWING = Drawing.new(CLASS)
	for PROPERTY, VALUE in pairs(PROPERTIES) do
		DRAWING[PROPERTY] = VALUE
	end
	return DRAWING
end

local function CREATE_ESP(TARGET)
	local ESP = {}
	
	ESP.BOX_OUTLINE = DRAW("Square", {
		Color = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR)),
		Thickness = 2,
		Filled = false
	})
	ESP.BOX = DRAW("Square", {
		Color = Color3.new(1, 1, 1),
		Thickness = 1,
		Filled = false
	})
	ESP.NAME = DRAW("Text", {
		Color = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR)),
		Font = CONFIG.PLAYER_ESP_TEXT_FONT,
		Outline = true,
		Center = true,
		Size = CONFIG.PLAYER_ESP_TEXT_SIZE
	})
	ESP.HEALTH_OUTLINE = DRAW("Line", {
		Color = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR)),
		Thickness = 2
	})
	ESP.HEALTH = DRAW("Line", {
		Thickness = 1
	})
	CACHE[TARGET] = ESP
end

local function REMOVE_ESP(player)
	local ESP = CACHE[PLAYER]
	if ESP then
		for _, DRAWING in pairs(ESP) do
			DRAWING:Remove()
		end
		
		CACHE[PLAYER] = nil
	end
end

local function floor2(v)
	return Vector2.new(math.floor(v.X), math.floor(v.Y))
end

local function UPDATE_ESP()
	for TARGET, ESP in pairs(CACHE) do
		local TARGET_CHARACTER, TARGET_TEAM = TARGET.Character, TARGET.Team
		if TARGET_CHARACTER and CONFIG.PLAYER_ESP_TOGGLE and TARGET.Character:FindFirstChild("Humanoid") and TARGET.Character.Humanoid.Health > 0 and not (TARGET_TEAM == PLAYER.Team and CONFIG.PLAYER_ESP_IGNORE_TEAM_TOGGLE) then
			local TARGET_CFRAME = TARGET_CHARACTER:GetPivot()
			local SCREEN_POSITION, VISIBLE = CAMERA:WorldToViewportPoint(TARGET_CFRAME.Position)
			
			if VISIBLE and CONFIG.PLAYER_ESP_TOGGLE then
				local TARGET_HUMANOID = TARGET_CHARACTER:FindFirstChildOfClass("Humanoid")
				local TARGET_HEALTH = (TARGET_HUMANOID and TARGET_HUMANOID.Health or 100) / 100
				
				local FRUSTUM_HEIGHT = math.tan(math.rad(CAMERA.FieldOfView * 0.5)) * 2 * SCREEN_POSITION.Z
				local SIZE = CAMERA.ViewportSize.Y / FRUSTUM_HEIGHT * Vector2.new(4, 6)
				local POSITION = Vector2.new(SCREEN_POSITION.X, SCREEN_POSITION.Y)
				
				if CONFIG.PLAYER_ESP_BOX_TOGGLE then
					ESP.BOX_OUTLINE.Color = CONFIG.PLAYER_ESP_TEAM_COLOR_TOGGLE and TARGET.TeamColor.Color or Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR))
					ESP.BOX_OUTLINE.Size = floor2(SIZE)
					ESP.BOX_OUTLINE.Position = floor2(POSITION - SIZE * 0.5)

					ESP.BOX.Size = ESP.BOX_OUTLINE.Size
					ESP.BOX.Position = ESP.BOX_OUTLINE.Position
				end
				
				if CONFIG.PLAYER_ESP_HEALTH_BAR_TOGGLE then
					ESP.HEALTH_OUTLINE.Color = CONFIG.PLAYER_ESP_TEAM_COLOR_TOGGLE and TARGET.TeamColor.Color or Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR))
					ESP.HEALTH_OUTLINE.From = floor2(POSITION - SIZE * 0.5) - Vector2.xAxis * 5
					ESP.HEALTH_OUTLINE.To = floor2(POSITION - SIZE * Vector2.new(0.5, -0.5)) - Vector2.xAxis * 5

					ESP.HEALTH.From = ESP.HEALTH_OUTLINE.To
					ESP.HEALTH.To = floor2(ESP.HEALTH_OUTLINE.To:Lerp(ESP.HEALTH_OUTLINE.From, TARGET_HEALTH))
					ESP.HEALTH.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), TARGET_HEALTH)

					ESP.HEALTH_OUTLINE.From -= Vector2.yAxis
					ESP.HEALTH_OUTLINE.To += Vector2.yAxis
				end
				
				ESP.NAME.Color = CONFIG.PLAYER_ESP_TEAM_COLOR_TOGGLE and TARGET.TeamColor.Color or Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_PRIMARY_COLOR))
				ESP.NAME.Font = CONFIG.PLAYER_ESP_TEXT_FONT
				ESP.NAME.Size = CONFIG.PLAYER_ESP_TEXT_SIZE
				ESP.NAME.Text = CONFIG.PLAYER_ESP_HEALTH_BAR_TOGGLE and tostring(TARGET) or string.format("[%s] [%s/%s]", tostring(TARGET), tostring(math.floor(TARGET_HUMANOID.Health)), tostring(math.floor(TARGET_HUMANOID.MaxHealth)))
				ESP.NAME.Position = CONFIG.PLAYER_ESP_BOX_TOGGLE and floor2(POSITION - Vector2.yAxis * (SIZE.Y * 0.5 + ESP.NAME.TextBounds.Y + 4)) or POSITION
			end
			
			for TYPE, DRAWING in pairs(ESP) do
				DRAWING.Visible = VISIBLE
				
				if not CONFIG.PLAYER_ESP_BOX_TOGGLE and (ESP[TYPE] == ESP.BOX or ESP[TYPE] == ESP.BOX_OUTLINE) then
					DRAWING.Visible = false
				end
				if not CONFIG.PLAYER_ESP_HEALTH_BAR_TOGGLE and (ESP[TYPE] == ESP.HEALTH or ESP[TYPE] == ESP.HEALTH_OUTLINE) then
					DRAWING.Visible = false
				end
			end
		else
			for _, DRAWING in pairs(ESP) do
				DRAWING.Visible = false
			end
		end
	end
end

PLAYERS.PlayerAdded:Connect(CREATE_ESP)
PLAYERS.PlayerRemoving:Connect(REMOVE_ESP)
for INDEX, TARGET in ipairs(PLAYERS:GetPlayers()) do
	if INDEX ~= 1 then
		CREATE_ESP(TARGET)
	end
end

--//

RUN_SERVICE.RenderStepped:Connect(function()
	UPDATE_ESP()
	if CONFIG.SILENT_AIM_ENABLED then
		TO_HIT = GET_CLOSEST_TO_MOUSE(CONFIG.SILENT_AIM_FOV)
	elseif CONFIG.KILL_AURA_ENABLED then
		local CLOSEST = GET_CLOSEST_OPP(50)
		if CLOSEST then
			local IGNORE = {CLOSEST, CHARACTER, CAMERA, workspace.Debris, workspace.Ray_Ignore}
			if workspace.Map:FindFirstChild("Clips") then
				table.insert(IGNORE, workspace.Map.Clips)
			end
			local WALL = workspace:FindPartOnRayWithIgnoreList(Ray.new(HEAD.Position, (HEAD.Position - CLOSEST:WaitForChild("Head").Position)), IGNORE)
			if WALL and CAN_PENETRATE(WALL) then
				return
			end
			
			TO_HIT = CLOSEST:WaitForChild("Head")
			CLIENT_ENVIRONMENT["firebullet"]()
		end
	end
	if CONFIG.SILENT_AIM_FOV_CIRCLE then
		SILENTAIM_FOV_CIRCLE.Position = USER_INPUT:GetMouseLocation()
		SILENTAIM_FOV_CIRCLE.Radius = CONFIG.SILENT_AIM_FOV
		SILENTAIM_FOV_CIRCLE.Visible = true
	else
		SILENTAIM_FOV_CIRCLE.Visible = false
	end
	if CONFIG.TRIGGER_BOT_ENABLED and CHARACTER and not HAS_KNIFE(CHARACTER) then
		if MOUSE.Target and PLAYERS:FindFirstChild(tostring(MOUSE.Target.Parent)) and PLAYERS:FindFirstChild(tostring(MOUSE.Target.Parent)).Team ~= PLAYER.Team then
			local HIT_PART = CONFIG.TRIGGER_BOT_HIT_PART == "Head" and MOUSE.Target.Parent:FindFirstChild("HeadHB") or MOUSE.Target.Parent:FindFirstChild("HumanoidRootPart")
			if (MOUSE.Target.Position - HIT_PART.Position).Magnitude <= 1 then
				local FIRE_RATE = CLIENT_STORAGE:WaitForChild("Weapons"):FindFirstChild(CHARACTER:WaitForChild("EquippedTool").Value):WaitForChild("FireRate").Value
				if tick() - LAST_SHOOT > FIRE_RATE then
					LAST_SHOOT = tick()
					CLIENT_ENVIRONMENT["firebullet"]()
				end
			end
		end
	end
	if CONFIG.KNIFE_BOT then
		local CLOSEST_TARGET = GET_CLOSEST_OPP(5)
		if CLOSEST_TARGET and HAS_KNIFE(CHARACTER) and tick() - LAST_KNIFE > 0.05 then
			LAST_KNIFE = tick()
			
			CAMERA.CFrame = CFrame.lookAt(CAMERA.CFrame.Position, CLOSEST_TARGET:FindFirstChild("Head").Position)
			CLIENT_ENVIRONMENT["firebullet"]()
		end
	end
	if CONFIG.BHOP then	
		if CHARACTER and HUMANOID and ROOT then
			if USER_INPUT:IsKeyDown(Enum.KeyCode.Space) and not USER_INPUT:GetFocusedTextBox() then
				HUMANOID.Jump = true
				if ROOT:FindFirstChild("BHOP_VELO") then
					ROOT:FindFirstChild("BHOP_VELO").Velocity = ROOT.AssemblyLinearVelocity * (Vector3.one * (CONFIG.BHOP_SPEED / 10))
				else
					local BHOP_VELO = Instance.new("BodyVelocity")
					BHOP_VELO.Name = "BHOP_VELO"
					BHOP_VELO.MaxForce = Vector3.new(1, 0, 1) * 100000
					BHOP_VELO.Velocity = ROOT.AssemblyLinearVelocity * (Vector3.one * (CONFIG.BHOP_SPEED / 10))
					BHOP_VELO.Parent = ROOT
				end
			else
				if ROOT:FindFirstChild("BHOP_VELO") then
					ROOT:FindFirstChild("BHOP_VELO"):Destroy()
				end
			end
		end
	end
	if CONFIG.HIDE_SCOPE then
		for i = 1, 4 do
			if CROSSHAIRS_GUI:FindFirstChild(string.format("Frame%s", tostring(i))) then
				CROSSHAIRS_GUI:FindFirstChild(string.format("Frame%s", tostring(i))).Visible = false
			end
		end
		local SCOPE = CROSSHAIRS_GUI:FindFirstChild("Scope")
		local FAKE_SCOPE = SCOPE:FindFirstChild("FakeScope")
		if not FAKE_SCOPE then
			FAKE_SCOPE = SCOPE:FindFirstChild("Scope"):Clone()
			FAKE_SCOPE.Name = "FakeScope"
			FAKE_SCOPE.Parent = SCOPE
		end
		local REAL_SCOPE = SCOPE:FindFirstChild("Scope")
		SCOPE.ImageTransparency = 1
		if CHARACTER and CHARACTER:FindFirstChild("ADS") and CHARACTER:FindFirstChild("ADS").Value == true then
			CROSSHAIRS_GUI.Position = UDim2.new(0, 0, 0, 0)
			REAL_SCOPE.ImageTransparency = 1
			FAKE_SCOPE.Position = UDim2.fromOffset(-750, -750)
			FAKE_SCOPE.Visible = true
			FAKE_SCOPE.ImageTransparency = 0
			FAKE_SCOPE.Size = UDim2.new(1, 1500, 1, 1500)
			REAL_SCOPE:FindFirstChild("Blur").Visible = false
		end
	end
	if CONFIG.SPIN_BOT then
		if CHARACTER and HUMANOID and ROOT then
			CONTROL_TURN:FireServer(math.random(-1000, 1000))
			
			SPIN_CURRENT = SPIN_CURRENT + 45
			HUMANOID.AutoRotate = false
			ROOT.CFrame = CFrame.new(ROOT.Position, ROOT.Position + Vector3.new(5, 0, 0)) * CFrame.Angles(0, math.rad(SPIN_CURRENT), 0)
		end
	else
		if CHARACTER and HUMANOID and ROOT then
			HUMANOID.AutoRotate = true
		end
	end
	if CONFIG.THIRD_PERSON or not CHARACTER then
		PLAYER.CameraMaxZoomDistance = 15
		PLAYER.CameraMinZoomDistance = 15
		PLAYER.CameraMode = Enum.CameraMode.Classic
	else
		PLAYER.CameraMaxZoomDistance = 0.5
		PLAYER.CameraMinZoomDistance = 0.5
		PLAYER.CameraMode = Enum.CameraMode.LockFirstPerson
	end
end)

LOAD_CONFIG("default")
