state("momodora2") {
	short room : 0x1AF2F8;

	double CanPress : 0x1AF2F4, 0x80, 0xBC, 0x0, 0x10C, 0x4, 0x240;

	int FlagsPtr : 0x189720, 0x4;

	double Eri : 0x1AF2F4, 0x80, 0x274, 0x0, 0x10C, 0x4, 0x10;

	double Isadora : 0x1AF2F4, 0x80, 0x380, 0x0, 0x10C, 0x4, 0x10;
}

startup {
	settings.Add("meiko", true, "Meiko CutScene");

	settings.Add("bosses", true, "Bosses");
		settings.Add("eri1", true, "Eri 1", "bosses");
		settings.Add("eri2", true, "Eri 2", "bosses");
		settings.Add("isadora", true, "Isadora", "bosses");

		settings.SetToolTip("eri2", "Splits when exiting the room to account for both, the intended route and the skip");

	settings.Add("upgrades", true, "Upgrades");
		settings.Add("charm1", false, "Charm 1", "upgrades");
		settings.Add("charm2", false, "Charm 2", "upgrades");
		settings.Add("doubleJump", true, "Double Jump", "upgrades");
		settings.Add("dash", false, "Dash", "upgrades");
		settings.Add("greenLeaf", false, "Green leaf", "upgrades");

	settings.Add("blessings", false, "Blessings");
		settings.Add("lunaBless", false, "Luna's", "blessings");
		settings.Add("miloriBless", false, "Milori's", "blessings");
		settings.Add("chiemiBless", false, "Chiemi's", "blessings");
		settings.Add("kahoBless", false, "Kaho's", "blessings");

		settings.SetToolTip("blessings", "The blessings are in order acccording to the any% route");
}

init {
	// HashSet to hold splits already hit
	vars.Splits = new HashSet<string>();

	// Dictionary which holds MemoryWatchers that correspond to each flag
	vars.Flags = new Dictionary<string, MemoryWatcher<double>>();
}

update {
	// Clear any hit splits if timer stops
	if (timer.CurrentPhase == TimerPhase.NotRunning)
		vars.Splits.Clear();
		
	// Initialize flags when the flags pointer gets initialized/changes, or we load up LiveSplit while in-game
	if (old.FlagsPtr != current.FlagsPtr || current.FlagsPtr != 0 && vars.Flags.Count == 0) {
		// Last offsets of FlagsPtr to read
		Dictionary<string, int> flagOffsets = new Dictionary<string, int> {
			{"meiko", 0x1398}, {"charm1", 0x1168}, {"charm2", 0x13C0}, {"doubleJump", 0x11E0}, {"dash", 0x1348}, {"greenLeaf", 0x1460}, {"lunaBless", 0x10A0}, {"miloriBless", 0x10C8}, {"chiemiBless", 0x10F0}, {"kahoBless", 0x1118}
		};

		vars.Flags = flagOffsets.Keys.ToDictionary(key => key, key => new MemoryWatcher<double>((IntPtr)current.FlagsPtr + flagOffsets[key]));
	}

	// Update all MemoryWatchers in vars.Flags
	new List<MemoryWatcher<double>>(vars.Flags.Values).ForEach((Action<MemoryWatcher<double>>)(mw => mw.Update(game)));
}
 
start {
	return (old.CanPress == 1 && current.CanPress == 0);
}

reset {
    return (current.room == 0);
}

split {
	// Event flags
	foreach (string key in vars.Flags.Keys) {
		if (vars.Flags[key].Old != vars.Flags[key].Current) {
			if (vars.Splits.Contains(key))
				return false;

			vars.Splits.Add(key);
			return settings[key];
		}
	}

	// Eri 1
	if (current.room == 20 && current.Eri <= 10 && old.Eri > 10) {
		if (vars.Splits.Contains("eri1"))
			return false;

		vars.Splits.Add("eri1");
		return settings["eri1"];
	}

	// Eri 2
	if (current.room == 16 && old.room == 2) {
		if (vars.Splits.Contains("eri2"))
			return false;

		vars.Splits.Add("eri2");
		return settings["eri2"];
	}

	// Isadora
	if (current.room == 24 && current.Isadora == 0 && old.Isadora > 0) {
		if (vars.Splits.Contains("isadora"))
			return false;

		vars.Splits.Add("isadora");
		return settings["isadora"];
	}
}
