SMODS.Atlas({
    key = 'tags', path = 'Tags.png',
    px = 34, py = 34
})

local tag_complete = function(tag, custom_msg, custom_colour)
    tag:yep(custom_msg or '+', custom_colour or G.C.GREEN,function() 
        return true
    end)
    tag.triggered = true
end

Monarchy.Tag = SMODS.Tag:extend({
    atlas = 'monarchy_tags',
    pos = {x = 0, y= 0},
    unlocked = true,
	discovered = true,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions.Tag, self.key,
            G.localization.descriptions.Tag[self.key] or self.loc_txt or {
                name = {'{C:inactive}#1#'}, text = {'{C:inactive}This Tag has not got','{C:inactive}a localization entry'}
            })
    end,
    loc_vars = function(self, info, card)
        return {vars = {self.original_key}}
    end
})

Monarchy.Tag({
    key = 'sparkle',
    config = {type = 'immediate', extra = {amount = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.config.extra.amount}}
    end,
    apply = function(self, tag, context)
        if context.type == tag.config.type then
            if G.blind_select and not G.blind_select.alignment.offset.py then
                G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
                G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
            end
            G.deck:shuffle()
            for i = 1, tag.config.extra.amount do
                draw_card(G.deck, G.play)
            end
            tag_complete(tag)
            delay(1)
            for i = 1, tag.config.extra.amount do
                local key = SMODS.poll_enhancement({key = 'monarchy_sparkle_tag', guaranteed = true})
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.play.cards[i]:juice_up()
                        G.play.cards[i]:set_ability(key)
                        SMODS.calculate_effect({message = localize({set = 'Enhanced', key = key, type = 'name_text'}), instant = true}, G.play.cards[i])
                        return true
                    end
                }))
                delay(1)
            end
            delay(1)
            for i = 1, tag.config.extra.amount do
                draw_card(G.play, G.deck)
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.3,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.3,
                        func = function()
                            if G.blind_select and G.blind_select.alignment.offset.py then
                                G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.py
                                G.blind_select.alignment.offset.py = nil
                            end
                            return true
                        end
                    }))
                    return true
                end
            }))
        end
    end
})

Monarchy.Tag({
    key = 'lightning',
    pos = {x = 1, y = 0},
    config = {type = 'monarchy_tag_repetition', extra = {repetitions = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.config.extra.repetitions}}
    end,
    apply = function(self, tag, context)
        if context.type == tag.config.type and G.GAME.current_round.hands_played == 0 then
            if context.last then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        tag_complete(tag)
                        return true
                    end
                }))
            end
            return {
                repetitions = tag.config.extra.repetitions,
                juice_card = tag
            }
        end
    end
})

Monarchy.Tag({
    key = 'meal_deal',
    pos = {x = 2, y = 0},
    config = {type = 'immediate', extra = {pool = 'food', amount = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.config.extra.amount}}
    end,
    apply = function(self, tag, context)
        if context.type == tag.config.type then
            for i=1, math.min(tag.config.extra.amount, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)) do
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = i>1 and 0.7 or 0,
                    func = function()
                        local c = SMODS.add_card({attributes = {tag.config.extra.pool}})
                        c:start_materialize()
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        return true
                    end
                }))
            end
            tag_complete(tag)
        end
    end
})