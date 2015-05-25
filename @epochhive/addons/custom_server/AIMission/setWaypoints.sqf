
private ["_aiGroup","_wp","_wpradius","_wpnum","_oldpos","_newpos","_dir","_dist","_newPos","_xpos","_ypos"];

	_aiGroup = _this select 0;
	
	_aiGroup setSpeedMode (["FULL","NORMAL","LIMITED"]call BIS_fnc_selectRandom);
	_aiGroup setFormation (["WEDGE","VEE","FILE","DIAMOND"]call BIS_fnc_selectRandom);

	_wpradius = 20;
	_wpnum = 6;
	_oldpos = _pos;
	_newpos = _oldpos;
	
	//Set up waypoints for our AI
	for [{ _x=1 },{ _x < _wpnum },{ _x = _x + 1; }] do {
		while{_oldpos distance _newpos < 30}do{ 
				sleep .1;
				_dir = random 360;
				_dist = (15+(random 45));
				_xpos = (_pos select 0) + sin (_dir) * _dist;
				_ypos = (_pos select 1) + cos (_dir) * _dist;
				_newpos = [_xpos,_ypos,0];
		};	
		_oldPos = _newpos;	
		_wppos = [_xpos,_ypos];
		_wp = _aiGroup addWaypoint [_wppos, _wpradius];
		_wp setWaypointType "MOVE";
	};
	_wp = _aiGroup addWaypoint [[_xpos,_ypos,0], _wpradius];
	_wp setWaypointType "CYCLE";
