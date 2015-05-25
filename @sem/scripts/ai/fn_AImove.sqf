/* KiloSwiss */
_this call SEM_fnc_findthread;

_this spawn {	private["_group","_pos","_owner","_firstLoop","_oldPos","_newPos","_dir","_dist","_posX","_posY","_wp"];																							
	_group = _this select 0; 
	_pos = _this select 1;

	_firstLoop = true;
	_oldPos = [0,0,0];
	_newPos = _pos;
	
	while{{alive _x}count units _group > 0 /*&& !isPlayer _owner && owner (units _group select 0) == owner _owner && !local (units _group select 0)*/}do{
		/*
		if(_firstLoop)then[{_firstLoop = false},{
			waitUntil{ sleep 10; _doMove = true;
				_nearPlayers = _pos nearEntities [["Epoch_Male_F","Epoch_Female_F"], 250];	//"Epoch_Man_base_F","Epoch_Female_base_F"
				diag_log format["#SEM DEBUG: Near players: %1 %2", count _nearPlayers, _nearPlayers];
				if({isPlayer _x}count _nearPlayers > 0)then{
					if({isPlayer _x && !(terrainIntersect [_checkPos, getPosATL _x])}count _nearPlayers > 0)then{_doMove = false};
					// Only order the AI to move when they do not have a LOS to nearby enemy players
				};
			(_doMove)
			};
		}];
		*/
		while{_oldPos distance _newPos < 30}do{ sleep .1;
			_dir = random 360;
			_dist = (15+(random 45));
			_posX = (_pos select 0) + sin (_dir) * _dist;
			_posY = (_pos select 1) + cos (_dir) * _dist;
			_newPos = [_posX, _posY, 0];
		};	_oldPos = _newPos;

			_group move _newPos;
			//{_x doMove _newPos; _x move _newPos; _x moveTo _newPos}count units _group;
		_group setSpeedMode (["FULL","NORMAL","LIMITED"]call BIS_fnc_selectRandom);
		_group setFormation (["WEDGE","VEE","FILE","DIAMOND"]call BIS_fnc_selectRandom);

		sleep (10+(random 20));
	};
	diag_log format["#SEM: AI moving stopped - Remaining AIs: (%1/%2)", {alive _x}count units _group, count units _group];
};