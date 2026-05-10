-- TODO: Atlas for blinds

SMODS.Atlas({
    key = 'blind',
    path = 'BlindChips.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34, py = 34
})

SMODS.Blind({
    key = 'slate',
    atlas = 'blind',
    pos = {x = 0, y = 3},
    dollars = 5,
    mult = 2,
    boss = {min = 4},
    boss_colour = HEX('D8CABA'),
    calculate = function(self, card, context)
        if context.blind_disabled or context.blind_defeated then
            Monarchy.Functions.undebuff('monarchy_slate')
        end
        if card.disabled then return end
        if context.debuff_card and context.debuff_card.ability.set == 'Enhanced' then
            context.debuff_card.ability.debuffed_by = 'monarchy_slate'
            return {
                debuff = true
            }
        end
    end
})

SMODS.Blind({
    key = 'underdog',
    atlas = 'blind',
    pos = {x = 0, y = 5},
    dollars = 5,
    mult = 2,
    boss = {min = 4, max = 8},
    config = {extra = {played_limit = 10}},
    boss_colour = HEX('FFC46B'),
    loc_vars = function(self)
        return {vars = {self.config.extra.played_limit}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.played_limit}}
    end,
    calculate = function(self, card, context)
        if context.blind_disabled or context.blind_defeated then
            Monarchy.Functions.undebuff('monarchy_underdog')
        end
        if card.disabled then return end
        if context.debuff_card and context.debuff_card.base.times_played >= card.effect.extra.played_limit then
            context.debuff_card.ability.debuffed_by = 'monarchy_underdog'
            return {
                debuff = true
            }
        end
    end
})

SMODS.Blind({
    key = 'anchor',
    atlas = 'blind',
    pos = {x = 0, y = 6},
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = HEX('78C7BA'),
    calculate = function(self, card, context)
        if context.blind_disabled or context.blind_defeated then
            for _, card in ipairs(G.playing_cards) do
                if card.ability.flipped_by == 'monarchy_anchor' then 
                    card:flip()
                    card.ability.flipped_by = nil
                end
            end
        end
        if card.disabled then return end
        if context.stay_flipped and context.from_area == G.deck and #G.deck.cards <= math.floor(#G.playing_cards/2) then
            context.other_card.ability.flipped_by = 'monarchy_anchor'
            return {
                stay_flipped = true
            }
        end
    end
})

SMODS.Blind({
    key = 'blur',
    atlas = 'blind',
    pos = {x = 0, y = 4},
    dollars = 5,
    mult = 2,
    boss = {min = 6},
    boss_colour = HEX('8EBEE0'),
    config = {extra = {scale = 0.5}},
    in_pool = function()
        return G.GAME.skips > 0
    end,
    calculate = function(self, card, context)
        if context.blind_disabled and card.effect.extra.scale_amount then
            local ret = {
                blindsize = -card.effect.extra.scale_amount,
                colour = self.boss_colour,
                message_card = G.play
            }
            for i=1, G.GAME.skips - 1 do
                SMODS.merge_effects({ret, {
                    blindsize = -card.effect.extra.scale_amount,
                    colour = self.boss_colour,
                    message_card = G.play
                }})
            end
            return ret
        end
        if card.disabled then return end
        if context.first_hand_drawn then
            card.effect.extra.scale_amount = card.chips * card.effect.extra.scale
            local ret = {
                blindsize = card.effect.extra.scale_amount,
                colour = self.boss_colour,
                message_card = G.play,
            }
            for i=1, G.GAME.skips - 1 do
                SMODS.merge_effects({ret, {
                    blindsize = card.effect.extra.scale_amount,
                    colour = self.boss_colour,
                    message_card = G.play,
                }})
            end
            return ret
        end
    end
})

SMODS.Blind({
    key = 'loop',
    atlas = 'blind',
    pos = {x = 0, y = 2},
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = HEX('E05273'),
    config = {extra = {denom = 6}},
    loc_vars = function(self)
        local num, denom = SMODS.get_probability_vars(self, 1, self.config.extra.denom)
        return {vars = {num, denom}}
    end,
    collection_loc_vars = function(self)
        return {vars = {1, self.config.extra.denom}}
    end,
    calculate = function(self, card, context)
        if context.blind_disabled or context.blind_defeated then
            Monarchy.Functions.undebuff('monarchy_loop')
        end
        if card.disabled then return end
        if context.debuff_card and context.debuff_card.debuffed_by == 'monarchy_loop' then
            return {
                debuff = true
            }
        end
        if context.stay_flipped and context.to_area == G.discard then
            if SMODS.pseudorandom_probability(card, 'monarchy_loop', 1, card.effect.extra.denom) then
                context.other_card:set_debuff(true)
                context.other_card.debuffed_by = 'monarchy_loop'
                return {
                    modify = {to_area = G.hand}
                }
            end
        end
    end
})