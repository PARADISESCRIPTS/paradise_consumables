# Paradise Consumables

A comprehensive consumables system for QBCore & QBOX servers that provides an easy way to add and manage consumable items with various effects, animations, and screen modifications.

## Features

- Support for both QB and OX progress bars and notifications
- Customizable animations and prop attachments
- Multiple effect types (health, hunger, thirst, stress)
- Screen effects and status modifications
- Easy-to-configure item system
- Debug mode for development
- Proper cleanup on resource stop

## Dependencies

- QBCore Framework & QBOX Framework
- ox_lib (optional - for progress bar and notifications)

## Installation

1. Place the resource in your server's resources folder
2. Add `ensure paradise_consumables` to your server.cfg
3. Configure your items in `config.lua`
4. Add items to your QB-Core shared items

## Configuration

### Basic Configuration

```lua
Config.Debug = true             -- Enable/disable debug messages
Config.UseOxProgressBar = true  -- Use ox_lib progress bar instead of QB
Config.UseOxNotification = true -- Use ox_lib notifications instead of QB
```

### Notification Configuration

Customize notification appearance and behavior:

```lua
Config.Notifications = {
    ItemUsed = {
        title = "Item Used",
        description = "You used %s",
        type = "success",
        duration = 3000
    },
    -- Additional notification types...
}
```

### Item Configuration

Items are configured in `Config.Consumables`. Each item can have the following properties:

```lua
['itemname'] = {
    label = 'Item Label',           -- Display name
    type = 'food',                  -- Item type (food/drink/alcohol/box/smoke)
    removeOnUse = true,            -- Remove item after use
    
    progress = {
        duration = 5000,           -- Duration in ms
        label = 'Using item...',   -- Progress bar label
        useWhileDead = false,      -- Can be used while dead
        canCancel = true,          -- Can cancel action
        disable = {
            move = false,          -- Disable movement
            car = true,            -- Disable car control
            combat = true,         -- Disable combat
        },
        anim = {
            dict = 'animation_dict',
            clip = 'animation_clip',
            flag = 49,
        },
        prop = {
            model = `prop_model`,
            pos = vec3(0.0, 0.0, 0.0),
            rot = vec3(0.0, 0.0, 0.0),
            bone = 18905,
        },
    },
    
    effects = {
        hunger = 35,              -- Hunger increase
        thirst = 25,             -- Thirst increase
        stress = -10,            -- Stress decrease
        heal = 5,                -- Health increase
    },
    
    stats = {
        screen = "weed",         -- Screen effect type
        effect = "armor",        -- Status effect type
        time = 30000,           -- Effect duration
        amount = 2,             -- Effect amount per tick
    },
}
```

## Available Screen Effects

- `alien`: Trippy alien vision effect
- `weed`: Cannabis-like visual effect
- `trevor`: Clown fight hallucination effect
- `turbo`: Motion blur with camera shake
- `rampage`: Intense motion blur effect
- `focus`: Focus enhancement effect
- `nightvision`: Night vision toggle
- `thermal`: Thermal vision toggle
- `drunk`: Drunk effect
## Status Effects

- `heal`: Gradually increases health
- `stamina`: Increases player stamina
- `armor`: Gradually increases armor

## Prop Bone IDs

Common bone IDs for prop attachment:
- 18905: Right Hand
- 57005: Left Hand
- 24818: Left Finger
- 64016: Right Finger

## Example Item

```lua
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
        screen = "weed",
        effect = "armor",
        time = 30000,
        amount = 2,
    },
}

['cigarettebox'] = {
    label = 'Cigarette Box',
    type = 'box',
    removeOnUse = true,
    progress = {
        duration = 2000,
        label = 'Opening cigarette box...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'mp_arresting',
            clip = 'a_uncuff',
            flag = 49,
        },
    },
    gives = {
        item = 'cigarette',
        amount = 20
    }
}
```

## Events

### Client Events

- `paradise_consumables:client:useItem`: Triggered when using an item

### Server Events

- `paradise_consumables:server:removeItem`: Removes item from inventory
- `paradise_consumables:server:addHunger`: Updates player hunger
- `paradise_consumables:server:addThirst`: Updates player thirst
- `paradise_consumables:server:removeStress`: Updates player stress
- `paradise_consumables:server:heal`: Heals the player

## Contributing

Feel free to contribute to this resource by submitting issues or pull requests.

## License

This project is licensed under the MIT License.