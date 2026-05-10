Monarchy.Joker({
    key = "gold_cables",
    pos = {x = 0, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {enhancement = 'm_gold', retriggers = 1}},
    attributes = {'enhancements', 'retrigger'},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Enhanced', key = card.ability.extra.enhancement, type = 'name_text'}), card.ability.extra.retriggers}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            for i, c in ipairs(context.full_hand) do
                if c == context.other_card then
                    if (context.full_hand[i-1] and SMODS.has_enhancement(context.full_hand[i-1], card.ability.extra.enhancement)) or (context.full_hand[i+1] and SMODS.has_enhancement(context.full_hand[i+1], card.ability.extra.enhancement)) then
                        return {
                            repetitions = card.ability.extra.retriggers
                        }
                    end
                end
            end
        end
    end,
})