/*
	Detect Threads in form of players.
	
	Update 03.01.2015
	KiloSwiss
*/

_this spawn {	private["_group","_pos","_units","_checkPos","_firstLoop","_possibleThreads","_z"];
	#define getAttacker(WHO) WHO getVariable "gotHitBy"

	_group = _this select 0;
	_pos = _this select 1;
	_checkPos = _pos; _checkPos set [2,2];
	_units = units _group;
	_firstLoop = true;

	{[_x, true] call SEM_fnc_AIdamageEH}count _units;

	while{{alive _x}count units _group > 0}do{

		if(_firstLoop)then[{_firstLoop=false; diag_log "#SEM: Mission AI waiting for their first encounter"},{diag_log "#SEM: Mission AI searching for new possible thread(s)"}];

		waitUntil{ UIsleep 5;	_possibleThreads = [];	//Check if any thread for the AI has been detected
			//Check if any AI is shot by player
			{if(!isNil {getAttacker(_x)})then{if(isPlayer (getAttacker(_x) select 0) && !((getAttacker(_x) select 0) in _possibleThreads))then{
				if((time - (getAttacker(_x) select 1)) < 150)then[{_possibleThreads pushBack (getAttacker(_x) select 0)},{_x setVariable ["gotHitBy", Nil]}];
			}}}forEach _units;	//Do NOT replace forEach with count!
			//Check if any players are near
			{UIsleep 0.1; if(isPlayer _x && alive _x && !(_x in _possibleThreads))then{
				if(_x isKindOf "Epoch_Man_base_F" || _x isKindOf "Epoch_Female_base_F")then[{_possibleThreads pushBack _x},{_z = _x;if(count crew _z > 0)then{{if(isPlayer _x)then{_possibleThreads pushBack _x}}forEach crew _z}}];
			}}forEach (_pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F","Helicopter","Car","Motorcycle"], 500]); //Do NOT replace forEach with count!
			
		(count _possibleThreads > 0)
		};
			/* Thread has been detected */
		diag_log format["#SEM DEBUG: Possible threads: %1", _possibleThreads];

			/* AI react immediately */
		{_group reveal [_x,2]}count _possibleThreads; //Reveal threads
		
		for "_i" from 0 to (count _possibleThreads -1) step 1 do{
			_x = _possibleThreads select _i;
			{if(!(terrainIntersect [_checkPos, [(getPosATL _x) select 0, (getPosATL _x) select 1, ((getPosATL _x) select 2) + 1]]))then[{
				_z = _x; _group reveal [_z,4];
				if((secondaryWeapon _x) == "")then[{
						_x doWatch _z; _x doTarget _z;
						_x commandFire _z; _x suppressFor 10;
				},{
					if !(_z isKindOf "Epoch_Man_base_F" || _z isKindOf "Epoch_Female_base_F")then{
						_x doWatch _z; _x doTarget _z; _x commandFire _z;
					};
				}];
			UIsleep (10+(random 10))},{UIsleep 0.5}]}forEach units _group;	
		};

	}; //End of while loop
};