# mrp-dumpster
This is a rework by Mickey#4910 (Mickeystix/Marcus) for use with BerkieBb's qb-target.

Using qb-target, you can initiate dumpster diving. If the dumpster is valid (meaning it has not been searched) then you get random items (see config.lua for item configuration, you can change amounts in server.lua). After a dumpster is searched, it is unavailable for 1-60 minutes (determined randomly, but can change in server.lua)

To integrate with qb-target, add this to the init.lua (sometimes called the "config" method of adding new interactions)

    ["dumpsters_1"] = {
        models = {
            "prop_dumpster_4b",
            "prop_dumpster_4a",
			"prop_dumpster_3a",
			"prop_dumpster_02b",
			"prop_dumpster_02a",
			"prop_dumpster_01a",
			"prop_snow_dumpster_01",
        },
        options = {
            {
                event = "qb-dumpster:client:dumpsterdive",
                icon = "fas fa-dumpster",
                label = "Check Dumpster",
            },
        },
        distance = 2.0,
    },


Original - https://github.com/PhantomDDK/qb-dumpsters
Optimization rework - https://github.com/SebeCK73/qb-dumpster
Mickey's rework - You're looking at it, but also  https://github.com/mickeystix/mrp-dumpster

qb-target is required - https://github.com/BerkieBb/qb-target

Additional items you want players to get need to be configured in the config.lua

Support my work - https://www.buymeacoffee.com/mickeystix

