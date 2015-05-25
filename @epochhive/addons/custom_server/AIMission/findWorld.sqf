/*
	Determine the map name, set the map center and size, and return the map name.
	Spawn coordinates were pulled from the config.cfg
*/
private["_blck_WorldName"];
// Lets get the map name for mission location purposes
_blck_WorldName = toLower format ["%1", worldName];
//diag_log format ["[findWorld.sqf] World Name is = %1", _blck_WorldName];

switch (_blck_WorldName) do {// These may need some adjustment - including a test for shore or water should help as well to avoid missions spawning on water.
	case "altis":{
		//diag_log "Altis-specific settings loaded";
		blck_mapCenter = [6322,7801,0]; 
		blck_mapRange = 12000; 
		if (blck_blacklistSpawns) then {
			diag_log "Spawn black list locations added for Altis";
			blck_locationBlackList = blck_locationBlackList + [[[14939,15083,0],1000],[[23600, 18000,0],1000],[[23600,18000,0],1000]];
		};
	}; // Add Central, East and West respawns/traders 
	case "stratis":{
		diag_log "Stratis-specific settings loaded";
		blck_mapCenter = [6322,7801,0]; 
		blck_mapRange = 4500; 
		if (blck_blacklistSpawns) then {
			blck_locationBlackList = blck_locationBlackList + [[[4031,4222,0],1000],[[1719,5120,0],1000],[[1719,5121,0],1000]];
			diag_log "Spawn black list locations added for Stratis";
		};
	}; // Add Central, East and West respawns/traders 
	case "chernarus":{
		diag_log "Chernarus-specific settings loaded";
		blck_mapCenter = [7100, 7750, 0]; //centerPosition = {7100, 7750, 300};
		blck_mapRange = 5300;
		if (blck_blacklistSpawns) then {
			blck_locationBlackList = blck_locationBlackList + [[[4569.52, 4524.24, 0.201431],800],[[12077.8, 5121.92, 0.00144958],800],[[10688.6, 9428.98, 0.00144958],800]];
			diag_log "Spawn black list locations added for Chernarus";
		};
	};
	case "chernarus_summer":{blck_mapCenter = [7100, 7750, 0]; blck_mapRange = 6000;}; 
	case "bornholm":{
		//diag_log "Bornholm-specific settings loaded";
		blck_mapCenter = [11240, 11292, 0];
		blck_mapRange = 14400;
		if (blck_blacklistSpawns) then {
			blck_locationBlackList = blck_locationBlackList + [[[10058.346680,9015.847656,117.542267],800],[[13812.688477, 6877.921387,80.874428],800],[[13812.661133, 6877.968262,80.876938],800]];
			diag_log "Spawn black list locations added for Bornholm";
		};
	};
	case "tavi":{blck_mapCenter = [10370, 11510, 0];blck_mapRange = 14090;};
	case "lingor":{blck_mapCenter = [4400, 4400, 0];blck_mapRange = 4400;};
	case "namalsk":{blck_mapCenter = [4352, 7348, 0]};
	case "napf":{blck_mapCenter = [10240, 10240, 0];blck_mapRange = 10240;};
	case "panthera2":{blck_mapCenter = [4400, 4400, 0];blck_mapRange = 4400;};
	case "isladuala":{blck_mapCenter = [4400, 4400, 0];blck_mapRange = 4400;};
	case "sauerland":{blck_mapCenter = [12800, 12800, 0];blck_mapRange = 12800;};
	case "trinity":{blck_mapCenter = [6400, 6400, 0];blck_mapRange = 6400;};
	case "utes":{blck_mapCenter = [3500, 3500, 0];blck_mapRange = 3500;};
	case "zargabad":{blck_mapCenter = [4096, 4096, 0];blck_mapRange = 4096;};
	case "fallujah":{blck_mapCenter = [3500, 3500, 0];blck_mapRange = 3500;};
	case "takistan":{blck_mapCenter = [5500, 6500, 0];blck_mapRange = 5000;};	
	default {
			_blck_WorldName = "default";  // provide the defaults for "altis"			
			blck_mapCenter = [6322,7801,0]; 
			blck_mapRange = 12000;
	};

};
if (_blck_WorldName == "default") then {
	diag_log "[blckeagls]: Unknown map. Default World Settings Used";
} else {
	diag_log format["[blckeagls]: Worldname is %1. Map Specific Settings Defined",_blck_WorldName];
};

blck_WorldName = _blck_WorldName;
