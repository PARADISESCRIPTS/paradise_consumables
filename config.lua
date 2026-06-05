Config = {}

Config.Debug = false -- Set to false in production
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
    ['vodka'] = {
        label = 'Vodka',
        type = 'alcohol',
        removeOnUse = true,
        notify = {
            title = "Cheers",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking vodka...',
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
                model = `prop_vodka_bottle`,
                pos = vec3(0.0, -0.26, 0.10),
                rot = vec3(240.0, -60.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 15,
        },
        stats = {
            effect = "stress",
            time = 5000,
            amount = 2,
        },
    },
    ['casino_beer'] = {
        label = 'Casino Beer',
        type = 'alcohol',
        removeOnUse = true,
        notify = {
            title = "Cheers",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking beer...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_drinking@beer@male@idle_a',
                clip = 'idle_c',
                flag = 49,
            },
            prop = {
                model = `prop_amb_beer_bottle`,
                pos = vec3(0.0, 0.0, 0.06),
                rot = vec3(0.0, 15.0, 0.0),
                bone = 28422,
            },
        },
        effects = {
            thirst = 15,
            stress = -3,
        },
    },
    ['whiskey'] = {
        label = 'Whiskey',
        type = 'alcohol',
        removeOnUse = true,
        notify = {
            title = "Cheers",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking whiskey...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_drinking@coffee@male@idle_a',
                clip = 'idle_c',
                flag = 49,
            },
            prop = {
                model = `prop_drink_whisky`,
                pos = vec3(0.01, -0.01, -0.06),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 28422,
            },
        },
        effects = {
            thirst = 15,
            stress = -3,
        },
    },
    ['sandwich'] = {
        label = 'Sandwich',
        type = 'food',
        removeOnUse = true,
        notify = {
            title = "Yummy",
            description = "You enjoyed %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Eating sandwich...',
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
                pos = vec3(0.13, 0.05, 0.02),
                rot = vec3(-50.0, 16.0, 60.0),
                bone = 18905,
            },
        },
        effects = {
            hunger = 20,
        },
    },
    ['burger'] = {
        label = 'Burger',
        type = 'food',
        removeOnUse = true,
        notify = {
            title = "Yummy",
            description = "You enjoyed %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Eating burger...',
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
                model = `prop_cs_burger_01`,
                pos = vec3(0.13, 0.05, 0.02),
                rot = vec3(-50.0, 16.0, 60.0),
                bone = 18905,
            },
        },
        effects = {
            hunger = 20,
        },
    },
    ['nachos'] = {
        label = 'Nachos',
        type = 'food',
        removeOnUse = true,
        notify = {
            title = "Yummy",
            description = "You enjoyed %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Eating nachos...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_drinking@coffee@male@idle_a',
                clip = 'idle_c',
                flag = 49,
            },
            prop = {
                model = `v_ret_ml_chips2`,
                pos = vec3(0.01, -0.05, -0.1),
                rot = vec3(0.0, 0.0, 90.0),
                bone = 28422,
            },
        },
        effects = {
            hunger = 20,
        },
    },
    ['twerks_candy'] = {
        label = 'Twerks Candy',
        type = 'food',
        removeOnUse = true,
        notify = {
            title = "Sweet",
            description = "You ate %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Eating candy...',
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
                model = `prop_choc_ego`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 60309,
            },
        },
        effects = {
            hunger = 12,
        },
    },
    ['snikkel_candy'] = {
        label = 'Snikkel Candy',
        type = 'food',
        removeOnUse = true,
        notify = {
            title = "Sweet",
            description = "You ate %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Eating candy...',
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
                model = `prop_choc_ego`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 60309,
            },
        },
        effects = {
            hunger = 12,
        },
    },
    ['coffee'] = {
        label = 'Coffee',
        type = 'drink',
        removeOnUse = true,
        notify = {
            title = "Refreshed",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking coffee...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_drinking@coffee@male@idle_a',
                clip = 'idle_c',
                flag = 49,
            },
            prop = {
                model = `p_amb_coffeecup_01`,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                bone = 28422,
            },
        },
        effects = {
            thirst = 25,
        },
        stats = {
            time = 10000,
        },
    },
    ['cola'] = {
        label = 'Cola',
        type = 'drink',
        removeOnUse = true,
        notify = {
            title = "Refreshed",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking cola...',
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
                model = `prop_ecola_can`,
                pos = vec3(0.12, 0.008, 0.03),
                rot = vec3(240.0, -60.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 15,
            stress = -3,
        },
    },
    ['sprunk'] = {
        label = 'Sprunk',
        type = 'drink',
        removeOnUse = true,
        notify = {
            title = "Refreshed",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Drinking sprunk...',
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
                model = `v_res_tt_can03`,
                pos = vec3(0.12, 0.008, 0.03),
                rot = vec3(240.0, -60.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 15,
            stress = -3,
        },
    },
    ['water'] = {
        label = 'Water',
        type = 'drink',
        removeOnUse = true,
        notify = {
            title = "Refreshed",
            description = "You drank %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
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
                pos = vec3(0.12, 0.008, 0.03),
                rot = vec3(240.0, -60.0, 0.0),
                bone = 18905,
            },
        },
        effects = {
            thirst = 15,
            stress = -3,
        },
    },
    ['oxy'] = {
        label = 'Oxy',
        type = 'drug',
        removeOnUse = true,
        notify = {
            title = "Relief",
            description = "You took %s",
            type = "success",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Taking oxy...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mp_suicide',
                clip = 'pill',
                flag = 49,
            },
        },
        effects = {
            stress = -18,
        },
        stats = {
            effect = "heal",
        },
    },
    ['joint'] = {
        label = 'Joint',
        type = 'drug',
        removeOnUse = true,
        notify = {
            title = "Smoke Break",
            description = "You smoked a %s",
            type = "inform",
            duration = 2500
        },
        progress = {
            duration = 5500,
            label = 'Smoking joint...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_smoking@male@male_a@enter',
                clip = 'enter',
                flag = 49,
            },
            prop = {
                model = `p_cs_joint_02`,
                pos = vec3(0.015, -0.009, 0.003),
                rot = vec3(55.0, 0.0, 110.0),
                bone = 47419,
            },
        },
        effects = {
            stress = -18,
        },
        stats = {
            screen = "weed",
            effect = "armor",
            time = 10000,
            amount = 1,
        },
    },
}
