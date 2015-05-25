if(hasInterface)then{execVM "semClient.sqf"};
// Welcome Credits by Gr8
[] execVM "custom\welcome.sqf";
playMusic "intro";

[] execVM "addons\messages\init.sqf";

//Status Bar
	if(hasInterface) then{[] execVM "addons\Status_Bar\init_statusBar.sqf"};
	
//////////////////////////////////////////////////////////////////////////
//cmEARPLUGS CODE START

call compile preProcessFileLineNumbers "cmEarplugs\config.sqf";

//cmEARPLUGS CODE END
//////////////////////////////////////////////////////////////////////////



//ADD ATMs in traders
[] execVM "custom\atm.sqf";

// Add this at the top of your Init.sqf
#include "start_blck.sqf";
[] execVM "trader\init.sqf";
[] execVM "trader\HALV_takegive_crypto_init.sqf"; 

#include "A3EAI_Client\A3EAI_initclient.sqf";


//#include "start_sdrop.sqf";
//Supply Drop Alert Event

//"SDROP_Alert" addPublicVariableEventHandler {
//	titleText[format["%1",_this select 1],"PLAIN DOWN",1];
//};
