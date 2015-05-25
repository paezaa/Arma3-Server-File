/*
	Based on code by blckeagls and Vampire
	Modified by Ghostrider
	Updated 1-26-15 
	Because this is precompiled there is less concern about keeping comments in.
	to do:
	1) figure out how to detect the case when AI is killed by being run over and penalize the player
	2) reward players who make legitimate kills
*/
private ["_unit","_killer","_startTime","_grpUnits","_alertDist","_intelligence","_weapons"];
_unit = _this select 0;
_killer = _this select 1;

_alertDist = _unit getVariable ["alertDist",300];
_intelligence = _unit getVariable ["intelligence",1];

if (_alertDist > 0) then {
		{
			if (((position _x) distance (position _unit)) <= _alertDist) then {
				_x reveal [_killer, _intelligence];
				//diag_log "Killer revealed";
			}
		} forEach allUnits;
};
if ((count (units group _unit)) > 1) then {
	if ((leader group _unit) == _unit) then {
		_grpUnits = units group _unit;
		_grpUnits = _grpUnits - [_unit];
		(group _unit) selectLeader (_grpUnits call BIS_fnc_selectRandom);
	};
};

if (blck_launcherCleanup) then 
{
	_Launcher = secondaryWeapon _unit;
	if (_launcher != "") then 
	{
		_launcherRounds = getArray (configFile >> "CfgWeapons" >> _Launcher >> "magazines") select 0;
		_unit removeWeapon _Launcher;
		removeVest _unit;
		{
			if(_x == _launcherRounds) then {
				_unit removeMagazine _x;
			};
		} count magazines _unit;
			
	};
};

if (blck_useNVG) then
{
	if (_unit getVariable ["hasNVG",false]) then
	{
		_unit unassignitem "NVG_EPOCH"; _unit removeweapon "NVG_EPOCH";
	};
};
/*
if (blck_RunGear) then // Adapted from KiloSwiss
{
	private ["_vehicle"];
	
	_vehicle = vehicle _killer;

	if(_vehicle isKindOf "Car")then{
		if(abs speed _vehicle > 0)then{
			if(_vehicle distance _unit < 10)then{
				if(isEngineOn _vehicle || !isNull (driver _vehicle))then{
					diag_log "AIKilled.sqf -- >> Vehicle being damaged";
					blck_vehDamage = _vehicle;
					(owner _vehicle) publicVariableClient "blck_vehDamage";
					{deleteVehicle _x}forEach nearestObjects [(getPosATL _unit), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
					[_unit] call blck_removeGear;
				};
			};
		};
	};
}:
*/
[_unit] joinSilent grpNull;

// unit cleanup moved here
_unit spawn {
	//_this setOwner 1;
	sleep blck_aiCleanUpTimer;
	deleteVehicle _this;
};
