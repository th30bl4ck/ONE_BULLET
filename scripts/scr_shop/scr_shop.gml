function scr_shop(_cost)
{
    if (!variable_global_exists("coins")) {
        global.coins = 0;
    }

    if (global.coins >= _cost) {
        global.coins -= _cost;
    
    
    if (variable_instance_exists(id,"shop_item_slot")){
        switch (shop_item_slot){
            case 1: global.shop_item_1 = -1; break;
            case 2: global.shop_item_2 = -1; break;
            case 3: global.shop_item_3 = -1; break;
            case 4: global.shop_item_4 = -1; break;
            case 5: global.shop_item_5 = -1; break;
            case 6: global.shop_item_6 = -1; break;
            case 7: global.shop_item_7 = -1; break;
            case 8: global.shop_item_8 = -1; break; 
        }
    }
        return true;
    }
    
    return false;
}