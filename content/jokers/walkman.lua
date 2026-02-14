Monarchy.Joker({
    key = "walkman",
    pos = {x = 7, y = 3},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {after = 3, back = 1, current = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.after, card.ability.extra.back, card.ability.extra.current}}
    end,
    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            card.ability.extra.current = card.ability.extra.current + 1
            return {
                message = card.ability.extra.current > 0 and (card.ability.extra.current..'/'..card.ability.extra.after)
            }
        end
        if context.modify_ante and context.ante_end and card.ability.extra.current == (card.ability.extra.after - 1) then
            card.ability.extra.current = -1
            return {
                modify = -1 * card.ability.extra.back,
                message = localize('monarchy_walkman_ante_loss')
            }
        end
    end,
})