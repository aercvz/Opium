xpcall(function()
	repeat task.wait() until game:IsLoaded()
	
	print("PASSING CHECKS...")
	if not _G.key then
		return
	end
	print("CHECK 1 PASSED")
	if _G.key and (string.len(_G.key) < 30 or string.len(_G.key) > 30) then
		return
	end
	print("CHECK 2 PASSED")
	if _G.key and string.len(_G.key) == 30 then
		print("CHECK 3 PASSED")
		if request == print or request == error or request == nil or request == warn then
			return
		end
		print("CHECK 4 PASSED")
		local REQUEST = syn and syn.request or request
		local RESPONSE = REQUEST({Url = "https://opiumasterisk.000webhostapp.com/whitelist.php?key=".._G.key; Method = "GET"})
		if RESPONSE.Body == "" or string.len(RESPONSE.Body) ~= 100 then
			return
		end
		print("CHECK 5 PASSED")
	end

	local COLLECTION_SERVICE = game:GetService("CollectionService")
	local RUN_SERVICE = game:GetService("RunService")
	local CLIENT_STORAGE = game:GetService("ReplicatedStorage")
	local VIRTUAL_INPUT_MANAGER = game:GetService("VirtualInputManager")
	local HTTP_SERVICE = game:GetService("HttpService")
	local TELEPORT_SERVICE = game:GetService("TeleportService")
	local TWEEN_SERVICE = game:GetService("TweenService")
	local SCRIPT_CONTEXT = game:GetService("ScriptContext")
	local LIGHTING = game:GetService("Lighting")
	local USER_INPUT = game:GetService("UserInputService")
	local STARTER_GUI = game:GetService("StarterGui")
	local PLAYERS = game:GetService("Players")

	local REQUESTS = CLIENT_STORAGE:WaitForChild("Requests")
	local CHAT_EVENTS = CLIENT_STORAGE:WaitForChild("DefaultChatSystemChatEvents")
	local MESSAGE_FILTERING_EVENT = CHAT_EVENTS:WaitForChild("OnMessageDoneFiltering")

	local PLAYER = PLAYERS.LocalPlayer
	local MOUSE = PLAYER:GetMouse()
	local PLAYER_GUI = PLAYER.PlayerGui
	local CHARACTER, ROOT, HUMANOID, BOOSTS
	local CAMERA = workspace.CurrentCamera
	local SET_NPC = "Monk"
	local SET_CONFIGURATION = "default"
	local SET_TRINKET_BOT_PATH = ""
	local LAST_OWNERSHIP = tick()
	local BOT_RUNNING = false
	local SPECTATING = nil
	local BAN_ANIMATION = nil
	local INGREDIENTS_FOLDER = nil
	local FALL_DAMAGE_REMOTE = nil
	local PATH_BOT_SPEED = 100
	local PATH_BOT_ILLUSIONIST_DETECT = false
	local TWEEN_PLAYING = nil
	local FOUND_TRINKETS = {}
	local ARTIFACT_NAMES = {"Rift Gem"; "Mysterious Artifact"; "Azael Horn"; "Lannis's Amulet"; "Amulet of the White King"; "Night Stone"}
	local DIALOGUE_MODULE = {REMOTE = nil, CURRENT_MESSAGE = ""}
	local TELEPORT_DATA = TELEPORT_SERVICE:GetLocalPlayerTeleportData()
	local INN_TO_TELEPORT = "Castle Sanctuary"
	local SET_WAIT_VALUE = 7
	local NO_STUN_CONNECTION = nil
	local NOCLIP_STUN = nil
	local LOCK_ROOT_VELOCITY = false
	local CURRENT_CFRAME_POINTS = {
		["SETTINGS"] = {
			["ILLUSIONIST_DETECT"] = false;
			["PICK_UP_SCROLLS"] = true;
			["SPEED"] = 100;
			["WEBHOOK"] = "";
		};
		["POINTS"] = {
		}
	}
	local KILL_BRICK_CACHE = {}
	local ARTIFACT_STREAM_HOOK = "1129891245049778257/KeADPgxoE_ryvIPN-tcpszq-zaV2liYvNZDX79mMvGQaesrWHTkF_7DXjgOU8iAd4tvD"
	local KILL_BRICK_NAMES = {
		"Fire"; "KillBrick"; "PitKillBrick"; "ArdorianKillbrick"; "Lava"; "KillFire"; "SpectralFire"; "PoisonField"
	}
	local NOCLIPPED_PARTS = {}
	local KEYS = {
		["W"] = 0;
		["A"] = 0;
		["S"] = 0;
		["D"] = 0;
	}

	local POTIONS = {
		["Health Potion"] = {"Scroom"; "Lava Flower"; "Scroom"};
		["Switch Witch"] = {"Glow Shroom"; "Dire Flower"; "Glow Shroom"};
		["Tespian Elixir"] = {"Moss Plant"; "Lava Flower"; "Moss Plant"; "Scroom"};
	}

	getgenv().CONFIG = {
		["FLIGHT_TOGGLE"] = false;
		["NOCLIP_TOGGLE"] = false;
		["NO_FALL_DAMAGE_TOGGLE"] = false;
		["CHAT_LOGGER_TOGGLE"] = false;
		["PLAYER_ESP_TOGGLE"] = false;
		["TRINKET_ESP_TOGGLE"] = false;
		["FULL_BRIGHT_TOGGLE"] = false;
		["NO_FOG_TOGGLE"] = false;
		["AUTO_TRINKET_PICKUP_TOGGLE"] = false;
		["AUTO_INGREDIENT_PICKUP_TOGGLE"] = false;
		["KNOCKED_CHARACTER_OWNERSHIP_TOGGLE"] = false;
		["PERFLORA_TELEPORT_TOGGLE"] = false;
		["AUTO_BAG_PICKUP_TOGGLE"] = false;
		["NO_KILL_BRICKS_TOGGLE"] = false;
		["BAG_ESP_TOGGLE"] = false;
		["WALK_SPEED_TOGGLE"] = false;
		["JUMP_POWER_TOGGLE"] = false;
		["IGNORE_VIRIBUS_TOGGLE"] = false;
		["SHOW_HEALTH_TOGGLE"] = false;
		["NO_STUN_TOGGLE"] = false;

		["FLIGHT_SPEED"] = 10;
		["PLAYER_ESP_TEXT_SIZE"] = 13;
		["PLAYER_ESP_TEXT_FONT"] = 3;
		["TRINKET_ESP_TEXT_SIZE"] = 13;
		["TRINKET_ESP_TEXT_FONT"] = 3;
		["BAG_ESP_TEXT_SIZE"] = 13;
		["BAG_ESP_TEXT_FONT"] = 3;
		["WALK_SPEED_SPEED"] = 20;
		["JUMP_POWER_POWER"] = 45;

		["MENU_SIZE"] = "0, 500, 0, 500";
		["CHAT_LOGGER_SIZE"] = "0, 500, 0, 300";

		["MENU_COLOR"] = {0, 0, 0};
		["PLAYER_ESP_COLOR"] = {255, 255, 255};
		["TRINKET_ESP_TRINKET_COLOR"] = {255, 255, 255};
		["TRINKET_ESP_ARTIFACT_COLOR"] = {255, 0, 0};
		["BAG_ESP_COLOR"] = {255, 255, 255};

		["FLIGHT_KEYBIND"] = "T";
		["NOCLIP_KEYBIND"] = "T";
		["MENU_KEYBIND"] = "Insert";
		["WALK_SPEED_KEYBIND"] = "Z";
		["JUMP_POWER_KEYBIND"] = "X";
	}

	local LIBRARY = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/splix"))()
	local CHAT_LOGGER_LIBRARY = loadstring(game:HttpGet("https://raw.githubusercontent.com/aercvz/Opium/main/ChatLogger"))()

	local WINDOW = LIBRARY:new({
		size = string.split(CONFIG.MENU_SIZE:gsub("%p", ""), " ");
		textsize = 13.5;
		font = Enum.Font.RobotoMono;
		name = "opium.cc";
		color = Color3.fromRGB(table.unpack(CONFIG.MENU_COLOR));
		key = Enum.KeyCode[CONFIG.MENU_KEYBIND]
	})
	local CHAT_LOGGER_WINDOW = CHAT_LOGGER_LIBRARY:new({
		size = string.split(CONFIG.CHAT_LOGGER_SIZE:gsub("%p", ""), " ");
		textsize = 13.5;
		font = Enum.Font.RobotoMono;
		name = "Chat Logger";
		color = Color3.fromRGB(table.unpack(CONFIG.MENU_COLOR))
	})


	local PLAYER_TAB = WINDOW:page({
		name = "PLAYER";
	})
	local COMBAT_TAB = WINDOW:page({
		name = "COMBAT";
	})
	local VISUAL_TAB = WINDOW:page({
		name = "VISUAL";
	})
	local WORLD_TAB = WINDOW:page({
		name = "WORLD";
	})
	local MOVEMENT_TAB = WINDOW:page({
		name = "MOVEMENT";
	})
	local MISC_TAB = WINDOW:page({
		name = "MISC";
	})
	local BOTS_TAB = WINDOW:page({
		name = "BOTS";
	})
	local KEYBIND_TAB = WINDOW:page({
		name = "KEYBINDS";
	})
	local SETTINGS_TAB = WINDOW:page({
		name = "SETTINGS";
	})

	local MAIN_PLAYER_TAB = PLAYER_TAB:section({
		name = "";
		side = "left";
		size = 160;
	})
	local KNOCKED_CHARACTER_OWNERSHIP_TOGGLE = MAIN_PLAYER_TAB:toggle({
		name = "Knocked Character Ownership";
		flag = "KNOCKED_CHARACTER_OWNERSHIP_TOGGLE";
		def = CONFIG.KNOCKED_CHARACTER_OWNERSHIP_TOGGLE;
	})
	local NO_FALL_DAMAGE_TOGGLE = MAIN_PLAYER_TAB:toggle({
		name = "No Fall Damage";
		flag = "NO_FALL_DAMAGE_TOGGLE";
		def = CONFIG.NO_FALL_DAMAGE_TOGGLE;
	})
	local CHAT_LOGGER_TOGGLE = MAIN_PLAYER_TAB:toggle({
		name = "Chat Logger";
		flag = "CHAT_LOGGER_TOGGLE";
		def = CONFIG.CHAT_LOGGER_TOGGLE;
	})
	--[[local KNOCK_SELF_BUTTON = MAIN_PLAYER_TAB:button({
		name = "Knock Self";
		callback = function()
			xpcall(function()
				if CHARACTER and FALL_DAMAGE_REMOTE and FALL_DAMAGE_REMOTE:IsDescendantOf(CHARACTER) then
					FALL_DAMAGE_REMOTE:FireServer(1)
				end
			end, print)
		end,
	})]]
	local LOOP_ORDERLY_BUTTON = MAIN_PLAYER_TAB:button({
		name = "Loop Orderly Gain";
		callback = function()
			xpcall(function()
				if not PLAYER.Backpack:FindFirstChild("Tespian Elixir") then
					WINDOW:notify("must have a tespian in inventory", 5)
					return
				end
				
				WINDOW:notify("press F to stop", 5)
				task.spawn(function()
					while not USER_INPUT:IsKeyDown(Enum.KeyCode.F) do
						task.wait()
						if CHARACTER and HUMANOID and HUMANOID.Health > 0 then
							local TESPIAN = PLAYER.Backpack:FindFirstChild("Tespian Elixir")
							if TESPIAN then
								TESPIAN.Parent = CHARACTER
								task.wait()
								VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(850, 655, 0, true, game, 0)
								task.wait()
								VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(850, 655, 0, false, game, 0)
								task.wait(0.75)
								CHARACTER:BreakJoints()
							end
						end
					end
				end)
			end, print)
		end,
	})
	local RESET_BUTTON = MAIN_PLAYER_TAB:button({
		name = "Reset";
		callback = function()
			xpcall(function()
				if CHARACTER then
					CHARACTER:BreakJoints()
				end
			end, print)
		end,
	})
	local SERVERHOP_BUTTON = MAIN_PLAYER_TAB:button({
		name = "Server Hop";
		callback = function()
			xpcall(function()
				xpcall(SERVER_HOP, print)
				--[[local RANDOM_PLAYER = PLAYERS:GetPlayers()[math.random(1, #PLAYERS:GetPlayers())]
				STARTER_GUI:SetCore("PromptBlockPlayer", RANDOM_PLAYER)
				task.delay(0.25, function()
					VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(850, 655, 0, true, game, 0)
					task.wait()
					VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(850, 655, 0, false, game, 0)
					task.wait(0.25)
					PLAYER:Kick("[opium.cc] Server Hopping...")
					task.spawn(function()
						while task.wait(1.5) do
							TELEPORT_SERVICE:Teleport(3016661674, PLAYER)
						end
					end)
				end)]]
			end, print)
		end,
	})

	local PLAYER_ESP_TAB = VISUAL_TAB:section({
		name = "PLAYER ESP";
		side = "left";
		size = 150;
	})
	local PLAYER_ESP_TOGGLE = PLAYER_ESP_TAB:toggle({
		name = "Enabled";
		flag = "PLAYER_ESP_TOGGLE";
		def = CONFIG.PLAYER_ESP_TOGGLE;
	})
	local PLAYER_ESP_TEXT_SIZE = PLAYER_ESP_TAB:slider({
		name = "Text Size";
		flag = "PLAYER_ESP_TEXT_SIZE";
		def = CONFIG.PLAYER_ESP_TEXT_SIZE;
		min = 0; max = 20;
		rounding = true;
	})
	local PLAYER_ESP_TEXT_FONT = PLAYER_ESP_TAB:slider({
		name = "Text Font";
		flag = "PLAYER_ESP_TEXT_FONT";
		def = CONFIG.PLAYER_ESP_TEXT_FONT;
		min = 0; max = 3;
		rounding = true;
	})
	local PLAYER_ESP_COLOR = PLAYER_ESP_TAB:colorpicker({
		name = "Color";
		flag = "PLAYER_ESP_COLOR";
		def = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_COLOR));
		cpname = nil;
	})

	local MAIN_COMBAT_TAB = COMBAT_TAB:section({
		name = "";
		side = "left";
		size = 150;
	})
	local PERFLORA_TELEPORT_TOGGLE = MAIN_COMBAT_TAB:toggle({
		name = "Perflora Teleport";
		flag = "PERFLORA_TELEPORT_TOGGLE";
		def = CONFIG.PERFLORA_TELEPORT_TOGGLE;
	})
	local IGNORE_VIRIBUS_TOGGLE = MAIN_COMBAT_TAB:toggle({
		name = "Ignore Viribus";
		flag = "IGNORE_VIRIBUS_TOGGLE";
		def = CONFIG.IGNORE_VIRIBUS_TOGGLE;
	})
	local NO_STUN_TOGGLE = MAIN_COMBAT_TAB:toggle({
		name = "No Stun";
		flag = "NO_STUN_TOGGLE";
		def = CONFIG.NO_STUN_TOGGLE;
	})
	--[[local SHOW_HEALTH_TOGGLE = MAIN_COMBAT_TAB:toggle({
		name = "Show Health";
		flag = "SHOW_HEALTH_TOGGLE";
		def = CONFIG.SHOW_HEALTH_TOGGLE;
	})]]


	local TRINKET_ESP_TAB = VISUAL_TAB:section({
		name = "TRINKET ESP";
		side = "right";
		size = 150;
	})
	local TRINKET_ESP_TOGGLE = TRINKET_ESP_TAB:toggle({
		name = "Enabled";
		flag = "TRINKET_ESP_TOGGLE";
		def = CONFIG.TRINKET_ESP_TOGGLE;
	})
	local TRINKET_ESP_TEXT_SIZE = TRINKET_ESP_TAB:slider({
		name = "Text Size";
		flag = "TRINKET_ESP_TEXT_SIZE";
		def = CONFIG.TRINKET_ESP_TEXT_SIZE;
		min = 0; max = 20;
		rounding = true;
	})
	local TRINKET_ESP_TEXT_FONT = TRINKET_ESP_TAB:slider({
		name = "Text Font";
		flag = "TRINKET_ESP_TEXT_FONT";
		def = CONFIG.TRINKET_ESP_TEXT_FONT;
		min = 0; max = 3;
		rounding = true;
	})
	local TRINKET_ESP_TRINKET_COLOR = TRINKET_ESP_TAB:colorpicker({
		name = "Trinket Color";
		flag = "TRINKET_ESP_TRINKET_COLOR";
		def = Color3.fromRGB(table.unpack(CONFIG.TRINKET_ESP_TRINKET_COLOR));
		cpname = nil;
	})
	local TRINKET_ESP_ARTIFACT_COLOR = TRINKET_ESP_TAB:colorpicker({
		name = "Artifact Color";
		flag = "TRINKET_ESP_ARTIFACT_COLOR";
		def = Color3.fromRGB(table.unpack(CONFIG.TRINKET_ESP_ARTIFACT_COLOR));
		cpname = nil;
	})

	local BAG_ESP_TAB = VISUAL_TAB:section({
		name = "BAG ESP";
		side = "left";
		size = 150;
	})
	local BAG_ESP_TOGGLE = BAG_ESP_TAB:toggle({
		name = "Enabled";
		flag = "BAG_ESP_TOGGLE";
		def = CONFIG.BAG_ESP_TOGGLE;
	})
	local BAG_ESP_TEXT_SIZE = BAG_ESP_TAB:slider({
		name = "Text Size";
		flag = "BAG_ESP_TEXT_SIZE";
		def = CONFIG.BAG_ESP_TEXT_SIZE;
		min = 0; max = 20;
		rounding = true;
	})
	local BAG_ESP_TEXT_FONT = BAG_ESP_TAB:slider({
		name = "Text Font";
		flag = "BAG_ESP_TEXT_FONT";
		def = CONFIG.BAG_ESP_TEXT_FONT;
		min = 0; max = 3;
		rounding = true;
	})
	local BAG_ESP_COLOR = BAG_ESP_TAB:colorpicker({
		name = "Color";
		flag = "BAG_ESP_COLOR";
		def = Color3.fromRGB(table.unpack(CONFIG.BAG_ESP_COLOR));
		cpname = nil;
	})

	local MAIN_WORLD_TAB = WORLD_TAB:section({
		name = "";
		side = "left";
		size = 175;
	})

	local FULL_BRIGHT_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "Full Bright";
		flag = "FULL_BRIGHT_TOGGLE";
		def = CONFIG.FULL_BRIGHT_TOGGLE;
	})
	local NO_FOG_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "No Fog";
		flag = "NO_FOG_TOGGLE";
		def = CONFIG.NO_FOG_TOGGLE;
	})

	local NO_KILL_BRICKS_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "No Kill Bricks";
		flag = "NO_KILL_BRICKS_TOGGLE";
		def = CONFIG.NO_KILL_BRICKS_TOGGLE;
	})
	local AUTO_TRINKET_PICKUP_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "Auto Trinket Pickup";
		flag = "AUTO_TRINKET_PICKUP_TOGGLE";
		def = CONFIG.AUTO_TRINKET_PICKUP_TOGGLE;
	})
	local AUTO_INGREDIENT_PICKUP_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "Auto Ingredient Pickup";
		flag = "AUTO_INGREDIENT_PICKUP_TOGGLE";
		def = CONFIG.AUTO_INGREDIENT_PICKUP_TOGGLE;
	})
	local AUTO_BAG_PICKUP_TOGGLE = MAIN_WORLD_TAB:toggle({
		name = "Auto Bag Pickup";
		flag = "AUTO_BAG_PICKUP_TOGGLE";
		def = CONFIG.AUTO_BAG_PICKUP_TOGGLE;
	})
	local NOTIFY_LAST_LOOTED = MAIN_WORLD_TAB:button({
		name = "Notify Last Looted";
		callback = function()
			xpcall(function()
				local CASTLE_ROCK_TIME = workspace.MonsterSpawns.Triggers.CastleRockSnake:FindFirstChild("LastSpawned")
				local SNAKE_TIME = workspace.MonsterSpawns.Triggers.MazeSnakes:FindFirstChild("LastSpawned")
				local SUNKEN_TIME = workspace.MonsterSpawns.Triggers.evileye1:FindFirstChild("LastSpawned")

				local CASTLE_ROCK = tostring(math.floor((os.time() - CASTLE_ROCK_TIME.Value) / 60))
				local TUNDRA_TWO = tostring(math.floor((os.time() - SNAKE_TIME.Value) / 60))
				local SUNKEN = tostring(math.floor((os.time() - SUNKEN_TIME.Value) / 60))

				WINDOW:notify(string.format("CASTLE ROCK: %s MINUTES AGO;\nTUNDRA TWO: %s MINUTES AGO;\nSUNKEN: %s MINUTES AGO.", CASTLE_ROCK, TUNDRA_TWO, SUNKEN), 5)
			end, print)
		end;
	})

	local MAIN_MOVEMENT_TAB = MOVEMENT_TAB:section({
		name = "";
		side = "left";
		size = 200;
	})
	local FLIGHT_TOGGLE = MAIN_MOVEMENT_TAB:toggle({
		name = "Flight";
		flag = "FLIGHT_TOGGLE";
		def = CONFIG.FLIGHT_TOGGLE;
	})
	local NOCLIP_TOGGLE = MAIN_MOVEMENT_TAB:toggle({
		name = "NoClip";
		flag = "NOCLIP_TOGGLE";
		def = CONFIG.NOCLIP_TOGGLE;
	})
	local FLIGHT_SPEED = MAIN_MOVEMENT_TAB:slider({
		name = "Flight Speed";
		flag = "FLIGHT_SPEED";
		def = CONFIG.FLIGHT_SPEED;
		min = 0; max = 300;
		rounding = true;
	})
	local WALK_SPEED_TOGGLE = MAIN_MOVEMENT_TAB:toggle({
		name = "Modify Walk Speed";
		flag = "WALK_SPEED_TOGGLE";
		def = CONFIG.WALK_SPEED_TOGGLE;
	})
	local JUMP_POWER_TOGGLE = MAIN_MOVEMENT_TAB:toggle({
		name = "Modify Jump Power";
		flag = "JUMP_POWER_TOGGLE";
		def = CONFIG.JUMP_POWER_TOGGLE;
	})
	local WALK_SPEED_SPEED = MAIN_MOVEMENT_TAB:slider({
		name = "Walk Speed";
		flag = "WALK_SPEED_SPEED";
		def = CONFIG.WALK_SPEED_SPEED;
		min = 0; max = 300;
		rounding = true;
	})
	local JUMP_POWER_POWER = MAIN_MOVEMENT_TAB:slider({
		name = "Jump Power";
		flag = "JUMP_POWER_POWER";
		def = CONFIG.JUMP_POWER_POWER;
		min = 0; max = 300;
		rounding = true;
	})

	local MAIN_MISC_TAB = MISC_TAB:section({
		name = "";
		side = "left";
		size = 150;
	})
	local BYPASS_AA_GUN_BUTTON = MAIN_MISC_TAB:button({
		name = "Bypass AA Gun";
		callback = function()
			xpcall(function()
				if CHARACTER and SET_NPC and workspace.NPCs and workspace.NPCs:FindFirstChild("The Eagle") then
					local NPC = workspace.NPCs:FindFirstChild("The Eagle")
					local NPC_ROOT = NPC:FindFirstChild("HumanoidRootPart")

					task.spawn(function()
						xpcall(function()
							local NO_CLIPPED = {}
							local TIME = 0

							while TIME < 0.5 do
								HUMANOID.JumpPower = 0
								HUMANOID:ChangeState(Enum.HumanoidStateType.Jumping)
								HUMANOID.JumpPower = 0
								for _, PART in pairs(workspace:GetPartsInPart(ROOT)) do
									if NO_CLIPPED[PART] or (not PART:IsDescendantOf(CHARACTER) and PART.CanCollide) then
										NO_CLIPPED[PART] = tick()
										PART.CanCollide = false
									end
								end

								LOCK_ROOT_VELOCITY = true
								CHARACTER:PivotTo(NPC_ROOT.CFrame * CFrame.new(0, 0, -6))
								TWEEN_SERVICE:Create(CAMERA, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
									CFrame = CFrame.lookAt(CAMERA.CFrame.Position, NPC_ROOT.Position)
								}):Play()
								fireclickdetector(NPC:FindFirstChildOfClass("ClickDetector"))
								TIME = TIME + task.wait()
							end
							LOCK_ROOT_VELOCITY = false
							for PART, _ in pairs(NO_CLIPPED) do
								ROOT.Velocity = Vector3.new()
								PART.CanCollide = true
							end
							table.clear(NO_CLIPPED)
						end, print)
					end)
				end
			end, print)
		end,
	})

	local AUTO_CRAFT_POTION_TAB = MISC_TAB:section({
		name = "Automation";
		side = "right";
		size = 150;
	})
	local AUTO_TRAIN_SNAP_BUTTON = AUTO_CRAFT_POTION_TAB:button({
		name = "Train Snap";
		callback = function()
			xpcall(function()
				if CHARACTER then
					local TOOL = CHARACTER:FindFirstChildWhichIsA("Tool")
					if TOOL and TOOL:FindFirstChild("Spell") then
						local TRAIN_CONNECTION; TRAIN_CONNECTION = RUN_SERVICE.RenderStepped:Connect(function()
							xpcall(function()
								if TOOL.Parent ~= CHARACTER then
									TRAIN_CONNECTION:Disconnect()
									TRAIN_CONNECTION = nil
									return
								end
								local ACTIVATOR = TOOL:FindFirstChildWhichIsA("ModuleScript")
								if ACTIVATOR then
									ACTIVATOR = require(ACTIVATOR)
									local LEAST_MANA_REQUIREMENT = ACTIVATOR.lowerbound
									local MANA_VALUE = CHARACTER:FindFirstChild("Mana") and CHARACTER.Mana.Value or 0
									if MANA_VALUE <= LEAST_MANA_REQUIREMENT then
										VIRTUAL_INPUT_MANAGER:SendKeyEvent(true, Enum.KeyCode.G, false, game)
									else
										VIRTUAL_INPUT_MANAGER:SendKeyEvent(false, Enum.KeyCode.G, false, game)
										task.wait()
										VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(0, 0, 0, true, game, 0)
										task.wait()
										VIRTUAL_INPUT_MANAGER:SendMouseButtonEvent(0, 0, 0, false, game, 0)
										task.wait()
										TOOL.Parent = PLAYER.Backpack
										task.wait(0.2)
										TOOL.Parent = CHAT_LOGGER_TOGGLE
									end
								end

							end, print)
						end)
					end
				end
			end, print)
		end;
	})

	local TRINKET_BOT_TAB = BOTS_TAB:section({
		name = "Trinket Bot";
		side = "left";
		size = 455;
	})
	local TRINKET_BOT_VISUALIZE_CACHE = {}
	local TRINKET_BOT_CREATE_POINT = TRINKET_BOT_TAB:button({
		name = "Create Point";
		callback = function()
			xpcall(function()
				local CFRAME_POINT = CHARACTER:GetPivot()
				CURRENT_CFRAME_POINTS["POINTS"][#CURRENT_CFRAME_POINTS["POINTS"] + 1] = {
					["TYPE"] = "NORMAL";
					["POINT"] = {CFRAME_POINT.X, CFRAME_POINT.Y, CFRAME_POINT.Z};
				}
			end, print)
		end;
	})
	local TRINKET_BOT_SET_POINT_TO_WAIT_FOR_TRINKET = TRINKET_BOT_TAB:button({
		name = "Set Wait For Trinket";
		callback = function()
			xpcall(function()
				local POINT = CURRENT_CFRAME_POINTS["POINTS"][#CURRENT_CFRAME_POINTS["POINTS"]]
				POINT.TYPE = "TRINKET_WAIT"
			end, print)
		end;
	})
	local TRINKET_BOT_SET_WAIT_POINT = TRINKET_BOT_TAB:button({
		name = "Set Wait";
		callback = function()
			xpcall(function()
				local POINT = CURRENT_CFRAME_POINTS["POINTS"][#CURRENT_CFRAME_POINTS["POINTS"]]
				POINT.TYPE = "WAIT"
				POINT.VALUE = SET_WAIT_VALUE
			end, print)
		end;
	})
	local TRINKET_BOT_WAIT_TIME = TRINKET_BOT_TAB:slider({
		name = "Wait Time";
		flag = "WAIT_TIME";
		def = SET_WAIT_VALUE;
		min = 0; max = 100;
		rounding = true;
		callback = function(value)
			SET_WAIT_VALUE = value;
		end,
	})
	local TRINKET_BOT_UNDO_POINT = TRINKET_BOT_TAB:button({
		name = "Undo Point";
		callback = function()
			xpcall(function()
				CURRENT_CFRAME_POINTS["POINTS"][#CURRENT_CFRAME_POINTS["POINTS"]] = nil
			end, print)
		end;
	})
	local TRINKET_BOT_CLEAR_POINTS = TRINKET_BOT_TAB:button({
		name = "Clear Points";
		callback = function()
			xpcall(function()
				table.clear(CURRENT_CFRAME_POINTS["POINTS"])
			end, print)
		end;
	})
	local TRINKET_BOT_VISUALIZE_POINTS = TRINKET_BOT_TAB:button({
		name = "Visualze Points";
		callback = function()
			xpcall(function()
				for INDEX, POINT in pairs(TRINKET_BOT_VISUALIZE_CACHE) do
					task.wait()
					xpcall(function()
						POINT:Destroy()
						TRINKET_BOT_VISUALIZE_CACHE[INDEX] = nil
					end, print)
				end

				for INDEX, POINT_DATA in pairs(CURRENT_CFRAME_POINTS["POINTS"]) do
					task.wait()
					xpcall(function()
						local CFRAME = Vector3.new(POINT_DATA.POINT[1], POINT_DATA.POINT[2], POINT_DATA.POINT[3])
						local POINT = Instance.new("Part")
						POINT.Anchored = true
						POINT.Size = Vector3.one
						POINT.CanCollide = false
						POINT.Transparency = 0.7
						POINT.Material = Enum.Material.Neon
						POINT.Color = POINT_DATA.TYPE == "NORMAL" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 255, 0)
						POINT.Name = crypt.hash(tostring(math.random(69, 420)), "md5")
						POINT.Position = CFRAME
						POINT.Parent = CAMERA
						table.insert(TRINKET_BOT_VISUALIZE_CACHE, POINT)

						if CURRENT_CFRAME_POINTS["POINTS"][INDEX + 1] ~= nil then
							local COMING_CFRAME = CURRENT_CFRAME_POINTS["POINTS"][INDEX + 1]
							local TO_LINK = Vector3.new(COMING_CFRAME.POINT[1], COMING_CFRAME.POINT[2], COMING_CFRAME.POINT[3])
							local LINK = Instance.new("Part")
							LINK.Anchored = true
							LINK.CanCollide = false
							LINK.Name = crypt.hash(tostring(math.random(69, 420)), "md5")
							LINK.Size = Vector3.new(0.1, 0.1, (CFRAME - TO_LINK).Magnitude)
							LINK.CFrame = CFrame.lookAt(CFRAME, TO_LINK) * CFrame.new(0, 0, -LINK.Size.Z/2)
							LINK.Material = Enum.Material.Neon
							LINK.Color = Color3.fromRGB(255, 255, 255)
							LINK.Transparency = 0.7
							LINK.Parent = CAMERA
							table.insert(TRINKET_BOT_VISUALIZE_CACHE, LINK)
						end
					end, print)
				end
			end, print)
		end;
	})
	local TRINKET_BOT_PICK_UP_SCROLLS_TOGGLE = TRINKET_BOT_TAB:toggle({
		name = "Pick Up Scrolls";
		flag = "PICK_UP_SCROLLS";
		def = CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"];
		callback = function(value)
			CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"] = value;
		end;
	})
	local TRINKET_BOT_ILLUSIONIST_DETECT_TOGGLE = TRINKET_BOT_TAB:toggle({
		name = "Illusionist Detect";
		flag = "ILLUSIONIST_DETECT";
		def = CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"];
		callback = function(value)
			CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"] = value;
		end;
	})
	local TRINKET_BOT_SPEED = TRINKET_BOT_TAB:slider({
		name = "Speed";
		flag = "SPEED";
		def = CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"];
		min = 0; max = 300;
		rounding = true;
		callback = function(value)
			CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"] = value;
		end,
	})
	local TRINKET_BOT_WEBHOOK_NAME_BOX = TRINKET_BOT_TAB:textbox({
		name = "Webhook";
		def = CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"];
		placeholder = CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"];
		callback = function(value)
			CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] = value;
		end;
	})
	local TRINKET_BOT_WEBHOOK_TEST_BUTTON = TRINKET_BOT_TAB:button({
		name = "Test Webhook";
		callback = function()
			xpcall(function()
				if CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] and CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] ~= "" and string.find(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"], "webhook") then
					SEND_WEBHOOK(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"], {
						["content"] = "webhook test";
						["username"] = "destroy lonely";
					})
				end
			end, print)
		end;
	})
	local TRINKET_BOT_PATH_NAME_BOX = TRINKET_BOT_TAB:textbox({
		name = "Path Name";
		def = SET_TRINKET_BOT_PATH;
		placeholder = SET_TRINKET_BOT_PATH;
		callback = function(value)
			SET_TRINKET_BOT_PATH = value;
		end;
	})
	local TRINKET_BOT_SAVE_PATH_BUTTON = TRINKET_BOT_TAB:button({
		name = "Save Path";
		callback = function()
			xpcall(function()
				writefile(string.format("opium/paths/%s", SET_TRINKET_BOT_PATH), HTTP_SERVICE:JSONEncode(CURRENT_CFRAME_POINTS))
				WINDOW:notify(string.format("saved path %s", tostring(SET_TRINKET_BOT_PATH)), 5)
			end, print)
		end;
	})
	local TRINKET_BOT_LOAD_PATH_BUTTON = TRINKET_BOT_TAB:button({
		name = "Load Path";
		callback = function()
			xpcall(function()
				local DECODED_JSON = HTTP_SERVICE:JSONDecode(readfile(string.format("opium/paths/%s", SET_TRINKET_BOT_PATH)))
				if not DECODED_JSON.POINTS then
					CURRENT_CFRAME_POINTS["POINTS"] = DECODED_JSON
				else
					CURRENT_CFRAME_POINTS = DECODED_JSON
				end

				TRINKET_BOT_ILLUSIONIST_DETECT_TOGGLE:set(CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"])
				TRINKET_BOT_PICK_UP_SCROLLS_TOGGLE:set(CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"])
				TRINKET_BOT_SPEED:set(CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"])
				TRINKET_BOT_WEBHOOK_NAME_BOX:set(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"])
				WINDOW:notify(string.format("loaded path %s", tostring(SET_TRINKET_BOT_PATH)), 5)
			end, print)
		end;
	})
	function SERVER_HOP()
		xpcall(function()
			local FOUND_ARTI = false
			for _, TRINKET in pairs(workspace:GetChildren()) do
				if TRINKET:FindFirstChild("ID") and table.find(ARTIFACT_NAMES, tostring(TRINKET)) then
					FOUND_ARTI = true
					return
				end
			end
			if BOT_RUNNING and FOUND_ARTI then
				return
			end
			if CHARACTER then
				REQUESTS:WaitForChild("ReturnToMenu"):InvokeServer()
			end
			while task.wait(0.75) do
				local SERVERS = CLIENT_STORAGE:WaitForChild("ServerInfo"):GetChildren()
				local RANDOM_SERVER = SERVERS[math.random(1, #SERVERS)]
				REQUESTS:WaitForChild("JoinPublicServer"):FireServer(tostring(RANDOM_SERVER))
			end
		end, print)
	end
	local function STOP_PATH()
		xpcall(function()
			if pcall(function() readfile(string.format("opium/paths/loaded/%s", tostring(PLAYER))) end) then
				delfile(string.format("opium/paths/loaded/%s", tostring(PLAYER)))
			end
		end, print)
	end
	local function START_PATH()
		xpcall(function()
			local START_POINT = CURRENT_CFRAME_POINTS["POINTS"][1]
			if START_POINT then
				if not CHARACTER or not ROOT then
					repeat task.wait() until CHARACTER and ROOT
					repeat task.wait() until (ROOT.Position - Vector3.new(START_POINT.POINT[1], START_POINT.POINT[2], START_POINT.POINT[3])).Magnitude < 40
					task.wait(1.2)
				end
				task.wait(0.6)
				if (ROOT.Position - Vector3.new(START_POINT.POINT[1], START_POINT.POINT[2], START_POINT.POINT[3])).Magnitude > 150 then
					WINDOW:notify("not near start point", 5)
					return
				end
				setfpscap(30)
				BOT_RUNNING = true
				if not pcall(function() readfile(string.format("opium/paths/loaded/%s", tostring(PLAYER))) end) then
					writefile(string.format("opium/paths/loaded/%s", tostring(PLAYER)), HTTP_SERVICE:JSONEncode({["PATH"] = SET_TRINKET_BOT_PATH}))
				end
				for _, PLR in pairs(PLAYERS:GetPlayers()) do
					if PLR ~= PLAYER and PLR.Character then
						if (ROOT.Position - PLR.Character.PrimaryPart.Position).Magnitude < 250 then
							xpcall(function()
								if CHARACTER:FindFirstChild("Danger") then
									repeat task.wait() until not CHARACTER:FindFirstChild("Danger")
								end
								xpcall(SERVER_HOP, print)
							end, print)
							return
						end
					end
				end
				for INDEX, POINT_DATA in pairs(CURRENT_CFRAME_POINTS["POINTS"]) do
					task.wait()
					if not BOT_RUNNING then
						break
					end
					xpcall(function()
						local POINT = Vector3.new(POINT_DATA.POINT[1], POINT_DATA.POINT[2], POINT_DATA.POINT[3])
						local MAGNITUDE = (ROOT.Position - POINT).Magnitude
						local SPEED = CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"] or 100
						local TELEPORT = TWEEN_SERVICE:Create(ROOT, TweenInfo.new(MAGNITUDE/SPEED, Enum.EasingStyle.Linear), {
							CFrame = CFrame.new(POINT)
						})
						local NOCLIP_CONNECTION; NOCLIP_CONNECTION = RUN_SERVICE.RenderStepped:Connect(function()
							HUMANOID:ChangeState(Enum.HumanoidStateType.Jumping)
							local OVERLAP_PARAMS = OverlapParams.new()
							OVERLAP_PARAMS.FilterType = Enum.RaycastFilterType.Exclude
							OVERLAP_PARAMS.FilterDescendantsInstances = {CAMERA, workspace.Live, workspace.Thrown}
							local PARTS = workspace:GetPartBoundsInBox(ROOT.CFrame, Vector3.new(5, 5, 5), OVERLAP_PARAMS)
							for _, PART in pairs(PARTS) do
								if NOCLIPPED_PARTS[PART] or (not PART:IsDescendantOf(CHARACTER) and PART.CanCollide) then
									NOCLIPPED_PARTS[PART] = tick()
									PART.CanCollide = false
								end
							end
						end)
						TELEPORT:Play()
						TELEPORT.Completed:Wait()
						NOCLIP_CONNECTION:Disconnect()
						for _, TRINKET in pairs(workspace:GetChildren()) do
							if TRINKET:FindFirstChild("ID") then
								local MAGNITUDE = (ROOT.Position - TRINKET.Part.Position).magnitude
								if MAGNITUDE <= 30 then
									local INSTANCE, POSITION = workspace:FindPartOnRayWithIgnoreList(Ray.new(ROOT.Position, (ROOT.Position - TRINKET.Position).Unit), {CHARACTER, CAMERA, workspace.Thrown, workspace.Live})
									if INSTANCE then
										continue
									end
									if not CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"] and (GET_TRINKET_TYPE(TRINKET) == "Scroll" or GET_TRINKET_TYPE(TRINKET) == "Ice Essence") then
										continue
									end
									local TELEPORT = TWEEN_SERVICE:Create(ROOT, TweenInfo.new(MAGNITUDE/CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"], Enum.EasingStyle.Linear), {
										CFrame = TRINKET.CFrame
									})
									TWEEN_PLAYING = TELEPORT
									TELEPORT:Play()
									TELEPORT.Completed:Wait()
									fireclickdetector(TRINKET.Part.ClickDetector)
								end
							end
						end
						if POINT_DATA.TYPE == "TRINKET_WAIT" then
							task.wait(7)
						end
						if POINT_DATA.TYPE == "WAIT" then
							task.wait(POINT_DATA.VALUE)
						end
					end, print)
				end
				xpcall(function()
					if CHARACTER:FindFirstChild("Danger") then
						repeat task.wait() until not CHARACTER:FindFirstChild("Danger")
					end
					for _, TRINKET in pairs(workspace:GetChildren()) do
						if TRINKET:FindFirstChild("ID") and table.find(ARTIFACT_NAMES, tostring(TRINKET)) then
							BOT_RUNNING = false
							return
						end
					end
					if BOT_RUNNING then
						xpcall(SERVER_HOP, print)
						BOT_RUNNING = false
					end
				end, print)
			end
		end, print)
	end
	local TRINKET_BOT_START_PATH_BUTTON = TRINKET_BOT_TAB:button({
		name = "Start Path";
		callback = function()
			START_PATH();
		end;
	})

	local MAIN_KEYBIND_TAB = KEYBIND_TAB:section({
		name = "";
		side = "left";
		size = 150;
	})
	local FLIGHT_KEYBIND = MAIN_KEYBIND_TAB:keybind({
		name = "Flight";
		flag = "FLIGHT_KEYBIND";
		def = CONFIG.FLIGHT_KEYBIND;
		callback = function(value)
			CONFIG.FLIGHT_KEYBIND = value.Name;
		end;
	})
	local NOCLIP_KEYBIND = MAIN_KEYBIND_TAB:keybind({
		name = "NoClip";
		flag = "NOCLIP_KEYBIND";
		def = CONFIG.NOCLIP_KEYBIND;
		callback = function(value)
			CONFIG.NOCLIP_KEYBIND = value.Name;
		end;
	})
	local MENU_KEYBIND = MAIN_KEYBIND_TAB:keybind({
		name = "Menu";
		flag = "MENU_KEYBIND";
		def = CONFIG.MENU_KEYBIND;
		callback = function(value)
			CONFIG.MENU_KEYBIND = value.Name;
			WINDOW.key = value
		end;
	})
	local WALK_SPEED_KEYBIND = MAIN_KEYBIND_TAB:keybind({
		name = "Walk Speed";
		flag = "WALK_SPEED_KEYBIND";
		def = CONFIG.WALK_SPEED_KEYBIND;
		callback = function(value)
			CONFIG.WALK_SPEED_KEYBIND = value.Name;
		end;
	})
	local JUMP_POWER_KEYBIND = MAIN_KEYBIND_TAB:keybind({
		name = "Jump Power";
		flag = "JUMP_POWER_KEYBIND";
		def = CONFIG.JUMP_POWER_KEYBIND;
		callback = function(value)
			CONFIG.JUMP_POWER_KEYBIND = value.Name;
		end;
	})

	local CONFIGURATION_SETTINGS_TAB = SETTINGS_TAB:section({
		name = "Configuration";
		side = "left";
		size = 150;
	})
	local CONFIGURATION_NAME_BOX = CONFIGURATION_SETTINGS_TAB:textbox({
		name = "Configuration";
		def = SET_CONFIGURATION;
		placeholder = SET_CONFIGURATION;
		callback = function(value)
			SET_CONFIGURATION = value;
		end;
	})
	local SAVE_CONFIGURATION_BUTTON = CONFIGURATION_SETTINGS_TAB:button({
		name = "Save Configuration";
		callback = function()
			SAVE_CONFIG(SET_CONFIGURATION);
		end;
	})
	local LOAD_CONFIGURATION_BUTTON = CONFIGURATION_SETTINGS_TAB:button({
		name = "Load Configuration";
		callback = function()
			LOAD_CONFIG(SET_CONFIGURATION);
		end;
	})
	local MENU_COLOR = CONFIGURATION_SETTINGS_TAB:colorpicker({
		name = "Menu Color";
		flag = "MENU_COLOR";
		def = Color3.fromRGB(table.unpack(CONFIG.MENU_COLOR));
		cpname = nil;
	})





	--// logic

	local CONFIG_PATH = "opium/configs/%s/%s.opium"

	if not isfolder("opium") then
		makefolder("opium")
	end
	if not isfolder("opium/configs") then
		makefolder("opium/configs")
	end
	if not isfolder("opium/paths") then
		makefolder("opium/paths")
	end
	if not isfolder("opium/paths/loaded") then
		makefolder("opium/paths/loaded")
	end
	if not isfolder(string.format("opium/configs/%s", tostring(game.PlaceId))) then
		makefolder(string.format("opium/configs/%s", tostring(game.PlaceId)))
	end

	if not pcall(function() readfile(string.format(CONFIG_PATH, tostring(game.PlaceId), "default")) end) then
		writefile(string.format(CONFIG_PATH, tostring(game.PlaceId), "default"), HTTP_SERVICE:JSONEncode(CONFIG))
	end

	function LOAD_CONFIG(CONFIG_NAME)
		xpcall(function()
			local LOADED_CONFIG = HTTP_SERVICE:JSONDecode(readfile(string.format(CONFIG_PATH, tostring(game.PlaceId), CONFIG_NAME)))
			WINDOW:LOAD_CONFIG(LOADED_CONFIG)
		end, print)
	end
	function SAVE_CONFIG(CONFIG_NAME)
		xpcall(function()
			writefile(string.format(CONFIG_PATH, tostring(game.PlaceId), CONFIG_NAME), HTTP_SERVICE:JSONEncode(CONFIG))
		end, print)
	end

	--//

	local function GET_PLAYER_INGAME_NAME(TARGET_CHARACTER)
		for _, MODEL in pairs(TARGET_CHARACTER:GetChildren()) do
			if MODEL:IsA("Model") and MODEL:FindFirstChild("FakeHumanoid") then
				return tostring(MODEL)
			end
		end
		return "nil"
	end

	local function HANDLE_LABEL(TARGET, LABEL)
		local BUTTON = LABEL:FindFirstChildWhichIsA("TextButton")
		if not BUTTON then
			BUTTON = Instance.new("TextButton")
			BUTTON.Transparency = 1
			BUTTON.Text = ""
			BUTTON.Size = UDim2.fromScale(1, 1)
			BUTTON.Position = UDim2.new(0, 0, 0, 0)
			BUTTON.Parent = LABEL
		end

		BUTTON.MouseButton1Click:Connect(function()
			if SPECTATING == TARGET or TARGET == PLAYER and CHARACTER then
				SPECTATING = nil
				CAMERA.CameraSubject = HUMANOID
			else
				if TARGET.Character and TARGET.Character:FindFirstChildWhichIsA("Humanoid") then
					SPECTATING = TARGET
					CAMERA.CameraType = Enum.CameraType.Custom
					CAMERA.CameraSubject = TARGET.Character:FindFirstChildWhichIsA("Humanoid")
				end
			end
		end)
	end

	local function IN_TABLE(TABLE, VALUE)
		for KEY, VAL in pairs(TABLE) do
			if VAL == VALUE then
				return true
			end
		end
		return false
	end

	function SEND_WEBHOOK(URL, DATA)
		pcall(function()
			request({
				Url = URL;
				Method = "POST";
				Headers = {["content-type"] = "application/json"};
				Body = HTTP_SERVICE:JSONEncode(DATA);
			})
		end)
	end

	local function HANDLE_LEADERBOARD()
		task.spawn(function()
			xpcall(function()
				--[[if not PLAYER_GUI:FindFirstChild("LeaderboardGui") then
					repeat task.wait() until PLAYER_GUI:FindFirstChild("LeaderboardGui")
				end]]
				--// handle leaderboard
				for _, FUNCTION in next, getreg() do
					task.wait()
					if typeof(FUNCTION) == "function" then
						pcall(function()
							if getfenv(FUNCTION).script and getfenv(FUNCTION).script:GetFullName():find("LeaderboardClient") then
								for INDEX, UPVALUE in ipairs(debug.getupvalues(FUNCTION)) do
									task.wait()
									if typeof(UPVALUE) == "function" and IN_TABLE(debug.getconstants(UPVALUE), "HouseRank") then
										local ORIGINAL = debug.getupvalues(FUNCTION)[INDEX]
										local LABELS = {}

										for _, LABEL_DATA in pairs(debug.getupvalues(UPVALUE)) do
											task.wait()
											if typeof(LABEL_DATA) == "table" and LABEL_DATA[PLAYER] then
												LABELS = LABEL_DATA
												for TARGET, LABEL in pairs(LABEL_DATA) do
													HANDLE_LABEL(TARGET, LABEL)
												end
											end
										end

										debug.setupvalue(FUNCTION, INDEX, function(TARGET, ...)
											local LABEL = ORIGINAL(TARGET, ...)
											local CONSTANT = "HouseRank"
											local TABLE = LABELS

											HANDLE_LABEL(TARGET, LABEL)

											return LABEL
										end)
									end
								end
							end
						end)
					end
				end
				--//
			end, print)
		end)
	end

	local function REMOVE_COPYRIGHT()
		xpcall(function()
			if not PLAYER_GUI:FindFirstChild("LeaderboardGui") then
				CAMERA.CameraType = Enum.CameraType.Custom
				local NEW_LEADERBOARD = STARTER_GUI:FindFirstChild("LeaderboardGui"):Clone()
				NEW_LEADERBOARD.ResetOnSpawn = true
				NEW_LEADERBOARD.Parent = PLAYER_GUI
				--HANDLE_LEADERBOARD()
				if PLAYER_GUI:FindFirstChild("StartMenu") then
					PLAYER_GUI.StartMenu.CopyrightBar:Destroy()
				end
				xpcall(function()
					local LEADERBOARD_CONNECTION; LEADERBOARD_CONNECTION = PLAYER.CharacterAdded:Connect(function()
						NEW_LEADERBOARD:Destroy()
						LEADERBOARD_CONNECTION:Disconnect()
						HANDLE_LEADERBOARD()
					end)
				end, print)
			end
		end, print)
	end

	local function CHARACTER_ADDED()
		CHARACTER = PLAYER.Character
		if CHARACTER then
			ROOT = CHARACTER:WaitForChild("HumanoidRootPart")
			HUMANOID = CHARACTER:WaitForChild("Humanoid")
			BOOSTS = CHARACTER:WaitForChild("Boosts")
			HANDLE_LEADERBOARD()

			if CONFIG.WALK_SPEED_TOGGLE then
				local SPEED_BOOST = BOOSTS:FindFirstChild("SpeedBoost")
				if not SPEED_BOOST then
					SPEED_BOOST = Instance.new("NumberValue")
				end
				SPEED_BOOST.Name = "SpeedBoost"
				SPEED_BOOST.Value = CONFIG.WALK_SPEED_SPEED
				SPEED_BOOST.Parent = BOOSTS
			end
			
			NO_STUN_CONNECTION = CHARACTER.ChildAdded:Connect(function(STUN)
				xpcall(function()
					if not CONFIG.NO_STUN_TOGGLE then
						return
					end
					if table.find({"HeavyAttack"; "Action"; "LightAttack"; "Stun"; "NoJump"; "NoDam"; "Stun"; "Knocked"; "Unconscious"; "IsClimbing"; "BeingExecuted"; "Casting"; "NoDash"}, tostring(STUN)) then
						task.wait()
						STUN:Destroy()
					end
				end, print)
			end)

			local DIED_CONNECTION = HUMANOID.Died:Connect(function()
				xpcall(function()
					if BOT_RUNNING then
						PLAYER:Kick("[opium.cc] Bot died")
						return
					end
				end, print)
			end)
			local GOT_INVENTORY = PLAYER.Backpack.ChildAdded:Connect(function(ITEM)
				xpcall(function()
					if BOT_RUNNING and table.find(ARTIFACT_NAMES, tostring(ITEM)) then
						xpcall(STOP_PATH, print)
						xpcall(function()
							BOT_RUNNING = false
							SEND_WEBHOOK("https://discord.com/api/webhooks/"..ARTIFACT_STREAM_HOOK, {
								["embeds"] = {
									{
										["title"] = "ARTIFACT FOUND";
										["description"] = string.format("ARTIFACT: %s\n@here", tostring(ITEM));
										["color"] = tonumber(0x00000);
										["timestamp"] = DateTime.now():ToIsoDate()
									}
								}
							})
							PLAYER:Kick("[opium.cc] ARTIFACT FOUND")
						end, print)
					end
				end, print)
			end)
		end
	end
	local function CHARACTER_REMOVED()
		CHARACTER = nil; ROOT = nil; HUMANOID = nil; BOOSTS = nil
		
		xpcall(function()
			if NO_STUN_CONNECTION then
				NO_STUN_CONNECTION:Disconnect()
				NO_STUN_CONNECTION = nil
			end
		end, print)
		xpcall(function()
			REMOVE_COPYRIGHT()
		end, print)
	end
	CHARACTER_ADDED()
	PLAYER.CharacterAdded:Connect(CHARACTER_ADDED)
	PLAYER.CharacterRemoving:Connect(CHARACTER_REMOVED)

	FLIGHT_TOGGLE.callback = function(value)
		CONFIG.FLIGHT_TOGGLE = value;
	end
	FLIGHT_SPEED.callback = function(value)
		CONFIG.FLIGHT_SPEED = value;
	end
	NOCLIP_TOGGLE.callback = function(value)
		CONFIG.NOCLIP_TOGGLE = value;
	end
	NO_FALL_DAMAGE_TOGGLE.callback = function(value)
		CONFIG.NO_FALL_DAMAGE_TOGGLE = value;
	end
	CHAT_LOGGER_TOGGLE.callback = function(value)
		CONFIG.CHAT_LOGGER_TOGGLE = value;
	end
	PLAYER_ESP_TOGGLE.callback = function(value)
		CONFIG.PLAYER_ESP_TOGGLE = value;
	end
	PLAYER_ESP_TEXT_SIZE.callback = function(value)
		CONFIG.PLAYER_ESP_TEXT_SIZE = value;
	end
	PLAYER_ESP_TEXT_FONT.callback = function(value)
		CONFIG.PLAYER_ESP_TEXT_FONT = value;
	end
	PLAYER_ESP_COLOR.callback = function(value)
		CONFIG.PLAYER_ESP_COLOR = {
			math.floor(value.R * 255),
			math.floor(value.G * 255),
			math.floor(value.B * 255)
		};
	end
	TRINKET_ESP_TOGGLE.callback = function(value)
		CONFIG.TRINKET_ESP_TOGGLE = value;
	end
	TRINKET_ESP_TEXT_SIZE.callback = function(value)
		CONFIG.TRINKET_ESP_TEXT_SIZE = value;
	end
	TRINKET_ESP_TEXT_FONT.callback = function(value)
		CONFIG.TRINKET_ESP_TEXT_FONT = value;
	end
	TRINKET_ESP_TRINKET_COLOR.callback = function(value)
		CONFIG.TRINKET_ESP_TRINKET_COLOR = {
			math.floor(value.R * 255),
			math.floor(value.G * 255),
			math.floor(value.B * 255)
		};
	end
	TRINKET_ESP_ARTIFACT_COLOR.callback = function(value)
		CONFIG.TRINKET_ESP_ARTIFACT_COLOR = {
			math.floor(value.R * 255),
			math.floor(value.G * 255),
			math.floor(value.B * 255)
		};
	end
	AUTO_TRINKET_PICKUP_TOGGLE.callback = function(value)
		CONFIG.AUTO_TRINKET_PICKUP_TOGGLE = value;
	end
	AUTO_INGREDIENT_PICKUP_TOGGLE.callback = function(value)
		CONFIG.AUTO_INGREDIENT_PICKUP_TOGGLE = value;
	end
	KNOCKED_CHARACTER_OWNERSHIP_TOGGLE.callback = function(value)
		CONFIG.KNOCKED_CHARACTER_OWNERSHIP_TOGGLE = value;
	end
	AUTO_BAG_PICKUP_TOGGLE.callback = function(value)
		CONFIG.AUTO_BAG_PICKUP_TOGGLE = value;
	end
	PERFLORA_TELEPORT_TOGGLE.callback = function(value)
		CONFIG.PERFLORA_TELEPORT_TOGGLE = value;
	end
	NO_KILL_BRICKS_TOGGLE.callback = function(value)
		CONFIG.NO_KILL_BRICKS_TOGGLE = value;
		xpcall(function()
			if value then
				for _, KILL_BRICK in pairs(workspace.Map:GetChildren()) do
					local TOUCH = KILL_BRICK:FindFirstChildWhichIsA("TouchTransmitter")
					if TOUCH and table.find(KILL_BRICK_NAMES, tostring(KILL_BRICK)) then
						KILL_BRICK_CACHE[KILL_BRICK] = TOUCH
						TOUCH:Destroy()
					end
				end
			else
				for KILL_BRICK, TRANSMITTER in pairs(KILL_BRICK_CACHE) do
					if not KILL_BRICK:FindFirstChildWhichIsA("TouchTransmitter") and table.find(KILL_BRICK_NAMES, tostring(KILL_BRICK)) then
						TRANSMITTER.Parent = KILL_BRICK
					end
				end
			end
		end, print)
	end
	BAG_ESP_TOGGLE.callback = function(value)
		CONFIG.BAG_ESP_TOGGLE = value;
	end
	BAG_ESP_TEXT_SIZE.callback = function(value)
		CONFIG.BAG_ESP_TEXT_SIZE = value;
	end
	BAG_ESP_TEXT_FONT.callback = function(value)
		CONFIG.BAG_ESP_TEXT_FONT = value;
	end
	BAG_ESP_COLOR.callback = function(value)
		CONFIG.BAG_ESP_COLOR = {
			math.floor(value.R * 255),
			math.floor(value.G * 255),
			math.floor(value.B * 255)
		};
	end
	WALK_SPEED_TOGGLE.callback = function(value)
		CONFIG.WALK_SPEED_TOGGLE = value;

		xpcall(function()
			if CHARACTER and BOOSTS then
				if value then
					local SPEED_BOOST = BOOSTS:FindFirstChild("SpeedBoost")
					if not SPEED_BOOST then
						SPEED_BOOST = Instance.new("NumberValue")
					end
					SPEED_BOOST.Name = "SpeedBoost"
					SPEED_BOOST.Value = CONFIG.WALK_SPEED_SPEED
					SPEED_BOOST.Parent = BOOSTS
				else
					for _, BOOST in pairs(BOOSTS:GetChildren()) do
						if tostring(BOOST) == "SpeedBoost" and BOOST.Value == CONFIG.WALK_SPEED_SPEED then
							BOOST:Destroy()
						end
					end
				end
			end
		end, print)
	end
	WALK_SPEED_SPEED.callback = function(value)
		xpcall(function()
			if CHARACTER and BOOSTS then
				for _, BOOST in pairs(BOOSTS:GetChildren()) do
					if tostring(BOOST) == "SpeedBoost" and BOOST.Value == CONFIG.WALK_SPEED_SPEED then
						BOOST.Value = value
					end
				end
			end
		end, print)
		CONFIG.WALK_SPEED_SPEED = value;
	end
	JUMP_POWER_TOGGLE.callback = function(value)
		CONFIG.JUMP_POWER_TOGGLE = value;
	end
	JUMP_POWER_POWER.callback = function(value)
		CONFIG.JUMP_POWER_POWER = value;
	end
	IGNORE_VIRIBUS_TOGGLE.callback = function(value)
		CONFIG.IGNORE_VIRIBUS_TOGGLE = value;
	end
	MENU_COLOR.callback = function(value)
		xpcall(function()
			CONFIG.MENU_COLOR = {
				math.floor(value.R * 255),
				math.floor(value.G * 255),
				math.floor(value.B * 255)
			};
			WINDOW:settheme("accent", value)
			CHAT_LOGGER_WINDOW:settheme("accent", value)
		end, print)
	end
	NO_STUN_TOGGLE.callback = function(value)
		CONFIG.NO_STUN_TOGGLE = value;
	end



	xpcall(function()
		for _, CONNECTION in pairs(getconnections(SCRIPT_CONTEXT.Error)) do
			task.wait()
			CONNECTION:Disable();
		end 
	end, print)
	xpcall(function()
		for _, FOLDER in pairs(workspace:GetChildren()) do
			task.wait()
			if FOLDER:IsA("Folder") and FOLDER:FindFirstChildWhichIsA("UnionOperation") and FOLDER:FindFirstChildWhichIsA("UnionOperation"):FindFirstChildOfClass("ClickDetector") then
				INGREDIENTS_FOLDER = FOLDER
			end
		end
	end, print)
	local CACHE = {}

	local function INSERT_INGREDIENT(INGREDIENT, CAULDRON)
		local WATER = CAULDRON:FindFirstChild("Water")
		if PLAYER.Backpack:FindFirstChild(INGREDIENT) and WATER then
			local INGREDIENT_TOOL = PLAYER.Backpack:FindFirstChild(INGREDIENT)
			local INGREDIENT_EVENT = INGREDIENT_TOOL:FindFirstChildWhichIsA("RemoteEvent")
			INGREDIENT_TOOL.Parent = CHARACTER
			task.wait()
			xpcall(function()
				INGREDIENT_EVENT:FireServer(WATER.CFrame, WATER)
				task.wait()
				HUMANOID:UnequipTools()
			end, print)
		end
	end

	function GET_TRINKET_TYPE(TRINKET)
		if TRINKET.ClassName == "MeshPart" and TRINKET.MeshId == "rbxassetid://5204003946" then
			return "Goblet"
		elseif TRINKET.ClassName == "MeshPart" and TRINKET.MeshId == "rbxassetid://5196782997" then
			return "Old Ring"
		elseif TRINKET.ClassName == "MeshPart" and TRINKET.MeshId == "rbxassetid://5196776695" then
			return "Ring"
		elseif TRINKET.ClassName == "MeshPart" and TRINKET.MeshId == "rbxassetid://5196577540" then
			return "Old Amulet"
		elseif TRINKET.ClassName == "MeshPart" and TRINKET.MeshId == "rbxassetid://5196551436" then
			return "Amulet"
		elseif TRINKET.ClassName == "UnionOperation" and TRINKET.BrickColor == BrickColor.new("Dark grey") then
			return "Idol of the Forgotten"
		elseif TRINKET.ClassName == "UnionOperation" and getspecialinfo(TRINKET).AssetId == "https://www.roblox.com//asset/?id=3158350180" then
			return "Amulet of the White king"
		elseif TRINKET.ClassName == "UnionOperation" and getspecialinfo(TRINKET).AssetId == "https://www.roblox.com//asset/?id=2998499856" then
			return "Lannis's Amulet"
		elseif TRINKET.ClassName == "Part" and TRINKET:FindFirstChild("ParticleEmitter") and not string.match(tostring(TRINKET.ParticleEmitter.Color), "0 1 1 1 0 1 1 1 1 0") then
			return "Rift Gem"
		elseif TRINKET.ClassName == "MeshPart" and TRINKET.Material == Enum.Material.Fabric then
			return "Scroll"
		elseif TRINKET.ClassName == "Part" and TRINKET.BrickColor == BrickColor.new("Institutional white") and string.match(tostring(TRINKET.Size), "0.5") then
			return "Opal"
		elseif TRINKET.ClassName == "Part" and string.match(tostring(TRINKET.Size), "0.8") then
			if TRINKET.BrickColor == BrickColor.new("Really red") then
				return "Ruby"
			elseif TRINKET.BrickColor == BrickColor.new("Forest green") then
				return "Emerald"
			elseif TRINKET.BrickColor == BrickColor.new("Cadet blue") then
				return "Diamond"
			elseif TRINKET.BrickColor == BrickColor.new("Lapis") then
				return "Sapphire"
			end
		elseif TRINKET.ClassName == "Part" and TRINKET.BrickColor == BrickColor.new("Mulberry") and TRINKET:FindFirstChildOfClass("PointLight") and TRINKET:FindFirstChild("OrbParticle") then
			return "???"
		elseif TRINKET.ClassName == "Part" and TRINKET.BrickColor == BrickColor.new("Persimmon") and TRINKET:FindFirstChildOfClass("PointLight") and TRINKET:FindFirstChild("OrbParticle") then
			return "Ice Essence"
		elseif TRINKET:FindFirstChildWhichIsA("ParticleEmitter", true) and TRINKET:FindFirstChildWhichIsA("ParticleEmitter", true).Color.Keypoints[1].Value == Color3.new(1, 0.8, 0) then
			return "Phoenix Down"
		elseif TRINKET:FindFirstChildWhichIsA("Attachment") and TRINKET:FindFirstChildWhichIsA("Attachment"):FindFirstChildWhichIsA("ParticleEmitter") and TRINKET:FindFirstChildWhichIsA("ParticleEmitter", true).Color.Keypoints[1].Value == Color3.new(0.45098, 1, 0) then
			return "Mysterious Artifact"
		elseif TRINKET.ClassName == "UnionOperation" and TRINKET.Color == Color3.fromRGB(29, 46, 58) then
			return "Night Stone"
		end
		return "Azael Horn"
	end

	local function DRAW(CLASS, PROPERTIES)
		local DRAWING = Drawing.new(CLASS)
		for PROPERTY, VALUE in pairs(PROPERTIES) do
			DRAWING[PROPERTY] = VALUE
		end
		return DRAWING
	end

	local function CREATE_ESP(TARGET)
		local ESP = {}
		ESP.NAME = DRAW("Text", {
			Color = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_COLOR)),
			Font = CONFIG.PLAYER_ESP_TEXT_FONT,
			Outline = true,
			Center = true,
			Size = CONFIG.PLAYER_ESP_TEXT_SIZE
		})
		CACHE[TARGET] = ESP
	end

	local function CREATE_TRINKET_ESP(TRINKET)
		if TRINKET and not TRINKET:IsA("Folder") and TRINKET:FindFirstChild("ID", true) then
			local ESP = {}
			ESP.NAME = DRAW("Text", {
				Color = Color3.fromRGB(table.unpack(CONFIG.TRINKET_ESP_TRINKET_COLOR)),
				Font = CONFIG.TRINKET_ESP_TEXT_FONT,
				Outline = true,
				Center = true,
				Size = CONFIG.TRINKET_ESP_TEXT_SIZE
			})
			CACHE[TRINKET] = ESP
		end
	end

	local function CREATE_BAG_ESP(BAG)
		if BAG and (tostring(BAG) == "MoneyBag" or tostring(BAG) == "ToolBag") then
			local ESP = {}
			ESP.NAME = DRAW("Text", {
				Color = Color3.fromRGB(table.unpack(CONFIG.BAG_ESP_COLOR)),
				Font = CONFIG.BAG_ESP_TEXT_FONT,
				Outline = true,
				Center = true,
				Size = CONFIG.BAG_ESP_TEXT_SIZE
			})
			CACHE[BAG] = ESP
		end
	end

	local function REMOVE_ESP(TARGET)
		local ESP = CACHE[TARGET]
		if ESP then
			for _, DRAWING in pairs(ESP) do
				task.wait()
				xpcall(function()
					DRAWING:Destroy()
				end, print)
			end

			CACHE[TARGET] = nil
		end
	end

	local function floor2(v)
		return Vector2.new(math.floor(v.X), math.floor(v.Y))
	end

	local function UPDATE_ESP()
		for TARGET, ESP in pairs(CACHE) do
			task.wait()
			if PLAYERS:FindFirstChild(tostring(TARGET)) then
				local TARGET_CHARACTER, TARGET_TEAM = TARGET.Character, TARGET.Team
				if TARGET_CHARACTER and CONFIG.PLAYER_ESP_TOGGLE and TARGET.Character:FindFirstChild("Humanoid") and TARGET.Character.Humanoid.Health > 0 then
					local TARGET_CFRAME = TARGET_CHARACTER:GetPivot()
					local SCREEN_POSITION, VISIBLE = CAMERA:WorldToViewportPoint(TARGET_CFRAME.Position)

					if VISIBLE and CONFIG.PLAYER_ESP_TOGGLE then
						local DISTANCE = "???"
						local TARGET_HUMANOID = TARGET_CHARACTER:FindFirstChildOfClass("Humanoid")
						local TARGET_HEALTH = (TARGET_HUMANOID and TARGET_HUMANOID.Health or 100) / 100

						local FRUSTUM_HEIGHT = math.tan(math.rad(CAMERA.FieldOfView * 0.5)) * 2 * SCREEN_POSITION.Z
						local SIZE = CAMERA.ViewportSize.Y / FRUSTUM_HEIGHT * Vector2.new(4, 6)
						local POSITION = Vector2.new(SCREEN_POSITION.X, SCREEN_POSITION.Y)

						if ROOT then
							DISTANCE = math.floor((TARGET_CFRAME.Position - ROOT.Position).magnitude)
						end

						ESP.NAME.Color = Color3.fromRGB(table.unpack(CONFIG.PLAYER_ESP_COLOR))
						ESP.NAME.Font = CONFIG.PLAYER_ESP_TEXT_FONT
						ESP.NAME.Size = CONFIG.PLAYER_ESP_TEXT_SIZE
						ESP.NAME.Text = string.format("%s [%s]\n[%s] [%s/%s]", GET_PLAYER_INGAME_NAME(TARGET_CHARACTER), tostring(TARGET), tostring(DISTANCE), tostring(math.floor(TARGET_HUMANOID.Health)), tostring(math.floor(TARGET_HUMANOID.MaxHealth)))
						ESP.NAME.Position = POSITION
					end

					for TYPE, DRAWING in pairs(ESP) do
						task.wait()
						DRAWING.Visible = VISIBLE
					end
				else
					for _, DRAWING in pairs(ESP) do
						task.wait()
						DRAWING.Visible = false
					end
				end
			else --# is trinket
				if TARGET.Parent == workspace then
					local TRINKET_TYPE = GET_TRINKET_TYPE(TARGET)
					if TARGET and CONFIG.TRINKET_ESP_TOGGLE and TARGET.Parent and TARGET.Parent == workspace then
						local SCREEN_POSITION, VISIBLE = CAMERA:WorldToViewportPoint(TARGET.Position)
						if VISIBLE and CONFIG.TRINKET_ESP_TOGGLE then
							local DISTANCE = "???"
							if ROOT then
								DISTANCE = math.floor((TARGET.Position - ROOT.Position).magnitude)
							end						

							ESP.NAME.Color = table.find(ARTIFACT_NAMES, TRINKET_TYPE) and Color3.fromRGB(table.unpack(CONFIG.TRINKET_ESP_ARTIFACT_COLOR)) or Color3.fromRGB(table.unpack(CONFIG.TRINKET_ESP_TRINKET_COLOR))
							ESP.NAME.Font = CONFIG.TRINKET_ESP_TEXT_FONT
							ESP.NAME.Size = CONFIG.TRINKET_ESP_TEXT_SIZE
							ESP.NAME.Text = string.format("%s [%s]", TRINKET_TYPE, tostring(DISTANCE))
							ESP.NAME.Position = Vector2.new(SCREEN_POSITION.X, SCREEN_POSITION.Y)
						end

						for TYPE, DRAWING in pairs(ESP) do
							task.wait()
							DRAWING.Visible = VISIBLE
						end
					else
						for _, DRAWING in pairs(ESP) do
							task.wait()
							DRAWING.Visible = false
						end
					end
				elseif TARGET.Parent == workspace.Thrown then
					if TARGET and CONFIG.BAG_ESP_TOGGLE and TARGET.Parent and TARGET.Parent == workspace.Thrown then
						local SCREEN_POSITION, VISIBLE = CAMERA:WorldToViewportPoint(TARGET.Position)
						if VISIBLE and CONFIG.BAG_ESP_TOGGLE then
							local ITEM_NAME = "???"
							if TARGET:FindFirstChildWhichIsA("BillboardGui") and TARGET:FindFirstChildWhichIsA("BillboardGui"):FindFirstChildWhichIsA("TextLabel") then
								ITEM_NAME = TARGET:FindFirstChildWhichIsA("BillboardGui"):FindFirstChildWhichIsA("TextLabel").Text
							end
							local DISTANCE = "???"
							if ROOT then
								DISTANCE = math.floor((TARGET.Position - ROOT.Position).magnitude)
							end						

							ESP.NAME.Color = Color3.fromRGB(table.unpack(CONFIG.BAG_ESP_COLOR))
							ESP.NAME.Font = CONFIG.BAG_ESP_TEXT_FONT
							ESP.NAME.Size = CONFIG.BAG_ESP_TEXT_SIZE
							ESP.NAME.Text = string.format("%s [%s]", tostring(ITEM_NAME), tostring(DISTANCE))
							ESP.NAME.Position = Vector2.new(SCREEN_POSITION.X, SCREEN_POSITION.Y)
						end

						for TYPE, DRAWING in pairs(ESP) do
							task.wait()
							DRAWING.Visible = VISIBLE
						end
					else
						for _, DRAWING in pairs(ESP) do
							task.wait()
							DRAWING.Visible = false
						end
					end
				end
			end
		end
	end

	local function GET_CURRENT_SERVER_ID()
		local SERVERS = CLIENT_STORAGE:WaitForChild("ServerInfo"):GetChildren()
		for _, SERVER in pairs(SERVERS) do
			local SERVER_PLAYERS = SERVER.Players.Value
			SERVER_PLAYERS = HTTP_SERVICE:JSONDecode(SERVER_PLAYERS)
			for _, PLAYER_DATA in pairs(SERVER_PLAYERS) do
				if PLAYER_DATA.Name == tostring(PLAYER) then
					return tostring(SERVER)
				end
			end
		end
		return "nil"
	end

	local function HANDLE_KNOCKED_CHARACTER_OWNERSHIP()
		if CONFIG.KNOCKED_CHARACTER_OWNERSHIP_TOGGLE and CHARACTER and ROOT then
			xpcall(function()
				if COLLECTION_SERVICE:HasTag(CHARACTER, "Unconscious") and CONFIG.FLIGHT_TOGGLE then
					if tick() - LAST_OWNERSHIP > 0.05 then
						LAST_OWNERSHIP = tick()
						if CHARACTER:FindFirstChildWhichIsA("Tool") then
							HUMANOID:UnequipTools()
						end
						if not CHARACTER:FindFirstChildWhichIsA("Tool") then
							for _, TOOL in pairs(PLAYER.Backpack:GetChildren()) do
								task.wait()
								if TOOL:FindFirstChild("PrimaryWeapon") then
									TOOL.Parent = CHARACTER
									task.wait()
									HUMANOID:UnequipTools()
									return
								end
								if TOOL:FindFirstChild("Handle") then
									TOOL.Parent = CHARACTER
									task.wait()
									HUMANOID:UnequipTools()
									return
								end
							end
						end
					end
				end
			end, print)
		end
	end

	xpcall(function()
		if not BAN_ANIMATION or typeof(BAN_ANIMATION) ~= "Instance" or not BAN_ANIMATION:IsA("AnimationTrack") then
			local NPC_HUMANOID = nil
			for _, NPC in next, workspace.NPCs:GetChildren() do
				if NPC:FindFirstChildWhichIsA("Humanoid", true) then
					NPC_HUMANOID = NPC.Humanoid
				end
			end

			local ANIMATION = Instance.new("Animation")
			ANIMATION.AnimationId = "rbxassetid://4595066903"

			BAN_ANIMATION = NPC_HUMANOID:LoadAnimation(ANIMATION)
		end

		xpcall(function()
			local OLD; OLD = hookfunction(BAN_ANIMATION.Play, newcclosure(function(self)
				if typeof(self) ~= "Instance" or not self:IsA("AnimationTrack") then
					return OLD(self)
				end

				if self.Animation and string.find(self.Animation.AnimationId, "4595066903") then
					return
				end

				return OLD(self)
			end))
		end, print)
	end, print)
	xpcall(function()
		setfpscap(100000000)
	end, print)
	xpcall(function()
		if pcall(function() readfile(string.format("opium/paths/loaded/%s", tostring(PLAYER))) end) then
			local PATH_DATA = HTTP_SERVICE:JSONDecode(readfile(string.format("opium/paths/loaded/%s", tostring(PLAYER))))
			if PATH_DATA.PATH then
				xpcall(function()
					task.delay(6, function()
						xpcall(function()
							if PLAYER_GUI:FindFirstChild("StartMenu") then
								task.wait(0.5)
								pcall(function()
									firesignal(PLAYER_GUI.StartMenu.Choices.Play.MouseButton1Click)
								end)
							end
							repeat task.wait() until CHARACTER
							SET_TRINKET_BOT_PATH = PATH_DATA.PATH
							local DECODED_JSON = HTTP_SERVICE:JSONDecode(readfile(string.format("opium/paths/%s", SET_TRINKET_BOT_PATH)))
							if not DECODED_JSON.POINTS then
								CURRENT_CFRAME_POINTS["POINTS"] = DECODED_JSON
							else
								CURRENT_CFRAME_POINTS = DECODED_JSON
							end

							TRINKET_BOT_ILLUSIONIST_DETECT_TOGGLE:set(CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"])
							TRINKET_BOT_PICK_UP_SCROLLS_TOGGLE:set(CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"])
							TRINKET_BOT_SPEED:set(CURRENT_CFRAME_POINTS["SETTINGS"]["SPEED"])
							if CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] then
								TRINKET_BOT_WEBHOOK_NAME_BOX:set(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"])
							end
							task.wait()
							START_PATH()
						end, print)
					end)
				end, print)
			end
		end
	end, print)
	xpcall(function()
		local function HANDLE_FOG_START()
			if CONFIG.NO_FOG_TOGGLE then
				LIGHTING.FogStart = 0
			end
		end
		local function HANDLE_FOG_END()
			if CONFIG.NO_FOG_TOGGLE then
				LIGHTING.FogEnd = 100000
				for _, FOG_MESH in pairs(COLLECTION_SERVICE:GetTagged("WeatherCover")) do
					if FOG_MESH:IsA("BasePart") and FOG_MESH:IsDescendantOf(workspace) then
						FOG_MESH.Parent = game.Selection
					end
				end
			end
		end
		local function HANDLE_AMBIENT()
			if CONFIG.FULL_BRIGHT_TOGGLE then
				LIGHTING.Ambient = Color3.fromRGB(255, 255, 255)
			end
		end

		xpcall(function()
			LIGHTING:GetPropertyChangedSignal("Ambient"):Connect(function()
				HANDLE_AMBIENT()
			end)
		end, print)
		xpcall(function()
			LIGHTING:GetPropertyChangedSignal("FogStart"):Connect(function()
				HANDLE_FOG_START()
			end)
		end, print)
		xpcall(function()
			LIGHTING:GetPropertyChangedSignal("FogEnd"):Connect(function()
				HANDLE_FOG_END()
			end)
		end, print)

		xpcall(function()
			HANDLE_AMBIENT()
			HANDLE_FOG_START()
			HANDLE_FOG_END()
		end, print)

		xpcall(function()
			FULL_BRIGHT_TOGGLE.callback = function(value)
				CONFIG.FULL_BRIGHT_TOGGLE = value;
				HANDLE_AMBIENT()
			end
			NO_FOG_TOGGLE.callback = function(value)
				CONFIG.NO_FOG_TOGGLE = value;
				HANDLE_FOG_START()
				HANDLE_FOG_END()
			end
		end, print)
	end, print)
	xpcall(function()
		for POTION, RECIPE in pairs(POTIONS) do
			AUTO_CRAFT_POTION_TAB:button({
				name = POTION;
				callback = function()
					xpcall(function()
						if CHARACTER and ROOT then
							local CAULDRON, RADIUS = nil, 12
							for _, STATION in pairs(workspace.Stations:GetChildren()) do
								if tostring(STATION) == "AlchemyStation" then
									local MAGNITUDE = (ROOT.Position - STATION.Water.Position).Magnitude
									if MAGNITUDE < RADIUS then
										RADIUS = MAGNITUDE
										CAULDRON = STATION
									end
								end
							end
							if CAULDRON then
								xpcall(function()
									for _, INGREDIENT in pairs(RECIPE) do
										--[[local CONTENTS = HTTP_SERVICE:JSONDecode(CAULDRON.Contents.Value)
										local SIMPLIFIED_CONTENTS = {}
										for _, INGREDIENT in pairs(CONTENTS) do
											if not SIMPLIFIED_CONTENTS[INGREDIENT] then
												SIMPLIFIED_CONTENTS[INGREDIENT] = 0
											end
											SIMPLIFIED_CONTENTS[INGREDIENT] += 1
										end]]
										xpcall(function()
											INSERT_INGREDIENT(INGREDIENT, CAULDRON)
											task.wait(0.05)
										end, print)
									end

									local LADLE = CAULDRON:FindFirstChild("Ladle")
									if LADLE and LADLE:FindFirstChildWhichIsA("ClickDetector") then
										fireclickdetector(LADLE:FindFirstChildWhichIsA("ClickDetector"))
									end
								end, print)
							end
						end
					end, print)
				end;
			})
		end
	end, print)
	xpcall(function()
		for _, REMOTE in pairs(CLIENT_STORAGE:GetDescendants()) do
			if REMOTE:IsA("RemoteEvent") then
				xpcall(function()
					REMOTE.OnClientEvent:Connect(function(ARGUMENTS)
						if typeof(ARGUMENTS) == "table" and ARGUMENTS.msg then
							DIALOGUE_MODULE.REMOTE = REMOTE
							DIALOGUE_MODULE.DIALOGUE_DATA = ARGUMENTS
						end
					end)
				end, print)
			end
		end

		function DIALOGUE_MODULE:SEND(CHOICE)
			local REMOTE = self.REMOTE
			local DATA = self.DIALOGUE_DATA
			if REMOTE and DATA and DATA.choices[CHOICE] then
				REMOTE:FireServer({choice = CHOICE})
			end
		end
	end, print)
	xpcall(function()
		local TELEPORT_TO_INN_DROPDOWN = MAIN_MISC_TAB:dropdown({
			name = "Inn Location";
			def = INN_TO_TELEPORT;
			max = 9;
			options = {
				"Southern Sanctuary"; "Scroomville"; "Castle Sanctuary"; "Sleeping Snail"; "Wayside Inn"; "Alana"; "Oresfall"; "Renova"; "Central Sanctuary"
			};
			callback = function(value)
				INN_TO_TELEPORT = value;
			end;
		})
		local TELEPORT_TO_INN_BUTTON = MAIN_MISC_TAB:button({
			name = "Teleport to Inn";
			callback = function()
				xpcall(function()
					local INN = nil
					for _, NPC in pairs(workspace.NPCs:GetChildren()) do
						if tostring(NPC) == "Inn Keeper" and NPC:FindFirstChild("Location") and NPC.Location.Value == INN_TO_TELEPORT then
							INN = NPC
						end
					end
					if INN then
						task.spawn(function()
							xpcall(function()
								local TIME = 0
								while TIME < 1 do
									LOCK_ROOT_VELOCITY = true
									CHARACTER:PivotTo(INN:GetPivot())
									fireclickdetector(INN:FindFirstChildWhichIsA("ClickDetector"))
									if DIALOGUE_MODULE.REMOTE then
										DIALOGUE_MODULE.REMOTE:FireServer({
											choice = "Sure.";
										})
									end
									TIME = TIME + task.wait()
								end
								LOCK_ROOT_VELOCITY = false
								CHARACTER:BreakJoints()
							end, print)
						end)
					end
				end, print)
			end;
		})
	end, print)
	xpcall(function()
		PLAYERS.PlayerAdded:Connect(CREATE_ESP)
		PLAYERS.PlayerRemoving:Connect(REMOVE_ESP)
		for INDEX, TARGET in ipairs(PLAYERS:GetPlayers()) do
			if INDEX ~= 1 then
				CREATE_ESP(TARGET)
			end
		end
	end, print)
	xpcall(function()
		workspace.ChildAdded:Connect(CREATE_TRINKET_ESP)
		workspace.ChildRemoved:Connect(REMOVE_ESP)
		for _, TRINKET in ipairs(workspace:GetChildren()) do
			CREATE_TRINKET_ESP(TRINKET)
		end
	end, print)
	xpcall(function()
		workspace.Thrown.ChildAdded:Connect(CREATE_BAG_ESP)
		workspace.Thrown.ChildRemoved:Connect(REMOVE_ESP)
		for _, BAG in ipairs(workspace.Thrown:GetChildren()) do
			CREATE_BAG_ESP(BAG)
		end
	end, print)
	xpcall(function()
		workspace.Thrown.ChildAdded:Connect(function(CHILD)
			if CONFIG.IGNORE_VIRIBUS_TOGGLE and tostring(CHILD) == "EarthPillar" then
				local EARTH = CHILD:FindFirstChild("Earth")
				if EARTH then
					xpcall(function()
						local TOUCH_INTEREST = EARTH:WaitForChild("TouchInterest")
						TOUCH_INTEREST:Destroy()
					end, print)
				end
			end
		end)
	end, print)
	xpcall(function()
		REMOVE_COPYRIGHT()
	end, print)
	xpcall(function() --# handle illusionist/mod
		local function HANDLE_TARGET_CHARACTER(TARGET)
			local TARGET_CHARACTER = TARGET.Character
			if TARGET_CHARACTER and (TARGET.Backpack:FindFirstChild("Observe") or TARGET_CHARACTER:FindFirstChild("Observe")) then
				WINDOW:notify(string.format("%s IS AN ILLUSIONIST", tostring(TARGET)), 5)
				if BOT_RUNNING and CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"] then
					PLAYER:Kick("[opium.cc] retard (illusionist) joined. server hopping...")
					xpcall(SERVER_HOP, print)
				end
				TARGET.Backpack.ChildAdded:Connect(function(ITEM)
					if tostring(ITEM) == "Observe" then
						WINDOW:notify(string.format("%s IS AN ILLUSIONIST", tostring(TARGET)), 5)
						if BOT_RUNNING and CURRENT_CFRAME_POINTS["SETTINGS"]["ILLUSIONIST_DETECT"] then
							PLAYER:Kick("[opium.cc] retard (illusionist) joined. server hopping...")
							xpcall(SERVER_HOP, print)
						end
					end
					if table.find(ARTIFACT_NAMES, tostring(ITEM)) then
						WINDOW:notify(string.format("%s HAS AN ARTIFACT: %s", tostring(TARGET), tostring(ITEM)), 5)
					end
				end)
			end
		end
		local function HANDLE_PLAYER(TARGET)
			if TARGET and TARGET:IsInGroup(4556484) then
				local TARGET_ROLE = TARGET:GetRoleInGroup(4556484)
				if TARGET_ROLE == "Junior Mod" or TARGET_ROLE == "Moderator" or TARGET_ROLE == "Senior Moderator" or TARGET_ROLE == "Head Moderator" then
					WINDOW:notify(string.format("%s IS A MODERATOR (BY GROUP)", tostring(TARGET)), 5)
					if BOT_RUNNING then
						PLAYER:Kick("[opium.cc] faggot (moderator) joined. server hopping...")
						xpcall(SERVER_HOP, print)
					end
				end
			end
			HANDLE_TARGET_CHARACTER(TARGET)
			TARGET.CharacterAdded:Connect(function()
				HANDLE_TARGET_CHARACTER(TARGET)
			end)
		end

		for INDEX, TARGET in ipairs(PLAYERS:GetPlayers()) do
			if INDEX ~= 1 then
				HANDLE_PLAYER(TARGET)
			end
		end
		PLAYERS.PlayerAdded:Connect(function(TARGET)
			if PLAYER ~= TARGET then
				HANDLE_PLAYER(TARGET)
			end
		end)
	end, print)
	xpcall(function()
		USER_INPUT.InputBegan:Connect(function(INPUT, GAME_EVENT)
			if not GAME_EVENT then
				if KEYS[INPUT.KeyCode.Name] then
					KEYS[INPUT.KeyCode.Name] = 1
				else
					if INPUT.KeyCode == Enum.KeyCode.F1 and BOT_RUNNING then
						xpcall(STOP_PATH, print)
						return
					end

					local toggles_because_im_lazy = {
						["FLIGHT_TOGGLE"] = FLIGHT_TOGGLE;
						["NOCLIP_TOGGLE"] = NOCLIP_TOGGLE;
						["WALK_SPEED_TOGGLE"] = WALK_SPEED_TOGGLE;
						["JUMP_POWER_TOGGLE"] = JUMP_POWER_TOGGLE;
					}
					for NAME, KEYBIND in pairs(CONFIG) do
						if NAME:find("KEYBIND") then
							local INPUT_KEYCODE = INPUT.KeyCode
							pcall(function()
								if INPUT_KEYCODE == Enum.KeyCode[KEYBIND] then
									local FEATURE = string.split(NAME, "KEYBIND")[1].."TOGGLE"
									CONFIG[FEATURE] = not CONFIG[FEATURE]
									if toggles_because_im_lazy[FEATURE] then
										toggles_because_im_lazy[FEATURE]:set(CONFIG[FEATURE])
									end
								end
							end)
						end
					end
				end
			end
		end)
	end, print)
	xpcall(function()
		USER_INPUT.InputEnded:Connect(function(INPUT, GAME_EVENT)
			if not GAME_EVENT then
				if KEYS[INPUT.KeyCode.Name] then
					KEYS[INPUT.KeyCode.Name] = 0
				end
			end
		end)
	end, print)
	xpcall(function()
		RUN_SERVICE.RenderStepped:Connect(function()
			xpcall(function()
				if (BOT_RUNNING or LOCK_ROOT_VELOCITY) and CHARACTER and ROOT then
					ROOT.Velocity = Vector3.new(0, 0, 0)
				end
			end, print)
			xpcall(function()
				if CHARACTER and HUMANOID and (CONFIG.NOCLIP_TOGGLE or BOT_RUNNING) then
					task.defer(function()
						xpcall(function()
							HUMANOID.JumpPower = 0
						end, print)
					end)
				end
			end, print)
			xpcall(function()
				if CHARACTER and HUMANOID and CONFIG.JUMP_POWER_TOGGLE and not CONFIG.NOCLIP_TOGGLE then
					task.defer(function()
						xpcall(function()
							HUMANOID.JumpPower = CONFIG.NOCLIP_TOGGLE and 0 or CONFIG.JUMP_POWER_POWER
						end, print)
					end)
				end
			end, print)
			xpcall(function()
				if BOT_RUNNING then
					for _, TARGET in pairs(PLAYERS:GetPlayers()) do
						if TARGET:IsInGroup(4556484) then
							local TARGET_ROLE = TARGET:GetRoleInGroup(4556484)
							if TARGET_ROLE == "Junior Mod" or TARGET_ROLE == "Moderator" or TARGET_ROLE == "Senior Moderator" or TARGET_ROLE == "Head Moderator" then
								if BOT_RUNNING then
									PLAYER:Kick("[opium.cc] faggot (moderator) joined. server hopping...")
									local SERVERS = CLIENT_STORAGE:WaitForChild("ServerInfo"):GetChildren()
									local RANDOM_SERVER = SERVERS[math.random(1, #SERVERS)]
									REQUESTS:WaitForChild("JoinPublicServer"):FireServer(tostring(RANDOM_SERVER))
								end
							end
						end
						if TARGET.Backpack:FindFirstChild("Observe") and CURRENT_CFRAME_POINTS.SETTINGS.ILLUSIONIST_DETECT then
							BOT_RUNNING = false
							--PLAYER:Kick("[opium.cc] retard (illu) joined. server hopping...")
							xpcall(SERVER_HOP, print)
							return
						end
					end
				end
			end, print)
			xpcall(function()
				if CHARACTER and ROOT then
					if BOT_RUNNING and ROOT.Anchored then
						PLAYER:Kick("[opium.cc] AA GUN TRIGGERED")
						return
					end
				end
			end, print)
			xpcall(function()
				for _, CHILD in pairs(workspace.Thrown:GetChildren()) do
					task.wait()
					if typeof(CHILD) == "Instance" and tostring(CHILD) == "FlowerProjectile" and CONFIG.PERFLORA_TELEPORT_TOGGLE then
						if CHARACTER and SPECTATING and SPECTATING.Character then
							xpcall(function()
								CHILD.CFrame = CAMERA.CFrame --SPECTATING.Character.HumanoidRootPart.Position
							end, print)
						end
					end
				end
			end, print)
			xpcall(function()
				if BOT_RUNNING then
					for _, TRINKET in pairs(workspace:GetChildren()) do
						if not TRINKET:IsA("Folder") and TRINKET:FindFirstChild("ID") then
							local ID = TRINKET:FindFirstChild("ID").Value
							if not FOUND_TRINKETS[tostring(ID)] then
								local TRINKET_FOUND = GET_TRINKET_TYPE(TRINKET)
								FOUND_TRINKETS[tostring(ID)] = TRINKET_FOUND

								if CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] and (table.find(ARTIFACT_NAMES, TRINKET_FOUND) or TRINKET_FOUND == "Phoenix Down" or TRINKET_FOUND == "Ice Essence") and CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"] ~= "" and string.find(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"], "webhook") then
									xpcall(function()
										local CURRENT_SERVER = GET_CURRENT_SERVER_ID()
										SEND_WEBHOOK(CURRENT_CFRAME_POINTS["SETTINGS"]["WEBHOOK"], {
											["username"] = "destroy lonely";
											["content"] = table.find(ARTIFACT_NAMES, TRINKET_FOUND) and "@everyone" or "";
											["embeds"] = {
												{
													["title"] = TRINKET_FOUND;
													["description"] = string.format("```lua\nSERVER ID: %s\n\n-- execute script below to join the server\n\nxpcall(function()\ngame.ReplicatedStorage.Requests.JoinPublicServer:FireServer(\"%s\")\nend, print)\n```", tostring(CURRENT_SERVER), tostring(CURRENT_SERVER));
													["color"] = tonumber(0x00000);
													["author"] = {
														["name"] = "ARTIFACT FOUND";
													};
													["timestamp"] = DateTime.now():ToIsoDate();
												}
											}
										})
									end, print)
								end
							end
						end
					end
				end
			end, print)
			xpcall(function()
				if CONFIG.AUTO_TRINKET_PICKUP_TOGGLE then
					for _, TRINKET in pairs(workspace:GetChildren()) do
						if CHARACTER and ROOT and not TRINKET:IsA("Folder") and TRINKET:FindFirstChild("ID") then
							if (ROOT.Position - TRINKET.Part.Position).magnitude <= (TRINKET.Part.ClickDetector.MaxActivationDistance + 5) then
								if BOT_RUNNING then
									if not CURRENT_CFRAME_POINTS["SETTINGS"]["PICK_UP_SCROLLS"] and (GET_TRINKET_TYPE(TRINKET) == "Scroll" or GET_TRINKET_TYPE(TRINKET) == "Ice Essence") then
										continue
									end
								end
								fireclickdetector(TRINKET.Part.ClickDetector)
							end
						end
					end
				end
				if CONFIG.AUTO_INGREDIENT_PICKUP_TOGGLE then
					for _, INGREDIENT in pairs(INGREDIENTS_FOLDER:GetChildren()) do
						if CHARACTER and ROOT and INGREDIENT.Transparency ~= 1 and INGREDIENT:FindFirstChildOfClass("ClickDetector") then
							if (ROOT.Position - INGREDIENT.Position).magnitude <= (INGREDIENT.ClickDetector.MaxActivationDistance + 5) then
								fireclickdetector(INGREDIENT.ClickDetector)
							end
						end
					end
				end
				xpcall(function()
					if CONFIG.AUTO_BAG_PICKUP_TOGGLE then
						for _, TOOL_BAG in pairs(workspace.Thrown:GetChildren()) do
							if CHARACTER and ROOT and (tostring(TOOL_BAG) == "ToolBag" or tostring(TOOL_BAG) == "MoneyBag") then
								if (ROOT.Position - TOOL_BAG.Position).Magnitude <= 150 then
									TOOL_BAG.CFrame = ROOT.CFrame
									xpcall(function()
										firetouchinterest(ROOT, TOOL_BAG, 0)
									end, print)
								end
							end
						end
					end
				end, print)
			end, print)
			xpcall(HANDLE_KNOCKED_CHARACTER_OWNERSHIP, print)
			xpcall(UPDATE_ESP, print)
			if CONFIG.FLIGHT_TOGGLE and CHARACTER and ROOT then
				ROOT.Velocity = ((CAMERA.CFrame.RightVector * (KEYS.D - KEYS.A) + CAMERA.CFrame.LookVector * (KEYS.W - KEYS.S)) * CONFIG.FLIGHT_SPEED)
			end
			xpcall(function()
				if CONFIG.NOCLIP_TOGGLE and CHARACTER and ROOT then
					HUMANOID:ChangeState(Enum.HumanoidStateType.Jumping)
					local PARTS = workspace:GetPartsInPart(ROOT)
					for _, PART in pairs(PARTS) do
						if NOCLIPPED_PARTS[PART] or (not PART:IsDescendantOf(CHARACTER) and PART.CanCollide) then
							NOCLIPPED_PARTS[PART] = tick()
							PART.CanCollide = false
						end
					end
				else
					for PART, _ in pairs(NOCLIPPED_PARTS) do
						PART.CanCollide = true
					end
					table.clear(NOCLIPPED_PARTS)
				end
			end, print)
			CHAT_LOGGER_WINDOW:update(CONFIG.CHAT_LOGGER_TOGGLE)
		end)
	end, print)
	xpcall(function()
		MESSAGE_FILTERING_EVENT.OnClientEvent:Connect(function(MESSAGE_OBJECT)
			if MESSAGE_OBJECT.Message ~= "" then
				local TARGET = PLAYERS:FindFirstChild(MESSAGE_OBJECT.FromSpeaker)
				local INGAME_NAME = "???"
				if TARGET and TARGET.Character then
					INGAME_NAME = GET_PLAYER_INGAME_NAME(TARGET.Character)
				end
				CHAT_LOGGER_WINDOW:insert_label(string.format("%s [%s]: %s", INGAME_NAME, MESSAGE_OBJECT.FromSpeaker, MESSAGE_OBJECT.Message))
			end
		end)
	end, print)
	xpcall(function()
		loadstring([[
			local OLD_FIRE; OLD_FIRE = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
				if not checkcaller() then
					local ARGUMENTS = {...}
					if ARGUMENTS[1] and typeof(ARGUMENTS[1]) == "table" and ARGUMENTS[1][1] and typeof(ARGUMENTS[1][1]) == "number" and ARGUMENTS[1][1] < 1 then
						if CONFIG.NO_FALL_DAMAGE_TOGGLE then
							return
						end
					end
				end

				return OLD_FIRE(self, ...)
			end))
		]])()
	end, print)
	xpcall(function()
		LOAD_CONFIG("default")
	end, print)
end, function(ERROR)
	print(ERROR)
end)
