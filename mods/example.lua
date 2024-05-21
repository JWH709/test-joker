local mod_id = "j_evenkeegan_fortress"
local mod_name = "Even Keegan"
local mod_version = "1.0"
local mod_author = "fortress"

local function jokerEffect(card, context)
    if card.ability.name == 'Even Keegan' and context.cardarea == G.jokers and not context.before and not context.after and
        context.full_hand and #context.full_hand >= 1 then
        local evens = 0
        for i = 1, #context.full_hand do
            if context.full_hand[i].base.id == 2 or 4 or 6 or 8 or 10 then
                evens = evens + 1
            end
        end
        return {
            message = localize {
                type = 'variable',
                key = 'a_xmult',
                vars = {card.ability.extra.Xmult}
            },
            Xmult_mod = card.ability.extra.Xmult * evens
        }
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
                Xmult = 1
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
