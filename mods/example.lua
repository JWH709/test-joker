patchedAce = false
jokerHook = initJokerHook()

if sendDebugMessage == nil then
    sendDebugMessage = function(_)
    end
end

table.insert(mods, {
    mod_id = "flying_ace",
    name = "Flying Ace",
    version = "1.0",
    author = "JWH",
    description = "Aces have a 1 in 3 chance to give 2x mult",
    enabled = true,
    on_post_update = function()
        if not patchedAce then
            sendDebugMessage("Adding flying ace to centers!")

            jokerHook.addJoker(self, "j_flyingace", "Flying Ace", nil, true, 1, {
                x = 0,
                y = 0
            }, nil, {
                extra = 2
            }, {"Aces have a 1 in 3", "chance to give", "2x mult"}, 1, true, true)

            sendDebugMessage("Inserting flying_ace into calculate_joker!")

            local toReplaceLogic =
                "if self.ability.name == 'Bloodstone' and context.other_card:is_suit('Hearts') and pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then"

            local replacementLogic = [[
                if self.ability.name == 'Flying Ace' and context.other_card:get_id() == 14 and pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then
                    return {
                        x_mult = self.ability.extra.Xmult,
                        card = self
                    }
                end
            ]]

            inject("card.lua", "Card:calculate_joker", toReplaceLogic:gsub("([^%w])", "%%%1"), replacementLogic)

            ------------------------------------------
            sendDebugMessage("Adding texture file for flying ace!")

            local toReplaceAtlas =
                "{name = 'chips', path = \"resources/textures/\"..self.SETTINGS.GRAPHICS.texture_scaling..\"x/chips.png\",px=29,py=29}"

            local replacementAtlas = [[
                {name = 'chips', path = "resources/textures/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/chips.png",px=29,py=29},
                {name = 'flying_ace', path = "pack/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/flying_ace.png",px=71,py=95}
            ]]

            inject("game.lua", "Game:set_render_settings", toReplaceAtlas:gsub("([^%w])", "%%%1"), replacementAtlas)

            G:set_render_settings()

            -------------------------------------------------------
            sendDebugMessage("Adding sprite draw logic for flying ace!")

            local toReplaceTexLoad =
                "elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then"

            local replacementTexLoad = [[
                elseif _center.name == 'Flying Ace' then
                    self.children.center = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS['flying_ace'], j_flyingace)
                elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then
            ]]

            inject("card.lua", "Card:set_sprites", toReplaceTexLoad:gsub("([^%w])", "%%%1"), replacementTexLoad)

            -------------------------------------------------------

            patchedAce = true

            sendDebugMessage("Patched flying ace mod!")
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
