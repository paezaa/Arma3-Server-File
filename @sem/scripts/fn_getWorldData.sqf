/*
	Returns world Center position and world size/radius from center in a array.
	
	_return = [] call SEM_fnc_getWorldData;
	
	24.01.2015 by KiloSwiss
//_mapSize = (configFile >> "CfgWorlds" >> worldName >> "mapSize") call BIS_fnc_getCfgData;
*/

private["_mapSize","_mapCenter","_worldData"];

_mapSize = getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize");
if(_mapSize > 0)then{
	_worldData = [_mapSize, [(_mapSize/2), (_mapSize/2), 0]];
	if(SEM_debug)then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from config", _mapSize, str worldName]};
}else{
	if((getMarkerPos "center" select 0) > (getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition") select 0))then[{
		_mapSize = (getMarkerPos "center" select 0) * 2;
		_worldData = [_mapSize, getMarkerPos "center"];
		if(SEM_debug)then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from center Marker", _mapSize, str worldName]};
	},{
		_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
		_mapCenter set [2,0];
		_worldData =[(_mapCenter select 0) * 2, _mapCenter];
		if(SEM_debug)then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from default center position", _worldData select 0, str worldName]};	
	}];
};
	
_worldData

/*	To check size on different islands, use this code:
private["_worldRadius","_worldCenterPos","_marker"];
deleteMarkerLocal "Center";
_worldRadius = (getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize")/2);
_worldCenterPos = [ _worldRadius, _worldRadius, 0];
_marker = createMarkerLocal ["Center", _worldCenterPos];
_marker setMarkerPosLocal _worldCenterPos;
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_worldRadius, _worldRadius];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.5;
_marker setMarkerBrushLocal "SolidFull";
copytoClipboard format["%1 / %2 / %3", toLower worldName, _worldRadius*2, _worldCenterPos];
hint format["Copy to clipboard\nUse %4 to paste this information:\n\nWorldName: %1\nSize: %2\nCenter: %3", worldName, _worldRadius*2, _worldCenterPos, str (ctrl+v)];
*/