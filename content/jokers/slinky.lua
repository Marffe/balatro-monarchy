Monarchy.Joker({
    key = "slinky",
    pos = {x = 2, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {ranks = {'Ace','2','3','4','5','6'}, xmult = 1.5, odds = 6}},
    attributes = {'destroy_card', 'ace', 'two', 'three', 'four', 'five', 'six', 'rank', 'chance', 'xmult'},
    loc_vars = function(self, info_queue, card)
        local vars = {}
        for _, rank in ipairs(card.ability.extra.ranks) do
            table.insert(vars, localize(rank, 'ranks'))
        end
        table.insert(vars, card.ability.extra.xmult)
        local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'monarchy_slinky_break')
        table.insert(vars, num)
        table.insert(vars, denom)
        return {vars = vars}
    end,
    calculate = function(self, card, context)
        local function contains(table, value)
            for _, v in ipairs(table) do
                if v == value then return true end
            end
        end

        if context.individual and context.cardarea == G.play and contains(card.ability.extra.ranks, context.other_card.base.value) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.destroy_card and context.cardarea == G.play and contains(card.ability.extra.ranks, context.destroy_card.base.value) then
            if SMODS.pseudorandom_probability(card, 'monarchy_slinky_break', 1, card.ability.extra.odds) then
                return {
                    remove = true,
                    message = localize('monarchy_slinky'),
                    message_card = context.destroy_card,
                    juice_card = card
                }
            end
        end
    end,
})