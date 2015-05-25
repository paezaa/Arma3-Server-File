private["_staticMissionsPath","_staticMissions","_dynamicMissionsPath","_dynamicMissions","_missionPos","_lastPositions","_randomMission","_lastMission","_runningMission","_missionID"];
/*
	Update 29.01.2015
	By KiloSwiss
*/

SEM_MinPlayerStatic = 1;	// Minimum number of online players for basic missions to spawn.
SEM_MinPlayerDynamic = 6; 	// Minimum number of online players for additional/parallel running missions.
SEM_MissionTimerMin = 20;	// Minimum minutes between missions.
SEM_MissionTimerMax = 35;	// Maximum minutes between missions.
SEM_MissionCleanup = -1;	// Minutes after a mission finished where all mission objects (including AI) will be deleted (0 or -1 equals never).
SEM_MarkerTimeOutS = 45;	// Time (in seconds) until marker is deleted after mission ending successfully.

// Disable Damage over a specific distance so players can't snipe the mission AI from safe distance.
SEM_AIdisableSniperDamage = true;	// Set to false to allow sniper damage from any distance.
SEM_AIsniperDamageDistance = 500;	// Max. distance (in meters) where AI takes damage (min. 300 -  max. 1000).

// Chance of AI dropping their guns and keeping their gear (vests, backpacks and magazines) when killed.
SEM_AIdropGearChance = 40;	//	Values: 0-100%	Where 0 means all gear gets removed from dead AI units.

SEM_removeWeaponsFromDeadAI = [];	// Weapons that should be removed from killed AI
SEM_removeMagazinesFromDeadAI = [];	// Magazines that should be removed from killed AI

//Marker Names where mission spawning is blocked.
SEM_blockMarker = ["respawn_west"];

_staticMissionsPath = "sem\missions\";
_staticMissions = [
	["supplyVanCrash",	"Supply Van",		45,	100],
	["bPlaneCrash",		"Plane Crashsite",	45,	90],
	["bHeliCrash",		"Heli Crashsite",	45,	85],
	["bCamp",			"Bandit Camp",		90,	80],
	["bDevice",			"Strange Device",	45,	75],
	/* example */
	["file name",		"marker name",		-1,	-1]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the mission marker.
	3. time out,		(Number) Minutes until running mission times out (0 or -1 equals no mission time out).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
*/];

_dynamicMissionsPath = "sem\missionsDynamic\";
_dynamicMissions = [
	["convoy",	"Supply Convoy",		90,	-1]
];

//##############################################
SEM_debug = false;
/*	Debug settings:
	- Missions time out after 10min
	- Minimum players is set to 0
	- Time between missions is 30sec
	- Mission clean up happens after 2min
	- AI only takes damage from under 100m
	- More events and additional data is logged
*/
//	DO NOT EDIT BELOW THIS LINE!
//##############################################
SEM_MinPlayerStatic = SEM_MinPlayerStatic max 1;
SEM_MinPlayerDynamic = SEM_MinPlayerDynamic max 1;
SEM_MissionTimerMin = SEM_MissionTimerMin max 1;
SEM_MissionTimerMax = SEM_MissionTimerMax max 1;
SEM_MissionCleanup = SEM_MissionCleanup max -1;
SEM_MarkerTimeOutS = SEM_MarkerTimeOutS max 0;
if(SEM_MissionTimerMin > SEM_MissionTimerMax)then{
	private "_tempValueHolder";
	_tempValueHolder = SEM_MissionTimerMax;
	SEM_MissionTimerMax = SEM_MissionTimerMin;
	SEM_MissionTimerMin = _tempValueHolder;
};

{if !(_x in SEM_removeWeaponsFromDeadAI)then{SEM_removeWeaponsFromDeadAI pushBack _x}}forEach ["launch_RPG32_F","Srifle_GM6_F","Srifle_LRR_F","m107_EPOCH","m107Tan_EPOCH"];
{if !(_x in SEM_removeMagazinesFromDeadAI)then{SEM_removeMagazinesFromDeadAI pushBack _x}}forEach ["RPG32_F","RPG32_HE_F","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
SEM_AIdropGearChance = 0 max SEM_AIdropGearChance min 100;
SEM_AIsniperDamageDistance = 300 max SEM_AIsniperDamageDistance min 1000;
SEM_AIsniperDamageEHunits = [];

if(SEM_debug)then{ /* Load debug settings */
	SEM_MinPlayerStatic = 0; SEM_MinPlayerDynamic = 0; SEM_MissionCleanup = 2;
	SEM_AIdisableSniperDamage = true; SEM_AIsniperDamageDistance = 50;
	[] spawn {
		//waitUntil{{isPlayer _x}count playableUnits > 0};	
		/* Add a looping hint so EVERYONE can see that debug is on */
		SEM_version = SEM_version + " - DEBUG IS ON!\nADMIN: Check ""initMissions.sqf"" inside ""sem.pbo""!";
		[] spawn{while{true}do{ sleep 120; publicVariable "SEM_version"}};
		publicVariable "SEM_version";
	};
}else{publicVariable "SEM_version"; UIsleep 120};

SEM_worldData = true call SEM_fnc_getWorldData;
if(SEM_debug)then{diag_log format["#SEM DEBUG: World Data (%1 %2) received, waiting for missions to start", str worldName, SEM_worldData]};

publicVariable "SEM_AIsniperDamageDistance";
SEM_lastMissionPositions = [];
SEM_MissionID = 0;

[
	[_staticMissions, _staticMissionsPath ,"static"]/*,
	[_dynamicMissions, _dynamicMissionsPath ,"dynamic"]*/
] call SEM_fnc_missionController;