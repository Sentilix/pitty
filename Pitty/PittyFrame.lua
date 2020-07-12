--[[
	Author:			Mimma
	Create Date:	5/23/2016 4:59:42 PM	
]]

local L = "Pitty"
-- Translated by shikulja
if GetLocale()=="ruRU" then
 UNKNOWN_COM=  "Неизвестная команда: %s"
 USING_VER=    "%s использует версию PiTTY %s"
 QH_LIST=      "Список QuickHeal очищен."
 DET_NEWP=     "Обнаружен новый игрок QH : %s (лечение на %d ед.)"
 QH_STATS=     "Статистика QuickHeal:"
 QH_HEALED=    "%d: %s (%d вылечено / %d в среднем)"
 QH_NOTFOUND=  "Не найдены игроки использующие QuickHeal."
 PITTY_OPT=    "PiTTY версия %s настройки:"
 HELP_1=       "Синтаксис:"
 HELP_2=       "    /pitty stats     Отображает статистику. Канал - опциональный параметр:"
 HELP_3=       "        party        Отображает список в канале Группы"
 HELP_4=       "        raid         Отображает список в канале Рейда"
 HELP_5=       "        rw           Отображает список как Рейдовые предупреждения"
 HELP_6=       "        guild        Отображает список в канале Гильдии"
 HELP_7=       "Остальные команды:"
 HELP_8=       "    /pittyreset      Сброс (пусто) статистики QH"
 HELP_9=       "    /pittyversion    Узнать версию"
 HELP_10=      "    /pittyhelp       Эта страница помощи :-)"
 PITTY_V=      "PiTTY версия "
else
 UNKNOWN_COM=  "Unknown command: %s"
 USING_VER=    "%s is using PiTTY version %s"
 QH_LIST=      "QuickHeal list has been cleared."
 DET_NEWP=     "Detected new QH player: %s (healing for %d)"
 QH_STATS=     "QuickHeal Stats:"
 QH_HEALED=    "%d: %s (%d healed / %d average)"
 QH_NOTFOUND=  "No players were found using QuickHeal."
 PITTY_OPT=    "PiTTY version %s options:"
 HELP_1=       "Syntax:"
 HELP_2=       "    /pitty stats     Display stats. Channel is optional parameter:"
 HELP_3=       "        party        Will display list in Party channel"
 HELP_4=       "        raid         Will display list in Raid channel"
 HELP_5=       "        rw           Will display list as Raid warnings"
 HELP_6=       "        guild        Will display list in Guild channel"
 HELP_7=       "Other commands:"
 HELP_8=       "    /pittyreset      Reset (empty) QH stats"
 HELP_9=       "    /pittyversion    Check version"
 HELP_10=      "    /pittyhelp       This help page :-)"
 PITTY_V=      "PiTTY version "
end

local PARTY_CHANNEL = "PARTY"
local RAID_CHANNEL  = "RAID"
local YELL_CHANNEL  = "YELL"
local SAY_CHANNEL   = "SAY"
local WARN_CHANNEL  = "RAID_WARNING"
local GUILD_CHANNEL = "GUILD"
local CHAT_END      = "|r"
local COLOUR_CHAT   = "|c8040A0F8"
local COLOUR_INTRO  = "|c8080F0FF"

local PITTY_MESSAGE_PREFIX = "PiTTYv1"


-- List of QH detected players: { playername, count, healed }
local QHPlayers = { }


--[[
	Echo a message for the local user only, including "logo"
]]
local function echo(msg)
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage(COLOUR_CHAT .. msg .. CHAT_END)
	end
end

local function gEcho(msg)
	echo("<"..COLOUR_INTRO.."PiTTY"..COLOUR_CHAT.."> "..msg);
end

local function sayEcho(msg)
	SendChatMessage(msg, SAY_CHANNEL);
end

local function yellEcho(msg)
	SendChatMessage(msg, YELL_CHANNEL);
end

local function rwEcho(msg)
	SendChatMessage(msg, WARN_CHANNEL);
end

local function partyEcho(msg)
	SendChatMessage(msg, PARTY_CHANNEL);
end

local function raidEcho(msg)
	if Pitty_IsInRaid() then
		SendChatMessage(msg, RAID_CHANNEL);
	end
end

local function guildEcho(msg)
	SendChatMessage(msg, GUILD_CHANNEL)
end

local function addonEcho(msg)
	SendAddonMessage(PITTY_MESSAGE_PREFIX, msg, RAID_CHANNEL)
end

local function whisper(receiver, msg)
	SendChatMessage(msg, WHISPER_CHANNEL, nil, receiver);
end

local function customEcho(channel, msg)
	if not channel then
		channel = "";
	else
		channel = string.upper(channel);
	end
	
	if channel == "SAY" then
		sayEcho(msg);
	elseif channel == "YELL" then
		yellEcho(msg);
	elseif channel == "PARTY" then
		partyEcho(msg);
	elseif channel == "RAID" then
		raidEcho(msg);
	elseif channel == "RW" then
		rwEcho(msg);
	elseif channel == "GUILD" then
		guildEcho(msg);
	else
		gEcho(msg);
	end

end


--[[
	Main entry for Pitty.
	This will send the request to one of the sub slash commands.
	Syntax: /pitty [option, defaulting to "res"]
	Added in: 0.0.1
]]
SLASH_PITTY_PITTY1 = "/pitty"
SlashCmdList["PITTY_PITTY"] = function(msg)
	local option, args
	local spacepos = string.find(msg, "%s");
	if spacepos then
		_, _, option, args = string.find(msg, "(%S+)%s+(.+)");
	else
		_, _, option = string.find(msg, "(%S*)");
		args = "";
	end	
	
	if (not option) or (option == "") then
		option = "HELP";
	end
	if (not args) or (args == "") then
		args = "";
	end
	option = string.upper(option);
	args = string.upper(args);

	if (option == "HELP" or option == "?") then
		Pitty_ShowHelp();
	elseif option == "STATS" then
		Pitty_ShowStats(args);
	elseif option == "RESET" then
		Pitty_ResetList();
	elseif option == "VERSION" then
		Pitty_ShowVersion();
	else
		gEcho(string.format(UNKNOWN_COM, option));
	end
end


--[[
	Main entry for Pitty.
	This will send the request to one of the sub slash commands.
	Syntax: /pitty [option, defaulting to "LOCAL"]
	Added in: 0.0.1
]]
SLASH_PITTY_STATS1 = "/pittystats"
SLASH_PITTY_STATS2 = "/qhstats"
SlashCmdList["PITTY_STATS"] = function(msg)
	local _, _, args = string.find(msg, "(%S*)");
	if not args or args == "" then
		args = "LOCAL";
	end

	Pitty_ShowStats(args);
end

SLASH_PITTY_HELP1 = "/pittyhelp"
SlashCmdList["PITTY_HELP"] = function(msg)
	Pitty_ShowHelp();
end

SLASH_PITTY_HELP1 = "/pittyreset"
SlashCmdList["PITTY_RESET"] = function(msg)
	Pitty_ResetList();
end

--[[
	Request client version information
	Syntax: /pittyversion
	Alternative: /pitty version
	Added in: 1.1.0
]]
SLASH_PITTY_VERSION1 = "/pittyversion"
SlashCmdList["PITTY_VERSION"] = function(msg)
	Pitty_ShowVersion();
end


function Pitty_ShowVersion()
	if Pitty_IsInRaid() or Pitty_IsInParty() then
		addonEcho("TX_VERSION##");
	else
		gEcho(string.format(USING_VER, UnitName("player"), GetAddOnMetadata("Pitty", "Version")));
	end
end


function Pitty_ResetList()
	QHPlayers = { };
	gEcho(QH_LIST);
end



local function Pitty_RegisterQHeal(playername, healed)

	for n=1, table.getn(QHPlayers), 1 do
		if QHPlayers[n][1] == playername then
			QHPlayers[n][2] = QHPlayers[n][2] + 1;
			QHPlayers[n][3] = QHPlayers[n][3] + (1* healed);
			return;
		end
	end
	
	-- Player not found; add him/her:	
	QHPlayers[ table.getn(QHPlayers) + 1] = { playername, 1, healed };
	gEcho(string.format(DET_NEWP, playername, healed));
end


function Pitty_ShowStats(channel)
	customEcho(channel, QH_STATS);

	local sortedTable = Pitty_SortTableDescending(QHPlayers, 3);
	local playername, healed, count;
	local playersFound = table.getn(sortedTable);
	for n=1, playersFound, 1 do
		playername = QHPlayers[n][1];
		count = QHPlayers[n][2];
		healed = QHPlayers[n][3];
			
		customEcho(channel, string.format(QH_HEALED, n, playername, healed, math.floor(healed / count) ));
	end
	
	if playersFound == 0 then
		customEcho(channel, QH_NOTFOUND);
	end
end


function Pitty_ShowHelp()
	gEcho(string.format(PITTY_OPT, GetAddOnMetadata("Pitty", "Version")));
	gEcho(HELP_1);
	gEcho(HELP_2);
	gEcho(HELP_3);
	gEcho(HELP_4);
	gEcho(HELP_5);
	gEcho(HELP_6);
	gEcho(HELP_7);
	gEcho(HELP_8);
	gEcho(HELP_9);
	gEcho(HELP_10);
end


function Pitty_IsInParty()
	if not Pitty_IsInRaid() then
		return ( GetNumPartyMembers() > 0 );
	end
	return false
end

function Pitty_IsInRaid()
	return ( GetNumRaidMembers() > 0 );
end

function Pitty_SortTableDescending(sourcetable, index)
	local doSort = true
	while doSort do
		doSort = false
		for n=1,table.getn(sourcetable) - 1, 1 do
			local a = sourcetable[n]
			local b = sourcetable[n + 1]
			if (a[index]) < (b[index]) then
				sourcetable[n] = b
				sourcetable[n + 1] = a
				doSort = true
			end
		end
	end
	return sourcetable;
end





--[[
	Respond to a TX_VERSION command.
	Input:
		msg is the raw message
		sender is the name of the message sender.
	We should whisper this guy back with our current version number.
	We therefore generate a response back (RX) in raid with the syntax:
	Pitty:<sender (which is actually the receiver!)>:<version number>
]]
local function HandleTXVersion(message, sender)
	local response = GetAddOnMetadata("Pitty", "Version")	
	addonEcho("RX_VERSION#"..response.."#"..sender)
end

--[[
	A version response (RX) was received. The version information is displayed locally.
]]
local function HandleRXVersion(message, sender)
	gEcho(string.format(USING_VER, sender, message))
end







local function Pitty_OnChatMsgAddon(event, prefix, msg, channel, sender)
    if prefix == "Panza" or prefix == "QuickHeal" or prefix == "Heart" or prefix == "Genesis" then
		--echo(string.format("QH: %s > %s", sender, msg));
	    local _, _, status, target, healed, hot, timeleft = string.find(msg, "^(.+), (.+), .+, (%d+%.?%d*), (%d+%.?%d*), %d+%.?%d*, (%d+%.?%d*)");
		if status == "Update" then		
			Pitty_RegisterQHeal(sender, healed);
		end
    end
    
	if prefix == PITTY_MESSAGE_PREFIX then
		Pitty_HandlePittyMessage(msg, sender);	
	end
end

function Pitty_HandlePittyMessage(msg, sender)
	--echo(sender.." --> "..msg);

	local _, _, cmd, message, recipient = string.find(msg, "([^#]*)#([^#]*)#([^#]*)");	
	--	Ignore message if it is not for me. Receipient can be blank, which means it is for everyone.
	if not (recipient == "") then
		if not (recipient == UnitName("player")) then
			return
		end
	end

	if cmd == "TX_VERSION" then
		HandleTXVersion(message, sender)
	elseif cmd == "RX_VERSION" then
		HandleRXVersion(message, sender)
	end
	
end



--
--	Events
--
function Pitty_OnEvent(event, arg1, arg2, arg3, arg4, arg5)
	if (event == "CHAT_MSG_ADDON") then
		Pitty_OnChatMsgAddon(event, arg1, arg2, arg3, arg4, arg5)
	end	
end



function Pitty_OnLoad()
	gEcho(PITTY_V .. GetAddOnMetadata("PiTTY", "Version") .. " by ".. GetAddOnMetadata("PiTTY", "Author"))

  this:RegisterEvent("CHAT_MSG_ADDON")    
end
