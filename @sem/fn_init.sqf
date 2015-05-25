diag_log "#SEM: Initialize Simple Epoch Missions";
execVM "sem\initMissions.sqf";

[] spawn {
	waitUntil{{isPlayer _x}count playableUnits > 0};
	sleep 60;
	SEM_version = "0.8.1";
	if(SEM_debug)then{	/* Add a looping hint so EVERYONE can see that debug is on */
		SEM_version = SEM_version + " - DEBUG IS ON FOR TESTING PURPOSES\n(ADMIN: Check initMissions.sqf inside sem.pbo)!";
		SEM_version spawn{while{true}do{ sleep 180; publicVariable "SEM_version"}};
	};	publicVariable "SEM_version";
};