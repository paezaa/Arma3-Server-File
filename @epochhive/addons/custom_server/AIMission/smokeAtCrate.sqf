
private ["_pos","_objs","_smokeSource","_smokeTrail","_fire","_posFire","_smoke","_dis","_minDis","_maxDis","_closest"];

_objs = [];

// http://www.antihelios.de/EK/Arma/index.htm
_wrecks = ["Land_Wreck_Car2_F","Land_Wreck_Car3","Land_Wreck_Car_F","Land_Wreck_Offroad2_F","Land_Wreck_Offroad_F","Land_Tyres_F","Land_Pallets_F","Land_MetalBarrel_F"];
_smokeSource = _wrecks call BIS_fnc_selectRandom;  
// Use the Land_Fire_burning item if you want a bright visual cue at night but be forewarned that the flames are blinding with NVG at close range and may damage players
_smokeTrail = "test_EmptyObjectForSmoke"; // "options are "test_EmptyObjectForFireBig", "test_EmptyObjectForSmoke"
_pos = _this select 0;
_dis = 0;

// _minDis and _maxDis determine the spacing between the smoking item and the loot crate.
_minDis = 5;
_maxDis = 8;
_closest = 10;

while {_dis < 7} do
{
	_posFire = [_pos, _minDis, _maxDis, _closest, 0, 20, 0] call BIS_fnc_findSafePos;  // find a safe spot near the location passed in the call
	_dis = _posFire distance _pos;
};
_fire = createVehicle [_smokeSource, _posFire, [], 0, "can_collide"];
_fire setVariable ["LAST_CHECK", (diag_tickTime + 14400)];
_fire setPos _posFire;
_fire setDir floor(random(360));
_objs = _objs + [_fire];
_smoke = createVehicle [_smokeTrail, _posFire, [], 0, "can_collide"];  // "test_EmptyObjectForSmoke" createVehicle _posFire;  
_smoke setVariable ["LAST_CHECK", (diag_tickTime + 14400)];
_smoke attachto [_fire, [0,0,-1]]; 
_objs = _objs + [_smoke];

_objs