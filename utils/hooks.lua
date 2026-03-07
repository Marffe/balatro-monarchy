Monarchy.Hooks = {}


Monarchy.Hooks.card_click = Card.click
function Card:click()
    if self.ability.goosed and not self.highlighted then
        play_sound('monarchy_goose')
    end
    if self.ability.monarchy_anchor and not self.highlighted then
        for _, joker in pairs(SMODS.find_card('j_monarchy_anchor')) do
            juice_card(joker)
        end
    end
    Monarchy.Hooks.card_click(self)
end

Monarchy.Hooks.smods_calculate_repetitions = SMODS.calculate_repetitions
function SMODS.calculate_repetitions(card, context, reps)
    Monarchy.Hooks.smods_calculate_repetitions(card, context, reps)
    for i = 1, #G.GAME.tags do
        local eval = G.GAME.tags[i]:apply_to_run({type = 'monarchy_tag_repetition', last = card == (context.scoring_hand and context.scoring_hand[#context.scoring_hand])})
        if eval and next(eval) then 
            eval.message_card = card
            SMODS.insert_repetitions(reps, eval, card)
        end
    end
end

Monarchy.Hooks.tag_juice = Tag.juice_up
function Tag:juice_up(_scale, _rot)
    if self.config.type == 'monarchy_tag_repetition' then
        _scale = 0.5
    end
    Monarchy.Hooks.tag_juice(self, _scale, _rot)
end