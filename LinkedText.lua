URL_PATTERNS = { 
    ".+%..+/.*",
    ".+%..+"
}

function formatURL(url)
    url = "|cff".."149bfd".."|Hurl:"..url.."|h["..url.."]|h|r ";
    return url;
end

function makeClickable(self, event, msg, ...)
    local newmsg = ""
    for word in msg:gmatch("%S+") do
        local foundLink = false
        for k,p in pairs(URL_PATTERNS) do
            if string.find(word, p) and foundLink == false then
                word = string.gsub(word, p, formatURL("%1"))
                foundLink = true
            end
        end
        newmsg = newmsg .. " " .. word
    end
    msg = newmsg
    return false, msg, ...
end

StaticPopupDialogs["CLICK_LINK_CLICKURL"] = {
    text = "Copy & Paste the link into your browser",
    button1 = "Close",
    OnAccept = function()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, 
    OnShow = 
        function (self, data)
            self.editBox:SetText(data.url)
            self.editBox:HighlightText()
        end,
    hasEditBox = true
}

local SetItemRef_orig = SetItemRef;
function ClickURL_SetItemRef(link, text, button)
    if (string.sub(link, 1, 3) == "url") then
        local url = string.sub(link, 5);
        local d = {}
        d.url = url
        StaticPopup_Show("CLICK_LINK_CLICKURL", "", "", d)
    else
        SetItemRef_orig(link, text, button);
    end
end
SetItemRef = ClickURL_SetItemRef;

local CHAT_TYPES = {
    "AFK",
    "BATTLEGROUND_LEADER",
    "BATTLEGROUND",
    "BN_WHISPER",
    "BN_WHISPER_INFORM",
    "CHANNEL",
    "COMMUNITIES_CHANNEL",
    "DND",
    "EMOTE",
    "GUILD",
    "OFFICER",
    "PARTY_LEADER",
    "PARTY",
    "RAID_LEADER",
    "RAID_WARNING",
    "RAID",
    "SAY",
    "WHISPER",
    "WHISPER_INFORM",
    "YELL",
    "SYSTEM"
}

for _, type in pairs(CHAT_TYPES) do
    ChatFrame_AddMessageEventFilter("CHAT_MSG_" .. type, makeClickable)
end
-- https://riptutorial.com/lua/example/20315/lua-pattern-matching luas pattern matching.