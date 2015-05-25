	// Spawn objects from a list of object names and offsets
	
	private ["_coords","_objList","_list","_obj","_xpos","_ypos","_offset","_baseObj"];
	_coords = _this select 0;
	_objList = _this select 1;
	_list = [];
	_obj = nil;
	//diag_log format["spawnCmpObj.sqf] Mission _coords = %1",_coords];
	//diag_log format["spawnCmpObj.sqf] Mission _objList = %1",_objList];
	{
		_obj = _x select 0;
		_offset = _x select 1;
		//diag_log format["[spawnCmpObj.sqf] _x is %3, Object = %1 and Coords = %2",_obj,_offset],_x;
		_xpos = _offset select 0;
		_ypos = _offset select 1;
		_xpos = (_coords select 0) + _xpos;
		_ypos = (_coords select 1) + _ypos;
		_baseObj = createVehicle [_x select 0,[_xpos,_ypos,0],[], 0, "CAN_COLLIDE"];
		//Sets variables (not sure if needed but left just incase so cleanup doesnt happen
		_crate setVariable ["Mission",1,true];
		_crate setVariable ["ObjectID","1",true];
		_crate setVariable ["permaLoot",true,true];
		_list = _list + [_baseObj];
	} forEach _objList;
	
	_list
	




