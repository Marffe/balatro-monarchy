Monarchy.Joker({
    key = "private_eye",
    pos = {x = 8, y = 1},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    attributes = {'boss_blind', 'tag'},
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and context.beat_boss then
            Monarchy.Functions.add_tag(nil, 'monarchy_private_eye')
            return {
                message = localize('monarchy_tag_added')
            }
        end
    end,
})