/*
	Code by blckeagls
	Modified by Ghostrider
	Logic for adding AI Ammo, GL Shells and Attachments by Vampire.
	Code to delete dead AI bodies moved to AIKilled.sqf
	Everything having to do with spawning and configuring an AI should happen here
*/

//Defines private variables so they don't interfere with other scripts
private ["_pos","_i","_weap","_ammo","_other","_skin","_aiGroup","_ai1","_magazines","_players","_owner","_ownerOnline","_nearEntities","_skillLevel","_aiSkills","_specialItems",
		"_Launcher","_launcherRound","_Vests","_vest","_index","_WeaponAttachments","_Meats","_Drink","_Food","_aiConsumableItems","_weaponList","_ammoChoices","_attachment","_attachments"];

_Vests = [
"V_1_EPOCH","V_2_EPOCH","V_3_EPOCH","V_4_EPOCH","V_5_EPOCH","V_6_EPOCH","V_7_EPOCH","V_8_EPOCH","V_9_EPOCH","V_10_EPOCH","V_11_EPOCH","V_12_EPOCH","V_13_EPOCH","V_14_EPOCH","V_15_EPOCH","V_16_EPOCH","V_17_EPOCH","V_18_EPOCH","V_19_EPOCH","V_20_EPOCH","V_21_EPOCH","V_22_EPOCH","V_23_EPOCH","V_24_EPOCH","V_25_EPOCH","V_26_EPOCH","V_27_EPOCH","V_28_EPOCH","V_29_EPOCH","V_30_EPOCH","V_31_EPOCH","V_32_EPOCH","V_33_EPOCH","V_34_EPOCH","V_35_EPOCH","V_36_EPOCH","V_37_EPOCH","V_38_EPOCH","V_39_EPOCH","V_40_EPOCH"
];
_WeaponAttachments = [
"acc_flashlight","acc_pointer_IR","optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_SOS",
"optic_MRCO","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M",
"muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_acp"
];
//CraftingFood
_Meats=[
"SnakeCarcass_EPOCH","RabbitCarcass_EPOCH","ChickenCarcass_EPOCH","GoatCarcass_EPOCH","SheepCarcass_EPOCH"
];
_Drink = [
"WhiskeyNoodle","ItemSodaOrangeSherbet","ItemSodaPurple","ItemSodaMocha","ItemSodaBurst","ItemSodaRbull"
];
_Food = [
"FoodBioMeat","FoodMeeps","FoodSnooter","FoodWalkNSons","sardines_epoch","meatballs_epoch","scam_epoch","sweetcorn_epoch","honey_epoch","CookedSheep_EPOCH","CookedGoat_EPOCH","SnakeMeat_EPOCH",
"CookedRabbit_EPOCH","CookedChicken_EPOCH","ItemTrout","ItemSeaBass","ItemTuna"
];
_aiConsumableItems = _Meats + _Drink + _Food;

//Gets variables passed from spawnai.sqf/spawnai1.sqf
_pos = _this select 0;  // Position at which to spawn AI
_weaponList = _this select 1;
_aiGroup = _this select 2;  // Group to which AI belongs
_skillLevel = [_this,3,"red"] call BIS_fnc_param;   // Assign a skill level in case one was not passed."blue", "red", "green", "orange"
_Launcher = [_this, 4, "none"] call BIS_fnc_param; // Set launchers to "none" if no setting was passed.

//Creating the AI Unit
_ai1 = ObjNull;
//Creates the AI unit from the _skin passed to it
"i_g_soldier_unarmed_f" createUnit [_pos, _aiGroup, "_ai1 = this", 0.7, "COLONEL"];
//Cleans the AI to a fresh spawn
removeBackpackGlobal _ai1;
removeAllItemsWithMagazines  _ai1;
// Dress the AI in a randomly chosen skin.
_skin = blck_SkinList call BIS_fnc_selectRandom;
//_ai1 AddUniform _skin;
_ai1 forceAddUniform _skin;

//Stops the AI from being cleaned up
_ai1 setVariable["LASTLOGOUT_EPOCH",1000000000000];
_ai1 setVariable["LAST_CHECK",1000000000000];

//Sets AI Tactics
_ai1 enableAI "TARGET";
_ai1 enableAI "AUTOTARGET";
_ai1 enableAI "MOVE";
_ai1 enableAI "ANIM";
_ai1 enableAI "FSM";
_ai1 allowDammage true;
_ai1 setBehaviour "COMBAT";
_ai1 setunitpos "AUTO";

sleep 1; //For some reason without this sometimes they don't spawn the weapon on them

// Add a vest to AI for storage
_vest = _Vests call BIS_fnc_selectRandom;
_ai1 addVest _vest;

// Add a primary weapon : Vampires logic used here.
_weap = _weaponList call BIS_fnc_selectRandom;
//diag_log format["[spawnUnit.sqf] _weap os %1",_weap];
_ai1 addWeaponGlobal  _weap; 
// get the ammo that can be used with this weapon. This function returns an array with all possible ammo choices in it.
_ammoChoices = getArray (configFile >> "CfgWeapons" >> _weap >> "magazines");
_ammo = _ammoChoices call BIS_fnc_selectRandom;
//diag_log format["[spawnUnit.sqf] _ammo returned as %1",_ammo];
for "_i" from 0 to (floor(random 3)) do {
	_ai1 addMagazine _ammo;
};

// If the weapon has a GL, add some rounds for it: based on Vampires code
if ((count(getArray (configFile >> "cfgWeapons" >> _weap >> "muzzles"))) > 1) then {
	_ai1 addMagazine "1Rnd_HE_Grenade_shell";
};
/*
// 30%  Chance that an attachment will be added (based on Vampire's code)
if ((floor(random(10))) <= 3) then {
	_attachments = (getArray (configFile >> "cfgLootTable" >> "Scopes" >> "items"));  // returns an array of arrays [[["attachment name",typeOf],integer], [...]];
	//diag_log format["[spawnUnit.sqf] -- The attachments available for this weapon are %1",_attachments];
	_attachment = _attachments call BIS_fnc_selectRandom; // These are 
	diag_log format[" -- >> SpawnUnit.sqf - about to add an attachment of type %1",_attachment];  // [["attachment name","type"],1-6]
	_attachment = _attachment select 0;
	diag_log format["spawnUnit.sqf -- >> Attachment has been parsed to %1",_attachment];
	_ai1 addPrimaryWeaponItem _attachment;
};
*/
sleep 1; //For some reason without this sometimes they don't spawn the weapon on them

//adds 3 random items to AI.  _other = ["ITEM","COUNT"]
_i = 0;
while {_i < 3} do {
	_i = _i + 1;
	_ai1 addItem (_aiConsumableItems call BIS_fnc_selectRandom);
};

// Add an FAK or Grenade 50% of the time
if (round(random 10) <= 9) then 
{
	_specialItems = ["HandGrenade","FAK"];
	
	_item = _specialItems call BIS_fnc_selectRandom;
	//diag_log format["spawnUnit.sqf] -- Item is %1", _item];
	_ai1 addItem _item;
};
if (_Launcher != "none") then
{
	_ai1 addWeaponGlobal _Launcher;
	_launcherRound = getArray (configFile >> "CfgWeapons" >> _Launcher >> "magazines") select 0;
	//diag_log format["[spawnUnit.sqf] Launcher round is %1",_launcherRound];
	for "_i" from 1 to 3 do 
	{
		//diag_log format["[spawnUnit.saf] Adding Launcher Round %1 ",_launcherRound];
		_ai1 addItemToVest _launcherRound;
	};
	_ai1 selectWeapon (secondaryWeapon _ai1);
};

if(sunOrMoon < 0.2 && blck_useNVG)then
{
	_ai1 addWeapon "NVG_EPOCH";
	_ai1 setVariable ["hasNVG", true];
}
else
{
	_ai1 setVariable ["hasNVG", false];
};

// Infinite ammo
_ai1 addeventhandler ["fired", {(_this select 0) setvehicleammo 1;}];

// Do something if AI is killed
_ai1 addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] execVM blck_AIKilled; }]; // changed to reduce number of concurrent threads, but also works as spawn blck_AIKilled; }];

switch (_skillLevel) do 
{
	case "blue": {_index = 0;_aiSkills = blck_SkillsBlue;};
	case "red": {_index = 1;_aiSkills = blck_SkillsRed;};
	case "green": {_index = 2;_aiSkills = blck_SkillsGreen;};
	case "orange": {_index = 3;_aiSkills = blck_SkillsOrange;};
	default {_index = 0;_aiSkills = blck_SkillsBlue;};
};

_alertDist = blck_AIAlertDistance select _index; 
_intelligence = blck_AIIntelligence select _index;

[_ai1,_aiSkills] call blck_setSkill;
_ai1 setVariable ["alertDist",_alertDist,true];
_ai1 setVariable ["intelligence",_intelligence,true];

_ai1