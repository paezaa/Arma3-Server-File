	/* KiloSwiss */
_this spawn { private ["_pos","_objs","_sGren"];
	_pos = _this select 0;
	_objs = _this select 1;

	UIsleep (SEM_MissionCleanup *60);
	
	for "_i" from 0 to 300 step 60 do{ private ["_posX","_posY","_sGren"];
		_dir = _i;
		_posX = (_pos select 0) + sin (_dir) * 25;
		_posY = (_pos select 1) + cos (_dir) * 25;
		_sGren = "SmokeShell" createVehicle [_posX,_posY,0];
		_objs pushBack _sGren;
	};
	sleep 20;
	{
		if(_x distance _pos < 250)then{
			deleteVehicle _x;
		}; sleep .1;
	}forEach _objs;
};