Deck_1 = Deck:extend()

function Deck_1:new(x,y,width,height,hidden_cards)
    Deck_1.super.new(self,x,y,width,height)
    self.hidden_cards_1 = hidden_cards
    self.hidden_cards_2 = {}
end

function Deck_1:draw(spritesheet,card_back)
    if #self.hidden_cards_1 > 0 then
        love.graphics.draw(spritesheet,card_back,self.x,self.y)
    else
        love.graphics.circle("line",self.x + self.width/2,self.y + self.height/2,20)
    end
    local x = self.x + self.width + 20
    if #self.card_table > 0 then
        for i = 1, #self.card_table do
            love.graphics.draw(spritesheet,self.card_table[i].quad,x + 20 * (i-1),self.y)
        end
    end
end

function Deck_1:is_mouse_on_back_card(x,y)
    local left = self.x
    local right = self.x + self.width
    local top = self.y
    local bottom = self.y + self.height
    
    if left < x and right > x and top < y and bottom > y then
        return true
    else
        return false
    end
end

function Deck_1:get_playing_card_position()
    local x = self.x + self.width + 20 + (#self.card_table - 1) * 20
    local y = self.y
    
    return x,y
end

function Deck_1:is_mouse_over(x,y)
    local pos_x,pos_y = self:get_playing_card_position()
    local left = pos_x
    local right = pos_x + self.width
    local top = pos_y
    local bottom = pos_y + self.height
    
    if left < x and right > x and top < y and bottom > y then
        return true
    else
        return false
    end
end

function Deck_1:get_selected_card()
    return {table.remove(self.card_table)}
end

function Deck_1:mousepressed(x,y)
    if self:is_mouse_on_back_card(x,y) then
        if #self.card_table > 0 then
            for i = 1, #self.card_table do
                table.insert(self.hidden_cards_2,1,table.remove(self.card_table))
            end
        end
        if #self.hidden_cards_1 > 3 then
            for i = 1, 3 do
                table.insert(self.card_table,1,table.remove(self.hidden_cards_1))
            end
        elseif #self.hidden_cards_1 > 0 then
            for i = 1, #self.hidden_cards_1 do
                table.insert(self.card_table,1,table.remove(self.hidden_cards_1))
            end
        else
            self.hidden_cards_1 = self.hidden_cards_2
            self.hidden_cards_2 = {}
        end
    end
end