	// Delete objects in a list after a certain time.
	
	private ["_buildings","_done","_startTime","_units"];
	_buildings = _this select 0;
	_waitTime = _this select 1;

	_startTime = diag_tickTime;
	waitUntil {sleep 10; (diag_tickTime - _startTime) > _waitTime;};

	{
		//diag_log format["[cleanupObjects.sqf] Deleting object %1", _x];
		deleteVehicle _x;
	} forEach _buildings;
	




