private["_pos","_cnt","_group","_unit","_wpn","_opt","_Umale","_Ufemale","_Uciv","_Ukart","_rifles","_riflesGL","_LMGs","_SMGs","_rifleOptics","_smgOptics","_Sniper","_loadoutsAssigned"];
/*
	File: ai.sqf
	Author: drsubo
	usage : [_uLoc] execVM
	
	Update 03.01.2015
	Re-written by KiloSwiss
*/

_pos = _this select 0;
_cnt = (if(count _this > 1)then[{(_this select 1) max 5},{7}]); //Unit Count (min 5 - default 7)
_group = createGroup RESISTANCE;

while{count (units _group) < _cnt}do{
	_group createUnit ['I_Soldier_EPOCH', _pos, [], 10, 'NO_COLLIDE'];
	sleep 0.1;
};

{
_x call SEM_fnc_AIkilledEH;
_x call SEM_fnc_AIfiredEH;
_x call SEM_fnc_stripUnit;
_x setVariable["LASTLOGOUT_EPOCH",99999999];
}count units _group;

if(SEM_AIdisableSniperDamage)then{
	units _group call SEM_fnc_broadcastAI;
};

diag_log format["#SEM: Spawned %1 units at position %2", count units _group, _pos];

//GEAR
//Special uniforms: U_O_GhillieSuit , U_O_Wetsuit
//Special Female: U_ghillie1_uniform , U_ghillie2_uniform , U_ghillie3_uniform , U_Wetsuit_uniform , U_Wetsuit_White , U_Wetsuit_Blue , U_Wetsuit_Purp , U_Wetsuit_Camo
//Female vests = _female addVest format["V_F%_EPOCH", round(random 5)];
//Female headgear = _female addHeadgear format["H_F%_EPOCH", round(random 5)];
//Sidepacks: Male: V_41_EPOCH - Female: V_F41_EPOCH

_Umale = ["U_O_CombatUniform_ocamo","U_O_PilotCoveralls","U_OG_leader"];

_Ufemale = ["U_Camo_uniform","U_CamoBlue_uniform","U_CamoBrn_uniform","U_CamoRed_uniform"];

_Uguer = ["U_OG_Guerilla1_1","U_OG_Guerilla2_1","U_OG_Guerilla2_2","U_OG_Guerilla2_3","U_OG_Guerilla3_1","U_OG_Guerilla3_2"];

_Uciv = ["U_C_Poloshirt_stripped","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon",
		"U_C_Poloshirt_redwhite","U_C_Poor_1","U_C_WorkerCoveralls","U_C_Journalist","U_C_Scientist","U_OrestesBody"];
		
_Ukart = ["U_C_Driver_1","U_C_Driver_2","U_C_Driver_3","U_C_Driver_4","U_C_Driver_1_black","U_C_Driver_1_blue",
		"U_C_Driver_1_green","U_C_Driver_1_red","U_C_Driver_1_white","U_C_Driver_1_yellow","U_C_Driver_1_orange"];

//1911_pistol_EPOCH	"9rnd_45X88_magazine"
//ruger_pistol_epoch "10rnd_22X44_magazine"
//hgun_PDW2000_F
//hgun_ACPC2_F
//hgun_Rook40_F
//hgun_P07_F
//hgun_Pistol_heavy_01_F
//hgun_Pistol_heavy_02_F
//hgun_Pistol_Signal_F
	
_rifles = [
	["akm_EPOCH",				"30Rnd_762x39_Mag"],
	["m16_EPOCH",				"30Rnd_556x45_Stanag_Tracer_Yellow"],
	["m16Red_EPOCH",			"30Rnd_556x45_Stanag_Tracer_Green"],
	["m4a3_EPOCH",				"30Rnd_556x45_Stanag_Tracer_Red"],
	["Arifle_Katiba_C_F",		"30Rnd_65x39_caseless_green_mag_Tracer"],
	["Arifle_Mk20_F",			"30Rnd_556x45_Stanag_Tracer_Red"],
	["Arifle_Mk20C_F",			"30Rnd_556x45_Stanag_Tracer_Green"],
	["Arifle_Mk20C_plain_F",	"30Rnd_556x45_Stanag_Tracer_Red"],
	["Arifle_Mk20_plain_F",		"30Rnd_556x45_Stanag_Tracer_Red"],
	["Arifle_MXC_F",			"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MXC_Black_F",		"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_F",				"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_Black_F",		"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_SDAR_F",			"30Rnd_556x45_Stanag_Tracer_Red"],
	["Arifle_TRG21_F",			"30Rnd_556x45_Stanag_Tracer_Green"],
	["Arifle_TRG20_F",			"30Rnd_556x45_Stanag_Tracer_Yellow"]
];

_riflesGL = [
	["Arifle_Katiba_GL_F",		"30Rnd_65x39_caseless_green_mag_Tracer"],
	["Arifle_Mk20_GL_F",		"30Rnd_556x45_Stanag_Tracer_Yellow"],
	["Arifle_Mk20_GL_plain_F",	"30Rnd_556x45_Stanag_Tracer_Yellow"],
	["Arifle_MX_GL_F",			"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_GL_Black_F",	"30Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_TRG21_GL_F",		"30Rnd_556x45_Stanag_Tracer_Green"]
];

_LMGs = [
	["m249_EPOCH",				"200Rnd_556x45_M249"],
	["m249Tan_EPOCH",			"200Rnd_556x45_M249"],
	["LMG_Mk200_F",				"200Rnd_65x39_cased_Box_Tracer"],
	["Arifle_MX_SW_F",			"100Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_SW_Black_F",	"100Rnd_65x39_caseless_mag_Tracer"],
	["LMG_Zafir_F",				"150Rnd_762x51_Box_Tracer"]
];

_rifleOptics = ["optic_Aco","optic_ACO_grn","optic_Holosight"]; //"optic_Hamr","optic_Arco"

_SMGs = [
	["SMG_02_F",		"30Rnd_9x21_Mag"],
	["SMG_01_F",		"30Rnd_45ACP_Mag_SMG_01"],
	["Hgun_PDW2000_F",	"30Rnd_9x21_Mag"]
];

_smgOptics = ["optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight_smg"];


_DMRs = [
	["M14_EPOCH",			"20Rnd_762x51_Mag"],
	["M14Grn_EPOCH",		"20Rnd_762x51_Mag"],
	["srifle_EBR_F",		"20Rnd_762x51_Mag"],
	["srifle_DMR_01_F",		"10Rnd_762x51_Mag"],
	["arifle_MXM_F",		"30Rnd_65x39_caseless_mag_Tracer"],
	["arifle_MXM_Black_F",	"30Rnd_65x39_caseless_mag_Tracer"]
];

//"optic_Nightstalker", "optic_SOS", "optic_LRPS", "optic_DMS"
_Sniper = [
	["m107_EPOCH",		"5Rnd_127x108_Mag"],
	["m107Tan_EPOCH",	"5Rnd_127x108_Mag"],
	["Srifle_GM6_F",	"5Rnd_127x108_Mag"],
	["Srifle_LRR_F",	"7Rnd_408_Mag"]
];
	
if(sunOrMoon < 0.1)then{{_x addWeapon "NVG_EPOCH"}count units _group};

//Special Hunter (leader)
_unit = units _group select 0;
_unit setSkill 0.7;
_unit forceAddUniform "U_OG_leader";
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_wpn = _DMRs select (random (count _DMRs -1));
_unit addWeapon (_wpn select 0);
_unit addMagazines [(_wpn select 1), 6];
_unit addPrimaryWeaponItem "optic_Arco"; 


//Sniper
_unit = units _group select 1;
_unit setSkill 0.8;
_unit forceAddUniform  "U_O_GhillieSuit"; //"U_ghillie1_uniform";
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
//_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_wpn = _Sniper select (random (count _Sniper -1));
_unit addWeapon (_wpn select 0);
_unit addMagazines [(_wpn select 1), 4];
_unit addPrimaryWeaponItem "optic_SOS";
_unit selectWeapon (primaryWeapon _unit);

_unit addWeapon "1911_pistol_EPOCH"; //hgun_Pistol_heavy_01_F - 11Rnd_45ACP_Mag - optic_MRD
_unit addMagazines ["9rnd_45X88_magazine", 4];


//Rifleman
_unit = units _group select 2;
_unit setSkill 0.6;
_unit forceAddUniform  (_Uguer select (random (count _Uguer -1)));
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_wpn = _riflesGL select (random (count _riflesGL -1));
_unit addWeapon (_wpn select 0);
_unit addMagazines [(_wpn select 1), 4];
_unit addMagazines ["1Rnd_HE_Grenade_shell", 4];
_unit addPrimaryWeaponItem (_rifleOptics select (random (count _rifleOptics -1)));


//MG
_unit = units _group select 3;
_unit setSkill 0.6;
_unit forceAddUniform  "U_O_CombatUniform_ocamo";
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_wpn = _LMGs select (random (count _LMGs -1));
_unit addWeapon (_wpn select 0);
_unit addMagazines [(_wpn select 1), 2];
_unit addPrimaryWeaponItem "optic_Hamr";


//Anti Tank
_unit = units _group select 4;
_unit setSkill 0.7;
_unit forceAddUniform  "U_O_CombatUniform_ocamo";
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_unit addBackPack "B_Carryall_ocamo";
_unit addMagazines ["RPG32_HE_F", 1];
_unit addMagazines ["RPG32_F", 1];
_unit addWeapon "launch_RPG32_F";

_wpn = _SMGs select (random (count _SMGs -1));
_opt = _smgOptics select (random (count _smgOptics -1));
_unit addWeapon (_wpn select 0);
_unit addMagazines [(_wpn select 1), 3];
_unit addPrimaryWeaponItem _opt;
_unit selectWeapon (secondaryWeapon _unit);

/*
//Diver
_unit = units _group select 3;
_unit setSkill 0.6;
_unit forceAddUniform  "U_O_Wetsuit";
_unit addVest format["V_%1_EPOCH", ceil(random 40)];
_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

_unit addWeapon "ruger_pistol_epoch";
_unit addHandgunItem "optic_MRD";
_unit addMagazines ["10rnd_22X44_magazine", 8];

_unit addWeapon "speargun_epoch";
_unit addMagazines ["spear_magazine", 12];
*/


if(_cnt > 5)then{
	if(_cnt > 10)then [{ //Group over 10 - spawn some elite soldiers
		
		//Rifleman
		_unit = units _group select 5;
		_unit setSkill 0.9;
		_unit forceAddUniform  (_Uguer select (random (count _Uguer -1)));
		_unit addVest format["V_%1_EPOCH", ceil(random 40)];
		_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

		_wpn = _riflesGL select (random (count _riflesGL -1));
		_unit addWeapon (_wpn select 0);
		_unit addMagazines [(_wpn select 1), 6];
		_unit addMagazines ["1Rnd_HE_Grenade_shell", 6];
		_unit addPrimaryWeaponItem "optic_Arco";

		//MG
		_unit = units _group select 6;
		_unit setSkill 0.85;
		_unit forceAddUniform  "U_O_CombatUniform_ocamo";
		_unit addVest format["V_%1_EPOCH", ceil(random 40)];
		_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

		_wpn = _LMGs select (random (count _LMGs -1));
		_unit addWeapon (_wpn select 0);
		_unit addMagazines [(_wpn select 1), 3];
		_unit addPrimaryWeaponItem "optic_Hamr";

		//Anti Tank
		_unit = units _group select 7;
		_unit setSkill 0.8;
		_unit forceAddUniform  "U_O_CombatUniform_ocamo";
		_unit addVest format["V_%1_EPOCH", ceil(random 40)];
		_unit addHeadgear format["H_%1_EPOCH", ceil(random 104)];

		_unit addBackPack "B_Carryall_ocamo";
		_unit addMagazines ["RPG32_HE_F", 1];
		_unit addMagazines ["RPG32_F", 1];
		_unit addWeapon "launch_RPG32_F";
		
		_wpn = _SMGs select (random (count _SMGs -1));
		_opt = _smgOptics select (random (count _smgOptics -1));
		_unit addWeapon (_wpn select 0);
		_unit addMagazines [(_wpn select 1), 3];
		_unit addPrimaryWeaponItem _opt;
		_unit selectWeapon (secondaryWeapon _unit);
			
	_loadoutsAssigned = 8},{_loadoutsAssigned = 5}];
	
	//spawn additional hunters
	for "_i" from _loadoutsAssigned to (count units _group -1) step 1 do{
		private "_unit";
		call compile format ["
			_unit = units _group select %1;
			_unit setSkill 0.6;
			_unit forceAddUniform (%2 select (random (count %2 -1)));
			_unit addVest 'V_%3_EPOCH';
			_unit addHeadgear 'H_%4_EPOCH';
			
			_unit addWeapon (%5 select 0);
			_unit addMagazines [(%5 select 1),(3+(random 3))];
			_unit addPrimaryWeaponItem (%6 select (random (count %6 -1))); 
			
		", _i, _Uguer, ceil(random 40), ceil(random 104), (_rifles select (random (count _rifles -1))), _rifleOptics];
	};
};

_group selectLeader (units _group select 0);

_group
