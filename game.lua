Game = Object:extend()

function Game:new()
    self.spritesheet = love.graphics.newImage("cards.png")
 
    self.cards = self:shuffle(self:get_cards_table(self.spritesheet))
    
    require "deck"
    require "deck_1"
    require "deck_2"
    require "deck_3"
    require "moving_card"
    
    self.deck_table = {}
    self.deck_table.deck_1 = {
        Deck_1(50,50,72,96,self:get_cards(24))
    }
    self.deck_table.deck_2 = {
        Deck_2(350,50,72,96),
        Deck_2(450,50,72,96),
        Deck_2(550,50,72,96),
        Deck_2(650,50,72,96)
    }
    self.deck_table.deck_3 = {
        Deck_3(50,200,72,96,self:get_cards(1)),
        Deck_3(150,200,72,96,self:get_cards(2)),
        Deck_3(250,200,72,96,self:get_cards(3)),
        Deck_3(350,200,72,96,self:get_cards(4)),
        Deck_3(450,200,72,96,self:get_cards(5)),
        Deck_3(550,200,72,96,self:get_cards(6)),
        Deck_3(650,200,72,96,self:get_cards(7))
    }   
    self.moving_card = Moving_card()
    -- get image of the back of one card
    self.card_back = love.graphics.newQuad(936,0,72,96,self.spritesheet:getDimensions())

end

function Game:get_cards(n)
    -- get n number of cards
    tb1 = {}
    for i = 1, n do
        table.insert(tb1,table.remove(self.cards))
    end
    
    return tb1
end

function Game:run_logic(dt)
    self.moving_card:update()
end

function Game:display_frame()
    -- set background color to green
    love.graphics.setBackgroundColor(0,0.5,0)
    
    self.deck_table.deck_1[1]:draw(self.spritesheet,self.card_back)
    
    for key,deck in pairs(self.deck_table.deck_2) do
        deck:draw(self.spritesheet)
    end
   
    for key,deck in pairs(self.deck_table.deck_3) do
        deck:draw(self.spritesheet,self.card_back)
    end
    
    self.moving_card:draw(self.spritesheet)
    
end

function Game:get_cards_table(spritesheet)
    -- return a table with all the playing cards
    local width = spritesheet:getWidth()
    local height = spritesheet:getHeight()
    
    local cards_table = {}
    
    local frame_width = 72
    local frame_height = 96
    
    local suits = {"clubs","spades","hearts","diamonds"}
    
    for i = 1, #suits do
        for j = 0, 12 do
            local tmp = love.graphics.newQuad(j * frame_width,(i-1) * frame_height,frame_width,frame_height,width,height)
            local card = {suit = suits[i], number = j + 1, quad = tmp}
            table.insert(cards_table,card)
        end
    end
    
    return cards_table
end

function Game:shuffle(tb1)
    for i = #tb1, 2, -1 do
        local j = love.math.random(1,i)
        tb1[i],tb1[j] = tb1[j],tb1[i]
    end
    return tb1
end

function Game:mousepressed(x,y)
    for key,deck in pairs(self.deck_table.deck_3) do
        if deck:is_mouse_button_down(x,y) then
            local index = deck:get_selected_index(x,y)
            self.moving_card.card_table = deck:get_selected_cards(index)
            local pos_x,pos_y = deck:get_position(index)
            self.moving_card:set_position(x,y,pos_x,pos_y)
            self.moving_card.key = key
            self.moving_card.class_name = "deck_3"
        end
    end
    
    for key,deck in pairs(self.deck_table.deck_2) do
        if deck:is_mouse_over(x,y) then
            self.moving_card.card_table = deck:get_selected_card()
            local pos_x,pos_y = deck:get_position()
            self.moving_card:set_position(x,y,pos_x,pos_y)
            self.moving_card.key = key
            self.moving_card.class_name = "deck_2"
        end
    end
    
    for key,deck in pairs(self.deck_table.deck_1) do
        deck:mousepressed(x,y)
        if deck:is_mouse_over(x,y) then
            local pos_x,pos_y = deck:get_playing_card_position()
            self.moving_card.card_table = deck:get_selected_card()
            self.moving_card:set_position(x,y,pos_x,pos_y)
            self.moving_card.key = key
            self.moving_card.class_name = "deck_1"
        end
    end
end

function Game:mousereleased(x,y)
    if not self.moving_card:is_empty() then
        local is_selected = false
        for key,deck in pairs(self.deck_table.deck_3) do
            if deck:is_mouse_button_up(x,y) and deck:set_rules(self.moving_card.card_table) then
                deck:add_cards(self.moving_card.card_table)
                self.moving_card.card_table = {}
                is_selected = true
            end
        end
        for key,deck in pairs(self.deck_table.deck_2) do
            if deck:is_mouse_over(x,y) and deck:set_rules(self.moving_card.card_table) then
                deck:add_cards(self.moving_card.card_table)
                self.moving_card.card_table = {}
                is_selected = true
            end
        end
        if is_selected then
            for key,deck in pairs(self.deck_table.deck_3) do
                deck:check_empty_card_table()
            end
        else
            self.deck_table[self.moving_card.class_name][self.moving_card.key]:add_cards(self.moving_card.card_table)
            self.moving_card.card_table = {}
        end
    end
end