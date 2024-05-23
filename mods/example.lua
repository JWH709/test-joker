local mod_id = "j_evenkeegan_fortress"
local mod_name = "Even Keegan"
local mod_version = "1.0"
local mod_author = "fortress"

local function jokerEffect(card, context)
    if card.ability.name == 'Even Keegan' and context.individual and context.cardarea == G.play then
        if context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id() % 2 ==
            0 then
            return {
                x_mult = 2,
                card = card
            }
        end
    end
end
table.insert(mods, {
    mod_id = mod_id,
    name = mod_name,
    version = mod_version,
    author = mod_author,
    enabled = true,
    on_enable = function()
        centerHook.addJoker(self, 'j_evenkeegan_fortress', -- id
        'Even Keegan', -- name
        jokerEffect, -- effect function
        nil, -- order
        true, -- unlocked
        true, -- discovered
        6, -- cost
        {
            x = 0,
            y = 0
        }, -- sprite position
        nil, -- internal effect description
        {
            extra = {
                x_mult = 2
            }
        }, -- config
        {"{Even cards give", "{C:red}X2{} Mult"}, -- description text
        3, -- rarity
        true, -- blueprint compatibility
        true, -- eternal compatibility
        nil, -- exclusion pool flag
        nil, -- inclusion pool flag
        nil, -- unlock condition
        true, -- collection alert
        "pack", -- sprite path
        "even_keegan.png", -- sprite name
        {
            px = 71,
            py = 95
        } -- sprite size
        )
    end,
    on_disable = function()
        centerHook.removeJoker(self, "j_evenkeegan_fortress")
    end
})

