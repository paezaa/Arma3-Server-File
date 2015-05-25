/*
  Code by blckeagls
  Modified by Ghostrider
*/
private ["_coords","_crate","_aiGroup","_numAIGrp","_arc","_dir","_dist","_xpos","_ypos","_newPos","_objects","_startMsg","_endMsg","_mapLabel","_missionObjs","_compositions","_missionCfg","_compSel"];
diag_log "[blckeagls] Starting ORANGE mission SM1";

_coords = _this select 0;
// holds a list of objects spawned for this mission for cleanup later on.
_objects = [];

// Use include here so as not to distract from the flow of the code. The included file defines arrays specifying the parameters for each mission.
#include "\q\addons\custom_server\AIMission\Major\compositions\compositionsOrange.sqf"; 

// a listing of mission compositions for this mission set.
_compositions = 
[
	//"resupplyCamp"
	//"redCamp"
	//"medicalCamp"
	"default"
];

_compSel = _compositions call BIS_fnc_selectRandom;

// Select a mission configuration and load the data into _missionCfg
switch (_compositions call BIS_fnc_selectRandom) do 
{
	case "default": {_missionCfg = _default};
	case "medicalCamp": {_missionCfg = _medicalCamp};
	case "redCamp": {_missionCfg = _redCamp};
	case "resupplyCamp": {_missionCfg = _resupplyCamp};
};

// Parse the _missionCfg into messages and a list of objects for clarity of code
_startMsg = _missionCfg select 0 select 0;
_endMsg = _missionCfg select 0 select 1;
_missionObjs = _missionCfg select 1;

//Sends message to all players about the AI Mission

[_startMsg] call blck_MessagePlayers;

waitUntil{ {isPlayer _x && _x distance _coords <= blck_TriggerDistance /*&& vehicle _x == _x*/} count playableunits > 0 };

//Creates the crate
// Should move this to a function eventually
_crate = objNull;
_crate = createVehicle ["Box_NATO_Wps_F",_coords,[], 0, "CAN_COLLIDE"];

//Sets variables (not sure if needed but left just incase so cleanup doesnt happen
_crate setVariable ["Mission",1,true];
_crate setVariable ["ObjectID","1",true];
_crate setVariable ["permaLoot",true,true];

_objects = [_coords, _missionObjs] call blck_spawnCompositionObjects;

if (blck_useSmokeAtCrates) then  // spawn a fire and smoke near the crate
{
	private ["_temp"];
	_temp = [_coords] call blck_smokeAtCrates;
	diag_log format["[major\sm1.sqf] temporary items are %1", _temp];
	_objects = _objects + _temp;
};

//Fills the crate with items
// Parameters here are [_crate, _lootArray, num weapons to add, num items from the magazines array to add, num items from the item array to add]
// Variables are: 
//	blck_BoxLoot_Major, an array of items which can be added to the crate; 
//	blck_lootCountsMajor, an array containing the number of weapons, magazines, items and backpacks to be randomly selected from blck_BoxLoot_Major and added to the crate

[_crate,blck_BoxLoot_Major,blck_lootCountsMajor select 0, blck_lootCountsMajor select 1, blck_lootCountsMajor select 2, blck_lootCountsMajor select 3, blck_lootCountsMajor select 4] call blck_fillBoxes;

//Spawns the AI at several randomized locations relative to the loot box
_numAIGrp = round((blck_MinAI_Major + round(random(blck_MaxAI_Major - blck_MinAI_Major)))/blck_AIGrps_Major);
_arc = 360/blck_AIGrps_Major;
_dir = random 360;
_dist = (20+(random 15));
for "_i" from 1 to blck_AIGrps_Major do {
	_dist = (20+(random 15));
	_dir = _dir + _arc;
	if (_dir > 360) then {_dir = _dir - 360};	
	_xpos = (_coords select 0) + sin (_dir) * _dist;
	_ypos = (_coords select 1) + cos (_dir) * _dist;
	_newPos = [_xpos,_ypos,0];
	_aiGroup = [_newPos,_numAIGrp,_numAIGrp+1,"orange"] call blck_spawnGroup;
	blck_AIMajor = blck_AIMajor + _aiGroup;
	_dir = _dir + _arc;
};

// Spawn any static weapons and man them

if (blck_useStatic) then 
{
	if (blck_SpawnVeh_Major == 1) then
	{
		_aiGroup = [_coords,3,4,"orange"] call blck_spawnGroup;
		blck_AIMajor = blck_AIMajor + _aiGroup;
		//spawn a static MG at the crate order the group to man it.
		_veh = [_coords,_aiGroup,blck_staticWeapons call BIS_fnc_selectRandom] call blck_spawnEmplacedWeapon;
		_objects = _objects + [_veh];
	};
	if (blck_SpawnVeh_Major > 1) then
	{
		_arc = 360/blck_SpawnVeh_Major;
		_dir = random 360;
		_dist = (15+(random 10));
		for "_i" from 1 to blck_SpawnVeh_Major do
		{ 
			_dir = _dir + _arc;
			if (_dir > 360) then {_dir = _dir - 360};
			_xpos = (_coords select 0) + sin (_dir) * _dist;
			_ypos = (_coords select 1) + cos (_dir) * _dist;
			_newPos = [_xpos,_ypos,0];		
			_aiGroup = [_newPos,3,4,"orange"] call blck_spawnGroup;
			blck_AIMajor = blck_AIMajor + _aiGroup;
			// spawn a static MG at the crate order the group to man it.
			_veh = [_newPos,_aiGroup,blck_staticWeapons call BIS_fnc_selectRandom] call blck_spawnEmplacedWeapon;
			_objects = _objects + [_veh];
		};
	};	
};

//Waits until player gets near the _crate to end mission
waitUntil{{isPlayer _x && _x distance _crate < 10 && vehicle _x == _x } count playableunits > 0};

[_objects, blck_aiCleanUpTimer] spawn blck_cleanupObjects;

//Announces that the mission is complete
[_endMsg] call blck_MessagePlayers;
diag_log "[blckeagls] End of ORANGE mission SM1";
MissionGoMajor = false;
