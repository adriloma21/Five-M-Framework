MP = MP or {}
MP.Base = MP.Base or {}
MP.Player = MP.Player or {}
MP.Players = MP.Playerss or {}
MP.APlayer = MP.APlayer or {}
MP.APlayers = MP.APlayers or {}
MP.Functions = MP.Functions or {}
MP.PlayerData = MP.PlayerData or {}
MP.Commands = MP.Commands or {}
MP.Admin = MP.Admin or {}

MP.NewCharacter = {
    Cash = 2500,
    Bank = 80000,
}

MP.UserGroups = {
    ['user'] = {
        label = "User",
        perms = {
            "user"
        }
    },
    ['moderator'] = {
        label = "Moderator",
        perms = {
            "user",
            "mod"
        }
    },
    ['admin'] = {
        label = "Admin",
        perms = {
            "user",
            "mod",
            "admin"
        }
    },
    ['developer'] = {
        label = "Developer",
        perms = {
            "user",
            "mod",
            "admin",
            "developer"
        }
    }
}