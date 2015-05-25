	// Load additional AI from the group into the vehicle or weapon whenever the AI manning the gun is killed
	
	private ["_veh","_unit","_units","_count"];
	
	// an array of units [unit1, unit 2 ... unitN]
	_veh = _this select 0;
	_count = 0;
	//diag_log format["vehicleMonitor started for vehicle %2: aiGroup contains %1","void",_veh];
	waitUntil { count crew _veh > 0};
	//diag_log "vehicle Manned";
	while {(alive _veh) && _count < 20} do {
		_veh setVehicleAmmo 1;
		_veh setFuel 1;
		_i = 0;
		while {(({alive _x} count crew _veh) < 1) && _count < 3} do 
		{
			//diag_log format["vehicleMonitor detected weapon Unmanned, searching for new unit to man it, aiGroup contains %1","void"];
			//  position nearEntities [typeName, radius]
			_units = _veh nearEntities ["i_g_soldier_unarmed_f",50];
			//_unit = (getPos _veh) nearestObject "i_g_soldier_unarmed_f";
			_count = _count + 1;
			//diag_log format["vehicleMonitor found alive units %1",_units];
			if (count _units > 0) then
			{
				_unit = _units select 0;
				//diag_log format["vehicleMonitor identified a new gunner %1",_unit];
				_unit moveTo getPosATL _veh;
				sleep 10;
				_unit moveingunner _veh;
				//diag_log format["vehicleMonitor manned the weapon with a new gunner %1",_unit];
			};
		};
		sleep 5;
		
	};
	_veh setDamage 1;



