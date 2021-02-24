state("momodora2")
{

	short room : 0x1AF2F8;

	byte Fade : 0x1AF287;

	double xPos : 0x01AF2F4, 0x80, 0x158, 0x0, 0x58;
	double yPos : 0x01AF2F4, 0x80, 0x158, 0x0, 0x60;

	double LockedMovement : 0x0189720, 0x4, 0x1000;

	double Health : 0x0189720, 0x4, 0xAD8;

	double Blessings : 0x0189720, 0x4, 0x1078;

	double CharmOne : 0x0189720, 0x4, 0x1168;
	double CharmTwo : 0x0189720, 0x4, 0x13C0;

	double DoubleJump : 0x0189720, 0x4, 0x11E0;

	double Dash : 0x0189720, 0x4, 0x1348;

	double GreenLeaf : 0x0189720, 0x4, 0x1460;

	double EriHealth : 0x01AF2F4, 0x80, 0x274, 0x0, 0x10C, 0x4, 0x10;

	byte BossActive : 0x0189720, 0x4, 0xF58;
}


startup
{

	settings.Add("meiko", true, "Meiko CutScene");


	settings.Add("bosses", true, "Bosses");

	settings.Add("eri1", true, "Eri 1", "bosses");
	settings.Add("eri2", false, "Eri 2", "bosses");
	settings.SetToolTip("eri2", "It will split when exiting the room to account for both, the intended route and the skip");
	settings.Add("isadora", true, "Isadora", "bosses");


	settings.Add("upgrades", true, "Upgrades");

	settings.Add("charm1", false, "Charm 1", "upgrades");
	settings.Add("charm2", false, "Charm 2", "upgrades");
	settings.Add("doubleJump", true, "Double Jump", "upgrades");
	settings.Add("dash", false, "Dash", "upgrades");
	settings.Add("greenLeaf", false, "Green leaf", "upgrades");


	settings.Add("blessings", true, "Blessings");

	settings.Add("blessing1", true, "Blessing 1", "blessings");
	settings.Add("blessing2", true, "Blessing 2", "blessings");
	settings.Add("blessing3", true, "Blessing 3", "blessings");
	settings.Add("blessing4", true, "Blessing 4", "blessings");
}


init
{

	// HashSet to hold splits already hit
	// It prevents Livesplit from splitting on the same split multiple times
	vars.Splits = new HashSet<string>();
}


update
{

	// Clear any hit splits if timer stops
	if (timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.Splits.Clear();
	}
}
 

start
{

	return current.room == 13 && current.Fade != 255;
}


reset
{

        return current.room == 0;
}


split
{

	//Prevent false splits if the player loads a savefile that isnt new
	if (old.room != 13)
	{

		// Meiko CS
	    	if (current.room == 18 && current.LockedMovement == 1)
	    	{

			if (vars.Splits.Contains("Meiko"))
			{

				return false;
			}

			vars.Splits.Add("Meiko");
			return settings["meiko"];
	    	}


		// Eri 1
	    	if (current.room == 20 && current.EriHealth <= 10 && current.EriHealth != 0)
	    	{

			if (vars.Splits.Contains("Eri1"))
			{

				return false;
			}

			vars.Splits.Add("Eri1");
			return settings["eri1"];
	    	}


		// Eri 2
	    	if (current.room == 16 && old.room == 2)
	    	{

			if (vars.Splits.Contains("Eri2"))
			{

				return false;
			}

			vars.Splits.Add("Eri2");
			return settings["eri2"];
	    	}


		// Isadora
	    	if (current.room == 24 && current.xPos >= 2262 && current.yPos <= 176)
	    	{

			if (current.BossActive == 1 && current.LockedMovement == 1)
			{

				if (vars.Splits.Contains("Isadora"))
				{

					return false;
				}

				vars.Splits.Add("Isadora");
				return settings["isadora"];
			}
	    	}

	
		// Charm1
	    	if (current.CharmOne != old.CharmOne)
	    	{

			if (vars.Splits.Contains("Charm1"))
			{

				return false;
			}

			vars.Splits.Add("Charm1");
			return settings["charm1"];
	    	}


		// Charm2
	    	if (current.CharmTwo != old.CharmTwo)
	    	{

			if (vars.Splits.Contains("Charm2"))
			{

				return false;
			}

			vars.Splits.Add("Charm2");
			return settings["charm2"];
	    	}


		// doubleJump
	    	if (current.DoubleJump != old.DoubleJump)
	    	{

			if (vars.Splits.Contains("doubleJump"))
			{

				return false;
			}

			vars.Splits.Add("doubleJump");
			return settings["doubleJump"];
	    	}


		// dash
	    	if (current.Dash != old.Dash)
	    	{

			if (vars.Splits.Contains("dash"))
			{

				return false;
			}

			vars.Splits.Add("dash");
			return settings["dash"];
	    	}


		// greenLeaf
	    	if (current.GreenLeaf != old.GreenLeaf)
	    	{

			if (vars.Splits.Contains("greenLeaf"))
			{

				return false;
			}

			vars.Splits.Add("greenLeaf");
			return settings["greenLeaf"];
	    	}


		// Blessings
		if (current.Blessings != old.Blessings && current.Blessings == 1)
		{


			if (vars.Splits.Contains("blessing1"))
			{
				return false;
			}

			vars.Splits.Add("blessing1");
			return settings["blessing1"];
		}


		else if (current.Blessings != old.Blessings && current.Blessings == 2)
		{

			if (vars.Splits.Contains("blessing2"))
			{
				return false;
			}

			vars.Splits.Add("blessing2");
			return settings["blessing2"];
		}


		else if (current.Blessings != old.Blessings && current.Blessings == 3)
		{

			if (vars.Splits.Contains("blessing3"))
			{
				return false;
			}

			vars.Splits.Add("blessing3");
			return settings["blessing3"];
		}


		else if (current.Blessings != old.Blessings && current.Blessings == 4)
		{

			if (vars.Splits.Contains("blessing4"))
			{
				return false;
			}

			vars.Splits.Add("blessing4");
			return settings["blessing4"];
		}
	}
}
