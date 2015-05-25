private["_pos","_timeout","_cleanup","_missionID","_missionObjects","_group","_composition","_compositions","_compositionObjects","_hintString","_start","_units","_endCondition"];
/*
	Based Of drsubo Mission Scripts
	File: bCamp.sqf
	Author: Cammygames, drsubo
	Edited by KiloSwiss
*/

_pos = _this select 0;
_name = _this select 1 select 1;
_timeout = _this select 1 select 2; //Mission timeout
_missionID = _this select 2;
_missionObjects = [];
//--

_compositions =["camp1","camp2","camp3"];
_composition = _compositions select random (count _compositions -1);
_compositionObjects = [_composition, (random 359), _pos] call SEM_fnc_createComposition;
{_missionObjects pushBack _x}forEach _compositionObjects;

_group = [_pos,(12+(random 3))] call SEM_fnc_spawnAI;
{_missionObjects pushBack _x}forEach units _group;
//[_group, _pos] call SEM_fnc_AIdefend;
[_group, _pos] call SEM_fnc_AImove;
//[_group, _pos] spawn SEM_fnc_AIsetOwner;

_hintString = "<t align='center' size='2.0' color='#f29420'>Mission<br/>Bandit Base Camp</t><br/>
<t size='1.25' color='#ffff00'>______________<br/><br/>A bandit camp has been discovered!<br/>
You have our permission to confiscate any property you find as payment for eliminating the threat!";
SEM_globalHint = [0,_hintString]; publicVariable "SEM_globalHint";

	/* Mission End Conditions */
_start = time;
_units = units _group;
waitUntil{	sleep 5;
	_endCondition = [_pos,_units,_start,_timeout,_missionID]call SEM_fnc_endCondition;
	(_endCondition > 0)
};

if(_endCondition == 3)then[{ //Win!
	if(SEM_MissionCleanup > 0)then{[_pos, _missionObjects] call SEM_fnc_missionCleanup};
	_hintString = "<t align='center' size='2.0' color='#6bab3a'>Mission success<br/>
	<t size='1.25' color='#ffff00'>______________<br/><br/>All bandits have been defeated!";
	SEM_globalHint = [_endCondition,_hintString]; publicVariable "SEM_globalHint";
},{	// 1 or 2 = Fail
	{deleteVehicle _x; sleep .1}forEach _missionObjects;
	_hintString = "<t align='center' size='2.0' color='#ab2121'>Mission FAILED</t>";
	SEM_globalHint = [_endCondition,_hintString]; publicVariable "SEM_globalHint";
}];

deleteGroup _group;
