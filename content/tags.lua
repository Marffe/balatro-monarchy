SMODS.Atlas({
    key = 'tags', path = 'Tags.png',
    px = 34, py = 34
})

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
    key = 'sparkle'
})

Monarchy.Tag({
    key = 'lightning',
    pos = {x = 1, y = 0},
})

Monarchy.Tag({
    key = 'meal_deal',
    pos = {x = 2, y = 0}
})