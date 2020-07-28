-- TODO: Custom message to send to player on click
-- TODO: Set up local storage for custome message and settings

local kwdArr = {};
local playSoundOption = "off";
local monitoring = false;

local RED = "|cFFFF4477";
local YELLOW = "|cFFFFFFAA";
local BLUE = "|cFF22AAFF";

local defaultChatID = DEFAULT_CHAT_FRAME:GetID();

print(RED .. "ChatObserver v0.4 loaded >>> " .. BLUE .. "Type /co for more options.")

-- Define chat commands
SLASH_PHRASE1 = "/co";
SLASH_PHRASE2 = "/chatobserver";
SlashCmdList["PHRASE"] = function(msg)
	-- lowercase everything to make it easier to work with
	msg = msg:lower()
	-- If no param given for command print options list
	if msg == "" then 
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co start" .. RED .. " or " .. YELLOW .. "/co stop " .. RED .."to start/stop monitoring for keywords from watchlist")
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co add <keyword> " .. RED .."to add one or more words to watchlist (fx /co add UBRS or /co add UBRS Strat Scholo Dm)")
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co remove <keyword> " .. RED .."to remove word from watchlist (fx /co remove UBRS)")
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co clear " .. RED .."to clear watchlist")
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co list " .. RED .."to list keywords in watchlist")
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co sound on" .. RED .. " or " .. YELLOW .. "/co sound off " .. RED .." to turn notification sound on/off")
		return
	end

	if msg == "clear" then 
		kwdArr = {}
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Watchlist has been cleared")
		if monitoring == true then
			monitoring = false
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Monitoring has been turned" .. YELLOW .. " off")
		end
		return;
	end

	if msg == "list" then
		local outStr = "";
		if #kwdArr == 0 then
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Watchlist is " .. YELLOW .. "empty")
		else
			for i = 1,#kwdArr do
				if i == #kwdArr then
					outStr = outStr .. YELLOW .. kwdArr[i]
				else
					outStr = outStr .. YELLOW .. kwdArr[i] .. RED .. ", "
				end
			end
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Current watchlist: " .. YELLOW .. outStr)
		end
		return
	end

	if msg == "start" then
		if #kwdArr == 0 then
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Watchlist is " .. YELLOW .. "empty. " .. RED .. "Monitoring not started")
		else
			monitoring = true
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Monitoring has been turned" .. YELLOW .. " on")
		end
		return
	end

	if msg == "stop" then
		monitoring = false
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Monitoring has been turned" .. YELLOW .. " off")
		return
	end

	if msg == "sound" then
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co sound on" .. RED .. " or " .. YELLOW .. "/co sound off " .. RED .." to turn notification sound on/off")
		return
	end

	if msg == "add" then
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co add <keyword> " .. RED .."to add word to watchlist (fx /co add UBRS)")
		return
	end

	if msg == "remove" then
		SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co remove <keyword> " .. RED .."to remove word from watchlist (fx /co remove UBRS)")
		return
	end

	-- Handle everything else as a split string with index 1 as command and index 2 as param
	local splitMsg = {}
	for word in msg:gmatch "%w+" do table.insert(splitMsg, word) end
	if table.getn(splitMsg) > 1 then 
		-- Turn sound on/off
		if splitMsg[1] == "sound" then
			if splitMsg[2] == "on" then 
				playSoundOption = "on" 
				SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Sound" .. YELLOW .. " enabled " .. RED .."for all alerts")
				return
			elseif splitMsg[2] == "off" then
				playSoundOption = "off"
				SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Sound" .. YELLOW .. " disabled " .. RED .."for all alerts")
				return
			else
				SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Type " .. YELLOW .. "/co sound on" .. RED .. " or " .. YELLOW .. "/co sound off " .. RED .." to turn notification sound on/off")
				return
			end 
		end

		-- Add / Remove Keywords to match
		if splitMsg[1] == "add" then
			local outStr = ""
			for i = 2,#splitMsg do
				table.insert(kwdArr, splitMsg[i])
				outStr = outStr .. YELLOW .. splitMsg[i]
				if i < #splitMsg then
					outStr = outStr .. RED .. ", "
				end 
			end
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Added keyword(s) " .. outStr .. RED .. " to watchlist")
			if monitoring == false then
				monitoring = true
				SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Monitoring has been turned" .. YELLOW .. " on")
			end
			return
		end

		if splitMsg[1] == "remove" then
			for i = #kwdArr,1,-1 do
				if kwdArr[i] == splitMsg[2] then
					table.remove(kwdArr, i)
					SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Removed " .. YELLOW .. splitMsg[2] .. RED .. " from watchlist")
					return
				end 
			end
			SELECTED_CHAT_FRAME:AddMessage(RED .. " >>> Keyword " .. YELLOW .. splitMsg[2] .. RED .. " not found in watchlist")
			return
		end
	end
end

local f = CreateFrame("Frame")

f:RegisterEvent("CHAT_MSG_CHANNEL")
f:SetScript("OnEvent", function(self, event, message, sender, lang, channel, player2, flags, chanID, chanIndex, chanBaseName, _, lineID, guid, ...)
	if monitoring == false then
		return
	end
	if #kwdArr == 0 then
		return
	end

	for i = 1,#kwdArr do
		if chanID == 24 or 1 or 2 then
			local senderSplit =  string.match(sender, "^(.*)-")
			if senderSplit ~= nil then
				sender = senderSplit
			end
			local _, class = GetPlayerInfoByGUID(guid)
			local _,_,_, classColor = GetClassColor(class)
			local msgStr = RED .. " **CO Match** " .. YELLOW .. "|c" .. classColor .."|Hplayer:" .. sender .. "|h<" .. sender .. ">|h " .. BLUE .. message
			if message:lower():match(kwdArr[i]) then
				print(msgStr)
				if SELECTED_CHAT_FRAME:GetID() ~= defaultChatID then
					SELECTED_CHAT_FRAME:AddMessage(msgStr)
				end			
				if playSoundOption == "on" then
					PlaySoundFile("sound/doodad/pvp_rune_speedcustom0.ogg", "Master")
				end
				return
			end
		end
	end
end)