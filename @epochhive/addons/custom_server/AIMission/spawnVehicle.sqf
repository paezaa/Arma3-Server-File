//Debug information 
diag_log format["SpawnVehicles _this: %1",_this];
private["_pos","_noVeh","_aiGroup","_safepos","_ai","_ai1","_slot","_veh","_i"];

//Gets position information from spawnai1.sqf
_pos = _this select 0;
_noVeh = _this select 1;
if (_noVeh < 1) exitWith {};

//Creates a group for Vehicles
_aiGroup = createGroup RESISTANCE;	
//_aiGroup = _this select 1;
_aiGroup setcombatmode "RED";
_aiGroup allowfleeing 0;
_aiGroup setspeedmode "FULL";

// spawn in _noVeh pickups with machine gun and load 2 AI into each then return a group containing those AI
for "_i" from 1 to _noVeh do {
		//Finds a safe positon in area to spawn
		_safepos = [_pos,0,27,0,0,20,0] call BIS_fnc_findSafePos;

		//Spawns 1 AI Unit
		"O_G_Soldier_SL_F" createUnit [_safepos, _aiGroup, "_ai = this", 0.1, "PRIVATE"];
		removeBackpackGlobal _ai;
		removeAllItemsWithMagazines  _ai;
		_ai setVariable["LASTLOGOUT_EPOCH",1000000000000];
		_ai setVariable["LAST_CHECK",1000000000000];
		_ai enableAI "TARGET";
		_ai enableAI "AUTOTARGET";
		_ai enableAI "MOVE";
		_ai enableAI "ANIM";
		_ai enableAI "FSM";
		_ai allowDammage true;
		_ai setCombatMode "RED";
		_ai setBehaviour "COMBAT";
		_ai setVariable ["AI",true,true];

		//Spawns 1 AI Unit
		_ai1 = ObjNull;
		_safepos = [_pos,0,27,0,0,20,0] call BIS_fnc_findSafePos;
		"O_G_Soldier_SL_F" createUnit [_safepos, _aiGroup, "_ai1 = this", 0.1, "PRIVATE"];
		removeBackpackGlobal _ai1;
		removeAllItemsWithMagazines  _ai1;
		_ai1 setVariable["LASTLOGOUT_EPOCH",1000000000000];
		_ai1 setVariable["LAST_CHECK",1000000000000];
		_ai1 enableAI "TARGET";
		_ai1 enableAI "AUTOTARGET";
		_ai1 enableAI "MOVE";
		_ai1 enableAI "ANIM";
		_ai1 enableAI "FSM";
		_ai1 allowDammage true;
		_ai1 setCombatMode "RED";
		_ai1 setBehaviour "COMBAT";
		_ai1 setVariable ["AI",true,true];

		//Spawns a AI Vehicle
		_safepos = [_pos,0,27,0,0,20,0] call BIS_fnc_findSafePos;
		_veh = ObjNull;
		_veh = createVehicle["B_G_Offroad_01_armed_EPOCH", _safepos, [], 0, "NONE"];
		_veh setVariable["LASTLOGOUT_EPOCH",1000000000000];
		_veh setVariable["LAST_CHECK",1000000000000];
		//Moves 2 AI units into vehicle
		_ai moveInAny _veh;
		_ai1 moveInAny _veh;
		//So Vehicle doesnt despawn
		EPOCH_VehicleSlotsLimit = EPOCH_VehicleSlotsLimit + 1;
		EPOCH_VehicleSlots pushBack str(EPOCH_VehicleSlotsLimit);
		_slot = EPOCH_VehicleSlots select 0;
		_veh setVariable ['VEHICLE_SLOT',_slot,true];
		EPOCH_VehicleSlots = EPOCH_VehicleSlots - [_slot];
		EPOCH_VehicleSlotCount = count EPOCH_VehicleSlots;
		publicVariable 'EPOCH_VehicleSlotCount';
		_veh call EPOCH_server_setVToken;
		//Creates vehicle inventory
		clearWeaponCargoGlobal    _veh;
		clearMagazineCargoGlobal  _veh;
		clearBackpackCargoGlobal  _veh;
		clearItemCargoGlobal      _veh;
};

units _aiGroup;