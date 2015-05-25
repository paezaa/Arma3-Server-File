/*
  Code by blckeagls
  Modified by Ghostrider
  Everythign related to a spawning a Group happens here. 
*/
//Sets Private Variables to they don't interfere when this script is called more than once
private["_pos","_weaponlist","_ammolist","_skinlist","_itemlist","_randomNumberWeapon","_randomNumberSkin","_randomNumberItem","_numbertospawn","_whichweap","_whichitem","_whichskin","_weapon","_ammo","_item",
		"_skin","_i","_skillLevel","_aiGroup","_numai1","_numai2","_safepos","_wppos","_xpos","_ypos","_wpradius","_wpnum","_oldpos","_newpos","_x","_wp","_useLauncher","_launcherType","_aiSkills"];	
		
//Gets variables passed from SM1.sqf
_pos = _this select 0;
_numai1 = [_this,1,5] call BIS_fnc_param;
_numai2 = [_this,2,10] call BIS_fnc_param;
_skillLevel = [_this,3,"blue"] call BIS_fnc_param; // "blue", "red", "green", "orange"
_emplacedWeapon = [_this, 4, "null"] call BIS_fnc_param;

//Spawns correct number of AI
if (_numai2 > _numai1) then {
	_numbertospawn = floor( (random (_numai2 - _numai1) + _numai1 ) );
} else {
	_numbertospawn = _numai2;
};

//Creates a group to make them attack players
_aiGroup = createGroup RESISTANCE;	
_aiGroup setcombatmode blck_combatMode;
_aiGroup allowfleeing 0;
_aiGroup setspeedmode "FULL";
_aiGroup setFormation blck_groupFormation; 

// Determines whether or not the group has launchers
_useLauncher = blck_useLaunchers;

// define weapons list for the group
switch (_skillLevel) do {
	case "blue": {_weaponList = blck_WeaponList_Blue;};
	case "red": {_weaponList = blck_WeaponList_Red;};
	case "green": {_weaponList = blck_WeaponList_Green;};
	case "orange": {_weaponList = blck_WeaponList_Orange;};
	default {_weaponList = blck_WeaponList_Blue;};
};
//diag_log format["[spawnGroup.sqf] _weaponList is %1",_weaponList];
// Select a Launcher if AI are to be equiped with one.
if (blck_useLaunchers) then
{
	_launcherType = blck_launcherTypes call BIS_fnc_selectRandom;
} else {
	_launcherType = "none";
};

//Spawns the correct number of AI Groups, each with the correct number of units
//Counter variable
_i = 0;
while {_i < _numbertospawn} do {
	_i = _i + 1;
	if ((_i > blck_launchersPerGroup)) then  // Only give launchers to the first few AI.
	{ 
		_launcherType = "none"
	};
	
	//Finds a safe positon to spawn the AI in the area given
	_safepos = [_pos,0,27,1,0,2000,0] call BIS_fnc_findSafePos;

	//Spawns the AI unit
	[_safepos,_weaponList,_aiGroup,_skillLevel,_launcherType] call blck_spawnAI;
};
[_aiGroup] call blck_setupWaypoints;
_aiGroup selectLeader (units _aiGroup select 0);
// return the group spawned so that this can be used for mission clean up or triggers regarding completion
units _aiGroup;
