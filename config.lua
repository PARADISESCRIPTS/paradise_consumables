Config = {}

Config.Debug = true -- Set to false in production
Config.UseOxProgressBar = true -- Set to false to use QB progressbar
Config.UseOxNotification = true -- Set to false to use QB notifications

Config.Notifications = {
    ItemUsed = {
        title = "Item Used",
        description = "You used %s",
        type = "success",
        duration = 3000
    },
    ItemRemoved = {
        title = "Item Removed",
        description = "Removed 1x %s",
        type = "inform",
        duration = 3000
    },
    CantUse = {
        title = "Can't Use",
        description = "You can't use this item right now",
        type = "error",
        duration = 3000
    },
    NoItem = {
        title = "Missing Item",
        description = "You don't have this item",
        type = "error",
        duration = 3000
    }
}

Config.Consumables = {
    ['paradiseburger'] = {
        label = 'Burgerr',
        type = 'food',
        progress = {
            duration = 5000,
            label = 'Eating Burgerr...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mp_player_inteat@burger',
                clip = 'mp_player_int_eat_burger',
                flag = 49,
            },
            prop = {
                model = `prop_sandwich_01`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            hunger = 35,
            stress = -10,
            heal = 5,
        },
        removeOnUse = true,
    },
    ['paradisewater'] = {
        label = 'Water Bottle',
        type = 'drink',
        progress = {
            duration = 3000,
            label = 'Drinking water...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
                flag = 49,
            },
            prop = {
                model = `prop_ld_flow_bottle`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 35,
            stress = -5,
        },
        removeOnUse = true,
    },
    ['energydrink'] = {
        label = 'Energy Drink',
        type = 'drink',
        removeOnUse = true,
        progress = {
            duration = 3000,
            label = 'Drinking energy drink...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
                flag = 49,
            },
            prop = {
                model = `prop_ld_can_01`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 25,
            stress = -10,
        },
        stats = {
            screen = "weed",     -- Screen effect to be played
            effect = "armor",     -- Status effect: "heal" or "stamina"
            time = 30000,           -- Effect duration in ms
            amount = 2,             -- Amount to increase per second
        },
    }
}
