/*
  Minor Mission 1
  Code by blckeagls
  Modified by Ghostrider
  See \Major\SM1.sqf for comments  
*/

private ["_coords","_crate","_aiGroup","_numAIGrp","_arc","_dir","_dist","_xpos","_ypos","_newPos","_objects","_startMsg","_endMsg","_missionObjs","_compositions","_missionCfg","_compSel"];
diag_log "[blckeagls] Starting BLUE mission SM1";

_coords = _this select 0;
_objects = [];

#include "\q\addons\custom_server\AIMission\Minor\compositions\compositionsBlue.sqf"; 

_compositions = 
[
	//"resupplyCamp",
	//"redCamp",
	//"medicalCamp",
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
_crate = objNull;
_crate = createVehicle ["Box_NATO_Wps_F",_coords,[], 0, "CAN_COLLIDE"];

//Sets variables (not sure if needed but left just incase so cleanup doesnt happen
_crate setVariable ["Mission",1,true];
_crate setVariable ["ObjectID","1",true];
_crate setVariable ["permaLoot",true,true];


[_crate,blck_BoxesLoot_Minor, blck_lootCountsMinor select 0, blck_lootCountsMinor select 1, blck_lootCountsMinor select 2, blck_lootCountsMinor select 3, blck_lootCountsMinor select 4] call blck_fillBoxes;

if (blck_useSmokeAtCrates) then  // spawn a fire and smoke near the crate
{
	private ["_temp"];
	_temp = [_coords] call blck_smokeAtCrates;
	diag_log format["[minor\sm1.sqf] temporary items are %1", _temp];
	_objects = _objects + _temp;
};
	
_numAIGrp = round((blck_MinAI_Minor + round(random(blck_MaxAI_Minor - blck_MinAI_Minor)))/blck_AIGrps_Minor);
_arc = 360/blck_AIGrps_Minor;
_dir = random 360;
_dist = (20+(random 15));
for "_i" from 1 to blck_AIGrps_Minor do {
	_numAIGrp = round((blck_MinAI_Minor + round(random(blck_MaxAI_Minor - blck_MinAI_Minor)))/blck_AIGrps_Minor);
	_dist = (20+(random 15));
	_xpos = (_coords select 0) + sin (_dir) * _dist;
	_ypos = (_coords select 1) + cos (_dir) * _dist;
	_newPos = [_xpos,_ypos,0];
	_aiGroup = [_newPos,_numAIGrp,_numAIGrp+1,"blue"] call blck_spawnGroup;
	blck_AIMinor = blck_AIMinor + _aiGroup;
	_dir = _dir + _arc;
};
if (blck_useStatic) then 
{
	if (blck_SpawnVeh_Minor == 1) then
	{
		_aiGroup = [_coords,3,4,"RED"] call blck_spawnGroup;
		blck_AIMinor2 = blck_AIMinor + _aiGroup;
		_veh = [_coords,_aiGroup,blck_staticWeapons call BIS_fnc_selectRandom] call blck_spawnEmplacedWeapon;
		_objects = _objects + [_veh];
	};
	if (blck_SpawnVeh_Minor > 1) then
	{
		_arc = 360/blck_SpawnVeh_Minor2;
		_dir = random 360;
		_dist = (15+(random 10));
		for "_i" from 1 to blck_SpawnVeh_Minor do
		{ 
			_dir = _dir + _arc;
			if (_dir > 360) then {_dir = _dir - 360};
			_xpos = (_coords select 0) + sin (_dir) * _dist;
			_ypos = (_coords select 1) + cos (_dir) * _dist;
			_newPos = [_xpos,_ypos,0];		
			_aiGroup = [_newPos,3,4,"RED"] call blck_spawnGroup;
			blck_AIMinor2 = blck_AIMinor + _aiGroup;
			_veh = [_coords,_aiGroup,blck_staticWeapons call BIS_fnc_selectRandom] call blck_spawnEmplacedWeapon;
			_objects = _objects + [_veh];
		};
	};	
};
waitUntil{{isPlayer _x && _x distance _crate < 20 && vehicle _x == _x  } count playableunits > 0};
[_objects, blck_aiCleanUpTimer] spawn blck_cleanupObjects;
[_endMsg] call blck_MessagePlayers;
diag_log "[blckeagls] End of BLUE mission SM1";
MissionGoMinor = false;
