////////////////////////////
// Initialize Mission System
if (isServer) then {
	[] ExecVM "\q\addons\custom_server\init.sqf";
};
 //Everything below this line is only executed on the client (player or local host)
//Messaging for BlckEgls Mission System -- see AIM.sqf 
"blck_Message" addPublicVariableEventHandler {/*titleText[format["%1",_this select 1],"PLAIN DOWN",1];*/systemChat format["%1",_this select 1]};
//This is to spawn the markers for blckegls Mission System when players enter after server has started
[] execVM "debug\addmarkers.sqf";
[] execVM "debug\addmarkers2.sqf";
[] execVM "debug\addmarkers75.sqf";
[] execVM "debug\addmarkers752.sqf";	
