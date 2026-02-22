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