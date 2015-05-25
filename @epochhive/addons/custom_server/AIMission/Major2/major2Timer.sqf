/*
  Minor Mission timer
  By blckeagls
  Modified by Ghostrider
  See Major\majorTime.sqf for comments
*/

private ["_coords","_wait","_timeDiff","_timeVar","_wait","_startTime","_allAIGroups","_mission","_Major2Missions","_oldAI"];
diag_log "[blckeagls] GREEN mission timer started";
if (isNil "blck_AIMajor2") then { blck_AIMajor2 = [];};

_Major2Missions = ["SM1"];

while {true} do {
	waitUntil {[blck_TMin_Major2, blck_TMax_Major2] call blck_waitTimer};
	blck_AIMajor2 = [];
	_coords = [] call blck_FindSafePosn;
	AllMissionCoords = AllMissionCoords + [_coords];	
	C2coords = _coords;
	publicVariable "C2coords";	
	execVM "debug\addmarkers2.sqf";
	_mission = _Major2Missions call BIS_fnc_selectRandom;
	MissionGoMajor2 = true;
	[_coords] execVM format["\q\addons\custom_server\AIMission\Major2\%1.sqf",_mission];
	waitUntil {!MissionGoMajor2;};
	[] execVM "debug\remmarkers2.sqf";
	C2coords = 0;
	publicVariable "C2coords";
	_oldAI = blck_AIMajor2;
	[_oldAI] spawn blck_AICleanup;	
};