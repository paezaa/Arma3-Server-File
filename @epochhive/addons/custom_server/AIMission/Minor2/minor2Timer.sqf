/*
  Minor Mission timer
  Code by blckeagls
  Modified by Ghostrider
  See Major\majorTimer.sqf for comments
*/
private ["_coords","_wait","_timeDiff","_timeVar","_wait","_startTime","_allAIGroups","_mission","_minor2Missions","_oldAI"];
diag_log "[blckeagls] RED mission timer started";
if (isNil "blck_AIMinor2") then { blck_AIMinor2 = [];};

_minor2Missions = ["SM1"];

while {true} do {
	waitUntil {[blck_TMin_Minor2, blck_TMax_Minor2] call blck_waitTimer};
	blck_AIMinor2 = [];
	_coords = [] call blck_FindSafePosn;
	AllMissionCoords = AllMissionCoords + [_coords];	
	M2coords = _coords;
	publicVariable "M2coords";	
	execVM "debug\addmarkers752.sqf";
	_mission = _minor2Missions call BIS_fnc_selectRandom;
	MissionGoMinor2 = true;
	[_coords] execVM format["\q\addons\custom_server\AIMission\Minor2\%1.sqf",_mission];
	waitUntil {!MissionGoMinor2};
	[] execVM "debug\remmarkers752.sqf";
	M2coords = 0;
	publicVariable "M2coords";
	_oldAI = blck_AIMinor2;
	[_oldAI] spawn blck_AICleanup;	
};