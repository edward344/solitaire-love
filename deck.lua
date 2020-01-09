Deck = Object:extend()

function Deck:new(x,y,width,height,card_table)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.card_table = card_table or {}
end

function Deck:add_cards(cards)
    for i = 1, #cards do
        table.insert(self.card_table,cards[i])
    end
end
