local SF = LibSFUtils
 
BugCatcher = {
    name = "BugCatcher",
    version = "029",
	author = "Werewolf Finds Dragon, Shadowfen",
    displayName = "Bug Catcher - Updated",
}

BugCatcher.displayName = SF.str(SF.colors.ltskyblue:Colorize(BugCatcher.displayName)," - ",SF.colors.goldenrod:Colorize("Bug Log"))
BugCatcher.version = SF.colors.gold:Colorize(BugCatcher.version)
BugCatcher.author = SF.colors.epic:Colorize(BugCatcher.author)

--SF.LoadLanguage(BugCatcher_localization_strings, "en")
