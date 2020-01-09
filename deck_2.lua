Deck_2 = Deck:extend()

function Deck_2:new(x,y,width,height)
    Deck_2.super.new(self,x,y,width,height)
    self.suit = "none"
end

function Deck_2:draw(spritesheet)
    if #self.card_table > 0 then
        love.graphics.draw(spritesheet,self.card_table[#self.card_table].quad,self.x,self.y)
    else
        love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
    end
end

function Deck_2:is_mouse_over(x,y)
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

function Deck_2:set_rules(tb1)
    if #tb1 == 1 then
        if #self.card_table == 0 and tb1[1].number == 1 then
            self.suit = tb1[1].suit
            return true
        elseif tb1[1].suit == self.suit and tb1[1].number == (self.card_table[#self.card_table].number + 1) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Deck_2:get_position()
    return self.x,self.y
end

function Deck_2:get_selected_card()
    return {table.remove(self.card_table)}
end