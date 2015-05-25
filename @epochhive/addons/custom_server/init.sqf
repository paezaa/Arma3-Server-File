/*
AI Mission Compiled by blckeagls @ Zombieville.net
Code was modified by blckeagls using other peoples code.  Been over a year, don't have their names anymore.  
Code was modified by Narines fixing several bugs.
Modified by Ghostrider with thanks to ctbcrwker for input, testing, and troubleshooting.
Credits to Vampire, Narines, KiloSwiss, blckeagls, theFUCHS, lazylink, Mark311 who wrote mission systems upon which this one is based and who's code is used with modification in some parts of this addon.

Thanks to cyncrwler for testing and bug fixes.
*/
private ["_version","_versionDate"];
blck_version = "Build 3.0";
blck_versionDate = "4-27-2015";

sleep 30; // wait for other systems to load before initializing

diag_log format["[blckeagls] loading version %1 build %2 ...... >>",blck_versionDate,blck_version];
// Load Configuration information
//call compile preprocessFileLineNumbers "\q\addons\custom_server\AIMission\AIconfigs.sqf";
call compile preprocessFileLineNumbers "\q\addons\custom_server\AIMission\AIconfigs.sqf";

// Get information about the map
sleep 5;
execVM "\q\addons\custom_server\AIMission\findWorld.sqf";
sleep 5;
// compile functions
call compile preprocessFileLineNumbers "\q\addons\custom_server\AIMission\AIfunctions.sqf";

// Load any user-defined specifications or overrides
execVM "\q\addons\custom_server\AIMission\configOverrides.sqf";

//Start the mission timers
[] execVM "\q\addons\custom_server\AIMission\Major\majorTimer.sqf"; //Starts major mission system
[] execVM "\q\addons\custom_server\AIMission\Major2\major2Timer.sqf";//Starts major mission system 2
[] execVM "\q\addons\custom_server\AIMission\Minor\minorTimer.sqf";//Starts minor mission system
[] execVM "\q\addons\custom_server\AIMission\Minor2\minor2Timer.sqf";//Starts minor mission system 2

diag_log "[blckeagls] >>--- Completed initialization"; 
sleep 30;

blck_Initialized = true;

