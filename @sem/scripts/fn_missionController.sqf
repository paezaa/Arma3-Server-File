private["_this","_x","_forEachIndex"];
{
[_x,_forEachIndex] spawn { private["_missionsArr","_missionPath","_missionType","_lastMission","_playerOnline","_minPlayers","_randomMission","_runningMission","_runningMissionID"];
	_missionsArr = _this select 0 select 0;
	_missionPath = _this select 0 select 1;
	_missionType = _this select 0 select 2;
	_minPlayers = (	switch(_this select 1)do{
						case 0:	{SEM_MinPlayerStatic};
						case 1:	{SEM_MinPlayerDynamic};
						default	{1};
					});

					
	for "_i" from 0 to (count _missionsArr -1) step 1 do{	// Remove inactive missions
		if((_missionsArr select _i) select 3 < 1)then[{_missionsArr set [_i, "delete"]},{
			if(((_missionsArr select _i) select 2) > 0)then{
				(_missionsArr select _i) set [2, (((_missionsArr select _i) select 2) * 60)];
			};
		(_missionsArr select _i) set [3, 1 max ((_missionsArr select _i) select 3) min 100];
		}];
	};	_missionsArr = _missionsArr - ["delete"];				
	
	if(SEM_debug)then{{_x set [2, (10*60)]}forEach _missionsArr};	// Set mission time out to 10
	
	_lastMission = "";
	while{true}do{
		_playerOnline = playersNumber civilian;
		if(SEM_debug)then{diag_log format["#SEM DEBUG: Online players: %1", playersNumber civilian]};
		if(_playerOnline < _minPlayers)then{
		diag_log format ["#SEM: Waiting for players (%1/%2) to start %3 Missions", _playerOnline, _minPlayers, _missionType];
			waitUntil{	sleep 5; 
				if(playersNumber civilian != _playerOnline)then{	_playerOnline = playersNumber civilian;
					diag_log format ["#SEM: Waiting for players (%1/%2)", _playerOnline, _minPlayers];
				};
			(_playerOnline >= _minPlayers)
			};
		diag_log format["#SEM: Online players: (%1/%2) - Starting next %3 Mission", _playerOnline, _minPlayers, _missionType];
		};

		_start = time;
		if(SEM_debug)then[{sleep 30},{_wait = (SEM_MissionTimerMin*60) max random(SEM_MissionTimerMax*60); waitUntil{sleep 1; (time - _start) >= _wait}}];

		_missionPos = [] call SEM_fnc_findMissionPos;

		_randomMission = [_missionsArr, _lastMission] call SEM_fnc_selectMission;
		_lastMission = _randomMission select 0;
		
		SEM_MissionID = SEM_MissionID + 1;
		_runningMissionID = SEM_MissionID;
		_runningMission = [_missionPos, _randomMission, _runningMissionID] execVM format["%1%2.sqf", _missionPath, _randomMission select 0];
		diag_log format["#SEM: Running Mission %1 %2 at Position %3", _runningMissionID, str (_randomMission select 1), _missionPos];

		_markerPos = _missionPos call SEM_fnc_randomPos;
		SEM_globalMissionMarker = [true,_markerPos,_runningMissionID,_randomMission select 1];
		publicVariable "SEM_globalMissionMarker";	// Let clients create a Marker
		/*localhost*/if(!isDedicated)then{SEM_globalMissionMarker call SEM_client_createMissionMarker};

		waitUntil{sleep 1; scriptDone _runningMission};
		diag_log format["#SEM: Mission %1 finished", str (_randomMission select 1)];
		
		call compile format["if(SEM_mission_%1_return in [1,2])then[{SEM_markerTimeOut = 0},{SEM_markerTimeOut = SEM_MarkerTimeOutS}];", SEM_MissionID];
		SEM_globalMissionMarker = [false,SEM_markerTimeOut,_runningMissionID];	// Let clients delete the Marker
		publicVariable "SEM_globalMissionMarker";
		/*localhost*/if(!isDedicated)then{SEM_globalMissionMarker call SEM_client_createMissionMarker};	
	};
};
}forEach _this;