local my_mod = {
    mod_id = "my_mod",
    name = "My Mod",
    version = "1.0",
    author = "Awesome Me",
    description = {
        "This is a mod that does something.",
        "It is very cool."
    },
    enabled = true,
    on_enable = function()
        sendDebugMessage("My Mod is enabled!")
    end,
}
table.insert(mods, my_mod)
