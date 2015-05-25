/*
	EMS Mission end condition
	
	_return = [_pos,_units,_start,_timeout,[_obj1,_obj2,_obj3]]call SEM_fnc_endCondition;
	
	Returns:
	 0 = false (default when no condition is met)
	 1 = time is up and no player is nearby
	 2 = All objects (vehicles) are destroyed
	 3 = AI is dead
	
*/
private["_pos","_units","_start","_timeOut","_objects","_return","_playerPresent"];

_pos = _this select 0;
_units = _this select 1;
_start = _this select 2;
_timeOut = _this select 3;
_missionID = _this select 4;
if(count _this > 5)then[{_objects = _this select 5},{_objects = []}];


_return = 0;
_playerPresent = false;

if(_timeOut > 0)then{ //Mission time out possible
	if(time - _start >= _timeOut)then{ //Time is up
		/* Check for players in the area */
		{ sleep 0.1;
			if(isPlayer _x && _x distance _pos < 500)exitwith{_playerPresent = true};
		}forEach (if(isMultiplayer)then[{playableUnits},{allUnits}]); 	//(_pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F"], 250]);	//"Epoch_Male_F","Epoch_Female_F"
		if(!_playerPresent)then{_return = 1};
		call compile format["SEM_mission_%1_return = 1;", _missionID];
	};
};

if(_return < 1 && count _objects > 0)then{
	//if({damage _x == 1}count _objects == count _objects)then{_return = 2};
	if({alive _x}count _objects == 0)then{_return = 2};
	call compile format["SEM_mission_%1_return = 2;", _missionID];
};
	
if(_return < 2)then{
	if({alive _x} count _units < 1)then{_return = 3};
	call compile format["SEM_mission_%1_return = 3;", _missionID];
};

_return
