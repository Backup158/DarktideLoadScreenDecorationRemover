return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`LoadScreenDecorationRemover` encountered an error loading the Darktide Mod Framework.")

		new_mod("LoadScreenDecorationRemover", {
			mod_script       = "LoadScreenDecorationRemover/scripts/mods/LoadScreenDecorationRemover/LoadScreenDecorationRemover",
			mod_data         = "LoadScreenDecorationRemover/scripts/mods/LoadScreenDecorationRemover/LoadScreenDecorationRemover_data",
			mod_localization = "LoadScreenDecorationRemover/scripts/mods/LoadScreenDecorationRemover/LoadScreenDecorationRemover_localization",
		})
	end,
	packages = {},
}
