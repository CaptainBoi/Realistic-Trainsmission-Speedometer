#define FILTERSCRIPT
/************************** 
            Credits  
   ZCMD: Zeex
  
   foreach: Kar & Y_Less
  
   SpeedoMeter: CaptainBoi
 **************************/

/* Includes */
#include <a_samp>
#include <foreach>
#include <zcmd>

/* Text Variables */
new Text:speedo[MAX_PLAYERS][22];

/* Vehice Fuel */
#define MAX_FUEL 100.0
#define MAX_COST 1
new Float:Gas[MAX_VEHICLES + 1] = {MAX_FUEL, ...};
new Filling[MAX_PLAYERS];

/* Vehicle Names */
new vehName[][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perennial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropduster",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster",
	"Monster",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratium",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat",
	"Streak Carriage",
	"Kart",
	"Mower",
	"Dune",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"News Van",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Box",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police",
	"Police",
	"Police",
	"Ranger",
	"Picador",
	"S.W.A.T",
	"Alpha",
	"Phoenix",
	"Glendale Shit",
	"Sadler Shit",
	"Luggage",
	"Luggage",
	"Stairs",
	"Boxville",
	"Tiller",
	"Utility Trailer"
};

Float:GetPlayerSpeed(playerid)
{
    new Float:px, Float:py, Float:pz;
    GetVehicleVelocity(GetPlayerVehicleID(playerid), px, py, pz);
    return floatsqroot(floatpower(floatabs(px), 2.0) + floatpower(floatabs(py), 2.0) + floatpower(floatabs(pz), 2.0)) * 100;
}

new bool:False = false, txdstring[1000];
/* TextDrawSetString With String */
#define TextDrawSetStrings(%1,%2,%3)\
do{\
	format(txdstring, sizeof (txdstring), (%2), %3);\
	TextDrawSetString((%1), txdstring);\
}\
while (False)

IsVehicleDrivingBackwards(vehicleid)
{
    new Float:Float[3];
    if(GetVehicleVelocity(vehicleid, Float[1], Float[2], Float[0]))
    {
        GetVehicleZAngle(vehicleid, Float[0]);
        if(Float[0] < 90)
        {
            if(Float[1] > 0 && Float[2] < 0) return true;
        }
        else if(Float[0] < 180)
        {
            if(Float[1] > 0 && Float[2] > 0) return true;
        }
        else if(Float[0] < 270)
        {
            if(Float[1] < 0 && Float[2] > 0) return true;
        }
        else if(Float[1] < 0 && Float[2] < 0) return true;
    }
    return false;
}

forward FuelUpdate();
public FuelUpdate()
{
	new vehicleid, Float:temp1;
	foreach(new i: Player)
	{
		if (IsPlayerConnected(i))
		{
			if (GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				vehicleid = GetPlayerVehicleID(i);
				temp1 = GetPlayerSpeed(i);
				if (Filling[i] == 1) 
				{
					if (Gas[vehicleid] < MAX_FUEL)
					{
	                    if (GetPlayerMoney(i) >= MAX_COST) 
						{
							GivePlayerMoney(i, -MAX_COST);
							if (Gas[vehicleid] <= MAX_FUEL-1.0)
							{
								Gas[vehicleid] += 1.0;
							}
							else
							{
								Gas[vehicleid] = MAX_FUEL;
							}
						}
						else 
						{
							Filling[i] = 0;
							SendClientMessage(i, 0xFFFF0000, "You don't have enough money to continue refueling.");
						}
						if (Gas[vehicleid] == MAX_FUEL) 
						{
							Filling[i] = 0;
							SendClientMessage(i, 0xFFFFFF00, "Your vehicle is now fully refueld.");
						}
					}
				}
				else if (VehicleTakesFuel(vehicleid))
				{
					if (floatround(Gas[vehicleid]) > 0)
					{
						Gas[vehicleid] -= temp1 / 6000.0;
						if (floatround(Gas[vehicleid]) <= 0)
						{
							new engine, lights, alarm, doors, bonnet, boot, objective;
							GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
							SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
							SendClientMessage(i, 0xFFFFFFF, "Your vehicle ran out of fuel!");
						}
					}
				}
				else if (Filling[i] == 1) Filling[i] = 0;
			}
		}
	}
}
VehicleTakesFuel(vehicleid)
{
	switch (GetVehicleModel(vehicleid))
	{
		case 430, 446, 449, 452, 453, 454, 460, 472, 473, 481, 484, 493, 509, 510, 537, 538, 539, 595: return false;
	}
	return true;
}
UpdatePlayerSpeedo(playerid)
{
    new Float:health;
	GetVehicleHealth(GetPlayerVehicleID(playerid), health);
	TextDrawSetPreviewModel(speedo[playerid][15], GetVehicleModel(GetPlayerVehicleID(playerid)));
	TextDrawSetStrings(speedo[playerid][6], "%d%", floatround(health));
	TextDrawSetStrings(speedo[playerid][11], "%d KPH", floatround(GetPlayerSpeed(playerid)));
	TextDrawSetStrings(speedo[playerid][12], "%s", vehName[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
	if(Gas[GetPlayerVehicleID(playerid)] <= 10) 
	{
		TextDrawSetStrings(speedo[playerid][7], "~r~%d%", floatround(Gas[GetPlayerVehicleID(playerid)]));
	}
	else 
	{
		TextDrawSetStrings(speedo[playerid][7], "~w~%d%", floatround(Gas[GetPlayerVehicleID(playerid)]));
	}
	if(GetPlayerSpeed(playerid) == 0) 
	{
		TextDrawSetString(speedo[playerid][21], "~g~P");
	}
	else if(IsVehicleDrivingBackwards(GetPlayerVehicleID(playerid)))
	{
		TextDrawSetString(speedo[playerid][21],  "~p~R");
	}
	if(GetPlayerSpeed(playerid) > 20)
	{
	 TextDrawSetString(speedo[playerid][21], "1");
	}
	if(GetPlayerSpeed(playerid) > 40)
	{
	 TextDrawSetString(speedo[playerid][21], "2");
	}
	if(GetPlayerSpeed(playerid) > 60)
	{
	 TextDrawSetString(speedo[playerid][21], "3");
	}
	if(GetPlayerSpeed(playerid) > 100)
	{
	 TextDrawSetString(speedo[playerid][21], "4");
	}
	if(GetPlayerSpeed(playerid) > 120)
	{
	 TextDrawSetString(speedo[playerid][21], "5");
	}
}

CreateTextdrawMeter(playerid)
{
	speedo[playerid][0] = TextDrawCreate(638.251831, 371.333312, "backbox");
	TextDrawLetterSize(speedo[playerid][0], 0.000000, 7.914819);
	TextDrawTextSize(speedo[playerid][0], 495.101013, 0.000000);
	TextDrawAlignment(speedo[playerid][0], 1);
	TextDrawColor(speedo[playerid][0], 0);
	TextDrawUseBox(speedo[playerid][0], true);
	TextDrawBoxColor(speedo[playerid][0], 102);
	TextDrawSetShadow(speedo[playerid][0], 0);
	TextDrawSetOutline(speedo[playerid][0], 0);
	TextDrawFont(speedo[playerid][0], 0);

	speedo[playerid][1] = TextDrawCreate(637.845886, 371.750030, "upbox");
	TextDrawLetterSize(speedo[playerid][1], 0.000000, -0.237450);
	TextDrawTextSize(speedo[playerid][1], 495.101104, 0.000000);
	TextDrawAlignment(speedo[playerid][1], 1);
	TextDrawColor(speedo[playerid][1], 0);
	TextDrawUseBox(speedo[playerid][1], true);
	TextDrawBoxColor(speedo[playerid][1], -1061109505);
	TextDrawSetShadow(speedo[playerid][1], 0);
	TextDrawSetOutline(speedo[playerid][1], 0);
	TextDrawFont(speedo[playerid][1], 0);

	speedo[playerid][2] = TextDrawCreate(638.377502, 444.500152, "downbox");
	TextDrawLetterSize(speedo[playerid][2], 0.000000, -0.284302);
	TextDrawTextSize(speedo[playerid][2], 495.101013, 0.000000);
	TextDrawAlignment(speedo[playerid][2], 1);
	TextDrawColor(speedo[playerid][2], 0);
	TextDrawUseBox(speedo[playerid][2], true);
	TextDrawBoxColor(speedo[playerid][2], -1061109505);
	TextDrawSetShadow(speedo[playerid][2], 0);
	TextDrawSetOutline(speedo[playerid][2], 0);
	TextDrawFont(speedo[playerid][2], 0);

	speedo[playerid][3] = TextDrawCreate(635.909240, 377.166687, "speedbox");
	TextDrawLetterSize(speedo[playerid][3], 0.000000, 6.683333);
	TextDrawTextSize(speedo[playerid][3], 588.805297, 0.000000);
	TextDrawAlignment(speedo[playerid][3], 1);
	TextDrawColor(speedo[playerid][3], 0);
	TextDrawUseBox(speedo[playerid][3], true);
	TextDrawBoxColor(speedo[playerid][3], 102);
	TextDrawSetShadow(speedo[playerid][3], 0);
	TextDrawSetOutline(speedo[playerid][3], 0);
	TextDrawFont(speedo[playerid][3], 0);

	speedo[playerid][4] = TextDrawCreate(594.210815, 378.333312, "leftbbox");
	TextDrawLetterSize(speedo[playerid][4], 0.000000, 6.359263);
	TextDrawTextSize(speedo[playerid][4], 589.273803, 0.000000);
	TextDrawAlignment(speedo[playerid][4], 1);
	TextDrawColor(speedo[playerid][4], 0);
	TextDrawUseBox(speedo[playerid][4], true);
	TextDrawBoxColor(speedo[playerid][4], -864591926);
	TextDrawSetShadow(speedo[playerid][4], 0);
	TextDrawSetOutline(speedo[playerid][4], 0);
	TextDrawFont(speedo[playerid][4], 0);

	speedo[playerid][5] = TextDrawCreate(634.566833, 378.166625, "rightbbox");
	TextDrawLetterSize(speedo[playerid][5], 0.000000, 6.359263);
	TextDrawTextSize(speedo[playerid][5], 629.566833, 0.000000);
	TextDrawAlignment(speedo[playerid][5], 1);
	TextDrawColor(speedo[playerid][5], 0);
	TextDrawUseBox(speedo[playerid][5], true);
	TextDrawBoxColor(speedo[playerid][5], -864591926);
	TextDrawSetShadow(speedo[playerid][5], 0);
	TextDrawSetOutline(speedo[playerid][5], 0);
	TextDrawFont(speedo[playerid][5], 0);

	speedo[playerid][6] = TextDrawCreate(595.022216, 377.416595, "");
	TextDrawLetterSize(speedo[playerid][6], 0.256969, 1.284999);
	TextDrawAlignment(speedo[playerid][6], 1);
	TextDrawColor(speedo[playerid][6], -1);
	TextDrawSetShadow(speedo[playerid][6], 0);
	TextDrawSetOutline(speedo[playerid][6], 1);
	TextDrawBackgroundColor(speedo[playerid][6], 51);
	TextDrawFont(speedo[playerid][6], 2);
	TextDrawSetProportional(speedo[playerid][6], 1);

	speedo[playerid][7] = TextDrawCreate(595.553771, 391.833282, "");
	TextDrawLetterSize(speedo[playerid][7], 0.256969, 1.284999);
	TextDrawAlignment(speedo[playerid][7], 1);
	TextDrawColor(speedo[playerid][7], -1);
	TextDrawSetShadow(speedo[playerid][7], 0);
	TextDrawSetOutline(speedo[playerid][7], 1);
	TextDrawBackgroundColor(speedo[playerid][7], 51);
	TextDrawFont(speedo[playerid][7], 2);
	TextDrawSetProportional(speedo[playerid][7], 1);

	speedo[playerid][8] = TextDrawCreate(631.223999, 413.333312, "speedobox2");
	TextDrawLetterSize(speedo[playerid][8], 0.000000, 2.340742);
	TextDrawTextSize(speedo[playerid][8], 592.553466, 0.000000);
	TextDrawAlignment(speedo[playerid][8], 1);
	TextDrawColor(speedo[playerid][8], 0);
	TextDrawUseBox(speedo[playerid][8], true);
	TextDrawBoxColor(speedo[playerid][8], 102);
	TextDrawSetShadow(speedo[playerid][8], 0);
	TextDrawSetOutline(speedo[playerid][8], 0);
	TextDrawFont(speedo[playerid][8], 0);

	speedo[playerid][9] = TextDrawCreate(630.286987, 412.750000, "uppbox");
	TextDrawLetterSize(speedo[playerid][9], 0.000000, -0.385374);
	TextDrawTextSize(speedo[playerid][9], 593.958984, 0.000000);
	TextDrawAlignment(speedo[playerid][9], 1);
	TextDrawColor(speedo[playerid][9], 0);
	TextDrawUseBox(speedo[playerid][9], true);
	TextDrawBoxColor(speedo[playerid][9], 1884589414);
	TextDrawSetShadow(speedo[playerid][9], 0);
	TextDrawSetOutline(speedo[playerid][9], 0);
	TextDrawFont(speedo[playerid][9], 0);

	speedo[playerid][10] = TextDrawCreate(630.818481, 438.833496, "downpbox");
	TextDrawLetterSize(speedo[playerid][10], 0.000000, -0.385374);
	TextDrawTextSize(speedo[playerid][10], 593.490478, 0.000000);
	TextDrawAlignment(speedo[playerid][10], 1);
	TextDrawColor(speedo[playerid][10], 0);
	TextDrawUseBox(speedo[playerid][10], true);
	TextDrawBoxColor(speedo[playerid][10], 1884589414);
	TextDrawSetShadow(speedo[playerid][10], 0);
	TextDrawSetOutline(speedo[playerid][10], 0);
	TextDrawFont(speedo[playerid][10], 0);

	speedo[playerid][11] = TextDrawCreate(598.896423, 418.499938, "");
	TextDrawLetterSize(speedo[playerid][11], 0.153426, 1.115832);
	TextDrawAlignment(speedo[playerid][11], 1);
	TextDrawColor(speedo[playerid][11], -1);
	TextDrawSetShadow(speedo[playerid][11], 0);
	TextDrawSetOutline(speedo[playerid][11], 1);
	TextDrawBackgroundColor(speedo[playerid][11], 51);
	TextDrawFont(speedo[playerid][11], 2);
	TextDrawSetProportional(speedo[playerid][11], 1);

	speedo[playerid][12] = TextDrawCreate(504.128936, 371.583312, "");
	TextDrawLetterSize(speedo[playerid][12], 0.296324, 1.354999);
	TextDrawAlignment(speedo[playerid][12], 1);
	TextDrawColor(speedo[playerid][12], -1);
	TextDrawSetShadow(speedo[playerid][12], 0);
	TextDrawSetOutline(speedo[playerid][12], 1);
	TextDrawBackgroundColor(speedo[playerid][12], 51);
	TextDrawFont(speedo[playerid][12], 1);
	TextDrawSetProportional(speedo[playerid][12], 1);

	speedo[playerid][13] = TextDrawCreate(589.057128, 385.333312, "uppbox2");
	TextDrawLetterSize(speedo[playerid][13], 0.000000, -0.316666);
	TextDrawTextSize(speedo[playerid][13], 498.849182, 0.000000);
	TextDrawAlignment(speedo[playerid][13], 1);
	TextDrawColor(speedo[playerid][13], 0);
	TextDrawUseBox(speedo[playerid][13], true);
	TextDrawBoxColor(speedo[playerid][13], 1682412799);
	TextDrawSetShadow(speedo[playerid][13], 0);
	TextDrawSetOutline(speedo[playerid][13], 0);
	TextDrawFont(speedo[playerid][13], 0);

	speedo[playerid][14] = TextDrawCreate(590.525634, 435.916809, "downpbox2");
	TextDrawLetterSize(speedo[playerid][14], 0.000000, -0.316666);
	TextDrawTextSize(speedo[playerid][14], 499.317718, 0.000000);
	TextDrawAlignment(speedo[playerid][14], 1);
	TextDrawColor(speedo[playerid][14], 0);
	TextDrawUseBox(speedo[playerid][14], true);
	TextDrawBoxColor(speedo[playerid][14], 1682412799);
	TextDrawSetShadow(speedo[playerid][14], 0);
	TextDrawSetOutline(speedo[playerid][14], 0);
	TextDrawFont(speedo[playerid][14], 0);

	speedo[playerid][15] = TextDrawCreate(489.135986, 379.166595, "LD_SPAC:white");
	TextDrawLetterSize(speedo[playerid][15], 0.000000, 0.000000);
	TextDrawTextSize(speedo[playerid][15], 49.194763, 57.750000);
	TextDrawAlignment(speedo[playerid][15], 1);
	TextDrawColor(speedo[playerid][15], -1);
	TextDrawUseBox(speedo[playerid][15], true);
	TextDrawBoxColor(speedo[playerid][15], 0);
	TextDrawSetShadow(speedo[playerid][15], 0);
	TextDrawSetOutline(speedo[playerid][15], 0);
	TextDrawBackgroundColor(speedo[playerid][15], 0x00000000);
	TextDrawFont(speedo[playerid][15], 5);
	TextDrawSetPreviewModel(speedo[playerid][15], 411);
	TextDrawSetPreviewRot(speedo[playerid][15], 0.000000, 0.000000, 17.000000, 1.000000);

	speedo[playerid][16] = TextDrawCreate(586.245971, 392.333312, "gearbox");
	TextDrawLetterSize(speedo[playerid][16], 0.000000, 3.637041);
	TextDrawTextSize(speedo[playerid][16], 536.330871, 0.000000);
	TextDrawAlignment(speedo[playerid][16], 1);
	TextDrawColor(speedo[playerid][16], 0);
	TextDrawUseBox(speedo[playerid][16], true);
	TextDrawBoxColor(speedo[playerid][16], 102);
	TextDrawSetShadow(speedo[playerid][16], 0);
	TextDrawSetOutline(speedo[playerid][16], 0);
	TextDrawFont(speedo[playerid][16], 0);

	speedo[playerid][17] = TextDrawCreate(584.840332, 394.083312, "upbbox");
	TextDrawLetterSize(speedo[playerid][17], 0.000000, -0.421295);
	TextDrawTextSize(speedo[playerid][17], 536.799377, 0.000000);
	TextDrawAlignment(speedo[playerid][17], 1);
	TextDrawColor(speedo[playerid][17], 0);
	TextDrawUseBox(speedo[playerid][17], true);
	TextDrawBoxColor(speedo[playerid][17], 65535);
	TextDrawSetShadow(speedo[playerid][17], 0);
	TextDrawSetOutline(speedo[playerid][17], 0);
	TextDrawFont(speedo[playerid][17], 0);

	speedo[playerid][18] = TextDrawCreate(585.371826, 426.583435, "downbbox2");
	TextDrawLetterSize(speedo[playerid][18], 0.000000, -0.374443);
	TextDrawTextSize(speedo[playerid][18], 536.799316, 0.000000);
	TextDrawAlignment(speedo[playerid][18], 1);
	TextDrawColor(speedo[playerid][18], 0);
	TextDrawUseBox(speedo[playerid][18], true);
	TextDrawBoxColor(speedo[playerid][18], 65535);
	TextDrawSetShadow(speedo[playerid][18], 0);
	TextDrawSetOutline(speedo[playerid][18], 0);
	TextDrawFont(speedo[playerid][18], 0);

	speedo[playerid][19] = TextDrawCreate(542.205017, 398.166687, "leftbbox");
	TextDrawLetterSize(speedo[playerid][19], 0.000000, 2.405555);
	TextDrawTextSize(speedo[playerid][19], 537.736450, 0.000000);
	TextDrawAlignment(speedo[playerid][19], 1);
	TextDrawColor(speedo[playerid][19], 0);
	TextDrawUseBox(speedo[playerid][19], true);
	TextDrawBoxColor(speedo[playerid][19], -5963521);
	TextDrawSetShadow(speedo[playerid][19], 0);
	TextDrawSetOutline(speedo[playerid][19], 0);
	TextDrawFont(speedo[playerid][19], 0);

	speedo[playerid][20] = TextDrawCreate(584.903564, 398.583312, "rightbbox");
	TextDrawLetterSize(speedo[playerid][20], 0.000000, 2.405555);
	TextDrawTextSize(speedo[playerid][20], 580.371948, 0.000000);
	TextDrawAlignment(speedo[playerid][20], 1);
	TextDrawColor(speedo[playerid][20], 0);
	TextDrawUseBox(speedo[playerid][20], true);
	TextDrawBoxColor(speedo[playerid][20], -5963521);
	TextDrawSetShadow(speedo[playerid][20], 0);
	TextDrawSetOutline(speedo[playerid][20], 0);
	TextDrawFont(speedo[playerid][20], 0);

	speedo[playerid][21] = TextDrawCreate(557.071960, 400.750000, "");
	TextDrawLetterSize(speedo[playerid][21], 0.449999, 1.600000);
	TextDrawAlignment(speedo[playerid][21], 1);
	TextDrawColor(speedo[playerid][21], -1);
	TextDrawSetShadow(speedo[playerid][21], 0);
	TextDrawSetOutline(speedo[playerid][21], 1);
	TextDrawBackgroundColor(speedo[playerid][21], 51);
	TextDrawFont(speedo[playerid][21], 2);
	TextDrawSetProportional(speedo[playerid][21], 1);
}

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Realistic SpeedoMeter By CaptainBoi");
	print("--------------------------------------\n");
	SetTimer("FuelUpdate", 300, 1);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    CreateTextdrawMeter(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{ 
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) 
	{
	    for(new i;i<22;i++)
		{
		 TextDrawShowForPlayer(playerid, speedo[playerid][i]);
		}
		UpdatePlayerSpeedo(playerid);
	}
	else
	{
	    for(new i;i<22;i++)
		{
		 TextDrawHideForPlayer(playerid, speedo[playerid][i]);
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) 
	{
		UpdatePlayerSpeedo(playerid);
	}
	return 1;
}

CMD:refuel(playerid, params[])
{
	new moneys1;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, 0xFFFF0000, "You must be the driver of a vehicle!");
	moneys1 = GetPlayerVehicleID(playerid);
	if (!VehicleTakesFuel(moneys1)) return SendClientMessage(playerid, 0xFFFF0000, "Error: This vehicle dont run on fuel its not contains a engine!");
	if (Gas[moneys1] == MAX_FUEL) return SendClientMessage(playerid, 0xFFFFFFFF, "Error: Your vehicle dont need more fuel its full now.");
	if (GetPlayerMoney(playerid) < MAX_COST)
	{
       return SendClientMessage(playerid, 0xFFFF0000, "Error: You don't have enough cash!");
	}
	if (Filling[playerid] == 1) return SendClientMessage(playerid, 0xFFFFFFFF, "Error: You are already refueling your vehicle.");
	Filling[playerid] = 1;
	SendClientMessage(playerid, 0xFF00FF00, "Refueling your vehicle.");
	return 1;
}