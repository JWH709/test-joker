patchedKeegan = false
jokerHook = initJokerHook()

if sendDebugMessage == nil then
    sendDebugMessage = function(_)
    end
end

------------------------------------------This section is for all of the joker logic

table.insert(mods, {
    mod_id = "even_keegan",
    name = "Even Keegan",
    version = "1.0",
    author = "JWH",
    description = "Even cards give 1.5x mult",
    enabled = true,
    on_post_update = function()
        if not patchedKeegan then

            --------------------------------------------------
            sendDebugMessage("Adding Even Keegan to centers!")

            jokerHook.addJoker(self, "j_evenKeegan", "Even Keegan", nil, true, 1, {
                x = 0,
                y = 0
            }, nil, {
                extra = 2
            }, {"Evens give", "{X:red,C:white} X1.5 {} Mult"}, 1, true, true)
            -----------------------------------------------------------------
            sendDebugMessage("Inserting even_keegan into calculate_joker!")

            local toReplaceLogic =
                "if self.ability.name == 'Even Steven' and context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 0 then"

            local replacementLogic = [[
                if self.ability.name == 'Even Keegan' and
                context.other_card:get_id() <= 10 and 
                context.other_card:get_id() >= 0 and
                context.other_card:get_id()%2 == 0
                then
                    return {
                        mult = self.ability.extra,
                        card = self
                    }
                end
            ]]

            inject("card.lua", "Card:calculate_joker", toReplaceLogic:gsub("([^%w])", "%%%1"), replacementLogic)

            ------------------------------------------ This is used to add art to the game
            sendDebugMessage("Adding texture file for Even Keegan!")

            local toReplaceAtlas =
                "{name = 'chips', path = \"resources/textures/\"..self.SETTINGS.GRAPHICS.texture_scaling..\"x/chips.png\",px=29,py=29}"

            local replacementAtlas = [[
                {name = 'chips', path = "resources/textures/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/chips.png",px=29,py=29},
                {name = 'even_keegan', path = "pack/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/even_keegan.png",px=71,py=95}
            ]]

            inject("game.lua", "Game:set_render_settings", toReplaceAtlas:gsub("([^%w])", "%%%1"), replacementAtlas)

            G:set_render_settings()

            ------------------------------------------------------- Not 100% sure what this does, but I think it has something to do with art
            sendDebugMessage("Adding sprite draw logic for Even Keegan!")

            local toReplaceTexLoad =
                "elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then"

            local replacementTexLoad = [[
                elseif _center.name == 'Even Keegan' then
                    self.children.center = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS['even_keegan'], j_evenKeegan)
                elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then
            ]]

            inject("card.lua", "Card:set_sprites", toReplaceTexLoad:gsub("([^%w])", "%%%1"), replacementTexLoad)

            -------------------------------------------------------

            patchedKeegan = true

            sendDebugMessage("Patched Even Keegan mod!")
        end
    end
})

-- if self.ability.name == 'Scholar' and
--                     context.other_card:get_id() == 14 then
--                         return {
--                             chips = self.ability.extra.chips,
--                             mult = self.ability.extra.mult,
--                             card = self
--                         }
--                     end

--                     if self.ability.name ==  'Bloodstone' and
--                 context.other_card:is_suit("Hearts") and 
--                 pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then
--                     return {
--                         x_mult = self.ability.extra.Xmult,
--                         card = self
--                     }
--                 end
