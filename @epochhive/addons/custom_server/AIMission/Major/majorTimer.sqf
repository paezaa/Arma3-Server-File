/*
  Minor Mission timer
  Originial code by blckeagls
  Modified by Ghostrider
*/
// Loop to spawn Orange (Major) missions at intervals specified by blck_TMin_Major and blck_TMax_Major

private ["_coords","_allAIGroups","_mission","_MajorMissions","_oldAI"];
diag_log "[blckeagls] Orange mission timer started";
// Use a global variable to store a list of AI units associated with this mission
if (isNil "blck_AIMajor") then { blck_AIMajor = [];};

// Define an array of possible missions
_MajorMissions = ["SM1"];

while {true} do {
	//diag_log "---->>>> Start of Mission Timer Loop";
	waitUntil {[blck_TMin_Major, blck_TMax_Major] call blck_waitTimer};
	blck_AIMajor = [];
	//Find a safe position on map to spawn marker and AI units
	_coords = [] call blck_FindSafePosn;
	AllMissionCoords = AllMissionCoords + [_coords];
	// Display a map marker for all players
	Ccoords = _coords;
	publicVariable "Ccoords";	
	execVM "debug\addmarkers.sqf";
	// select a mission from the list of available missions
	_mission = _MajorMissions call BIS_fnc_selectRandom;
	// Everything is ready, time to spawn the mission
	MissionGoMajor = true;
	[_coords] execVM format["\q\addons\custom_server\AIMission\Major\%1.sqf",_mission];
	// Wait until the mission script has ended. It should toggle MissionGoMajor to false so that the loop will proceed
	waitUntil {!MissionGoMajor};
	// Clear markers from player maps
	// To Do: add  a delay here and possibly a marker of another type and color.
	[] execVM "debug\remmarkers.sqf";
	Ccoords = 0;
	publicVariable "Ccoords";
	// remove any alive AI hanging around from the last missions after waiting for the body clean up time
	// and delete the groups they were associated with
	_oldAI = blck_AIMajor;
	[_oldAI] spawn blck_AICleanup;	
};