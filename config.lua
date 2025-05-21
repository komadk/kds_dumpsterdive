Config = {}

-- General Settings
Config.SearchCooldown = 30 -- Seconds until a player can search the same container again
Config.GlobalCooldown = 5 -- Seconds until a player can search any container again

-- Target models
Config.Models = {
    dumpsters = {
        218085040, -- Large blue dumpster
        -58485588, -- Large green dumpster
        682791951, -- Small blue dumpster
        -206690185, -- Small green dumpster
        666561306, -- Large container
        -1587184881, -- Large container 2
    },
    trashcans = {
        -1096777189, -- Regular trash can
        -1012380860, -- Small trash can
        -413198204, -- Small trash bin
        1437508529, -- Blue trash bin
        1614656839, -- Green trash bin
        -130812911, -- Small trash can 2
        1329570871, -- Small trash can 3
    }
}

-- Animations
Config.Animations = {
    dumpster = {
        dict = "mini@repair",
        anim = "fixing_a_ped",
        duration = 5500, -- in ms
        flags = 1
    },
    trashcan = {
        dict = "mini@repair",
        anim = "fixing_a_ped",
        duration = 3500, -- in ms
        flags = 1
    }
}

-- Items to be found 
Config.Items = {
    common = {
        { name = 'plastic', min = 1, max = 3, chance = 30 },    -- 30% chance
        { name = 'glass', min = 1, max = 3, chance = 30 },      -- 30% chance
        { name = 'metal', min = 1, max = 2, chance = 25 },      -- 25% chance 
        { name = 'rubber', min = 1, max = 2, chance = 25 },     -- 25% chance
        { name = 'water', min = 1, max = 1, chance = 20 },      -- 20% chance
        { name = 'bread', min = 1, max = 1, chance = 15 },      -- 15% chance
    },
    uncommon = {
        { name = 'phone', min = 1, max = 1, chance = 5 },       -- 5% chance
        { name = 'screwdriver', min = 1, max = 1, chance = 8 }, -- 8% chance
        { name = 'hammer', min = 1, max = 1, chance = 8 },      -- 8% chance
        { name = 'lockpick', min = 1, max = 1, chance = 5 },    -- 5% chance
        { name = 'alive_chicken', min = 1, max = 1, chance = 3 }, -- 3% chance
    },
    rare = {
        { name = 'goldwatch', min = 1, max = 1, chance = 1 },   -- 1% chance
        { name = 'deluxe_watch', min = 1, max = 1, chance = 1 } -- 1% chance
    }
}

-- Chances to find each tier of items
Config.TierChances = {
    nothing = 20,   -- 20% chance to find nothing
    common = 60,    -- 60% chance for common items
    uncommon = 15,  -- 15% chance for uncommon items
    rare = 5        -- 5% chance for rare items
}

-- Maximum number of items to receive per search
Config.MaxItems = {
    dumpsters = 3,  -- Max 3 items from dumpsters
    trashcans = 2   -- Max 2 items from trash cans
} 