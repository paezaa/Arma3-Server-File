/*
	[_box] call fn_crateLoadout;	== Random loadout is selected

	[_box, 3] call fn_crateLoadout;	== Loadout 3 is selected
	
	Original loadouts by drsubo
	Edited into a function by KiloSwiss
	
	ToDo for v0.3
	Create different loadouts/loot for each Crate (see comments)
*/
private ["_crate","_loadout","_ran","_rifles","_riflesGL","_LMGs","_rifleOptics","_SMGs","_smgOptics","_DMRs","_Sniper","_sniperOptics","_paintCans","_BuildingComponents","_BuildingKits"];
_crate = _this select 0;
if(count _this > 1)then[{_loadout = _this select 1},{_loadout = ceil(random 4)}];

_crate call SEM_fnc_emptyGear;

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

_Sniper = [
	["m107_EPOCH",		"5Rnd_127x108_Mag"],
	["m107Tan_EPOCH",	"5Rnd_127x108_Mag"],
	["Srifle_GM6_F",	"5Rnd_127x108_Mag"],
	["Srifle_LRR_F",	"7Rnd_408_Mag"]
];

_sniperOptics = ["optic_Nightstalker", "optic_SOS", "optic_LRPS", "optic_DMS"];

// Building loot from http://epochmod.com/forum/index.php?/topic/30788-list-of-a3-epoch-loot-classnames/

_paintCans = ["PaintCanBlk","PaintCanBlu","PaintCanBrn","PaintCanGrn","PaintCanOra","PaintCanPur","PaintCanRed","PaintCanTeal","PaintCanYel"];

_BuildingComponents1 = ["CinderBlocks","MortarBucket","ItemScraps","WoodLog_EPOCH","ItemKiloHemp","Pelt_EPOCH"];

_BuildingComponents2 = ["ItemCorrugated","ItemCorrugatedLg","CircuitParts","PartPlankPack"];

_BuildingKits = ["KitStudWall","KitWoodFloor","KitWoodStairs","KitWoodRamp","KitFirePlace","KitTiPi","KitShelf","KitFoundation","JackKit","KitPlotPole","KitCinderWall"];


switch(_loadout)do{
	case 0:{	//base building material
		private["_objArr","_objType"];
		
		_crate addItemCargoGlobal ["FAK", ceil(random 5)];
		_crate addBackpackCargoGlobal ["B_Carryall_khk", 2];
		
		_objArr = _paintCans;
		for "_i" from 2 to 4 step 1 do {
			_objType = _objArr select (random (count _objArr -1));
			_objArr = _objArr - [_objType];
			_crate additemcargoGlobal [_objType, ceil(random _i)];
		};
		
		_objArr = _BuildingComponents1;
		for "_i" from 7 to 11 step 2 do {
			_objType = _objArr select (random (count _objArr -1));
			_objArr = _objArr - [_objType];
			_crate additemcargoGlobal [_objType, ceil(random _i)];
		};
		
		_objArr = _BuildingComponents2;
		for "_i" from 4 to 5 step 1 do {
			_objType = _objArr select (random (count _objArr -1));
			_objArr = _objArr - [_objType];
			_crate additemcargoGlobal [_objType, ceil(random _i)];
		};
		
		_objArr = _BuildingKits;
		for "_i" from 1 to 2 step 1 do {
			_objType = _objArr select (random (count _objArr -1));
			_objArr = _objArr - [_objType];
			_crate additemcargoGlobal [_objType, ceil(random _i)];
		};
	};

	case 1:{	//random crap
		_opt = _rifleOptics select (random (count _rifleOptics -1));
		_crate additemcargoGlobal [_opt, 2];
		_crate addWeaponCargoGlobal ["speargun_epoch", 1];
		_crate addMagazineCargoGlobal ["spear_magazine", 30];
		_crate additemcargoGlobal ["ItemCompass", 1];
		_crate additemcargoGlobal ["FoodBioMeat", 5];
		_crate additemcargoGlobal ["FoodMeeps", 1];
		_crate additemcargoGlobal ["sardines_epoch", 3];
		_crate additemcargoGlobal ["meatballs_epoch", 2];
		_crate additemcargoGlobal ["ItemTunaCooked", 3];
		_crate additemcargoGlobal ["ItemSodaRbull", 1];
		_crate additemcargoGlobal ["ItemSodaPurple", 2];
		_crate additemcargoGlobal ["ItemSodaMocha", 1];
		_crate additemcargoGlobal ["ItemSodaBurst", 2];
		_crate additemcargoGlobal ["WhiskeyNoodle", 1];
		_crate additemcargoGlobal ["Towelette", 7];
		_crate additemcargoGlobal ["ColdPack", 2];
		_crate additemcargoGlobal ["ItemCoolerE", 2];
		_crate additemcargoGlobal ["CircuitParts", 5];
		_crate additemcargoGlobal ["PartPlankPack", 2];
		_crate additemcargoGlobal ["MortarBucket", 1];
		_crate additemcargoGlobal ["CinderBlocks", 4];
		_crate additemcargoGlobal ["FAK", 3];
		_crate additemcargoGlobal ["ItemKiloHemp", 2];
		_crate additemcargoGlobal ["ItemRuby", 1];
		_crate additemcargoGlobal ["Pelt_EPOCH", 3];
		_crate additemcargoGlobal ["HeatPack", 3];
		_crate additemcargoGlobal ["ItemSodaOrangeSherbet", 2];
		//_crate additemcargoGlobal ["optic_ACO_grn", 1];
		_crate additemcargoGlobal ["U_O_Wetsuit", 1];
		_crate addbackpackcargoGlobal ["smallbackpack_pink_epoch", 1];
	};
			
	case 2:{	//random crap 2
		_opt = _rifleOptics select (random (count _rifleOptics -1));
		_crate additemcargoGlobal [_opt, 2];
		_crate addWeaponCargoGlobal ["MultiGun", 1];
		_crate addMagazineCargoGlobal ["EnergyPack", 5];
		_crate additemcargoGlobal ["Defib_EPOCH", 2];
		_crate additemcargoGlobal ["Heal_EPOCH", 1];
		_crate additemcargoGlobal ["Repair_EPOCH", 2];
		_crate additemcargoGlobal ["Binocular", 2];
		_crate additemcargoGlobal ["FAK", 4];
		_crate additemcargoGlobal ["FoodSnooter", 2];
		_crate additemcargoGlobal ["FoodWalkNSons", 3];
		_crate additemcargoGlobal ["scam_epoch", 2];
		_crate additemcargoGlobal ["sweetcorn_epoch", 4];
		_crate additemcargoGlobal ["ItemTroutCooked", 1];
		_crate additemcargoGlobal ["ItemSeaBassCooked", 2];		
		_crate additemcargoGlobal ["Towelette", 4];
		_crate additemcargoGlobal ["HeatPack", 2];
		_crate additemcargoGlobal ["ColdPack", 1];
		_crate additemcargoGlobal ["ItemKiloHemp", 3];
		_crate additemcargoGlobal ["ItemCoolerE", 1];
		_crate additemcargoGlobal ["CircuitParts", 3];
		_crate additemcargoGlobal ["PartPlankPack", 7];
		_crate additemcargoGlobal ["MortarBucket", 2];
		_crate additemcargoGlobal ["CinderBlocks", 3];
		_crate additemcargoGlobal ["muzzle_snds_H", 1];
		_crate additemcargoGlobal ["muzzle_snds_L", 1];
		_crate additemcargoGlobal ["VehicleRepair", 1];
		_crate additemcargoGlobal ["U_O_CombatUniform_ocamo", 1];
		_crate addbackpackcargoGlobal ["smallbackpack_red_epoch", 1];				
	};	

	case 3:{	//good loot + SMGs + rifle magazines
		_wpn = _SMGs select (random (count _SMGs -1));
		_opt = _smgOptics select (random (count _smgOptics -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 3];
		_crate addMagazineCargoGlobal [(_wpn select 1), 16];
		_crate additemcargoGlobal [_opt, 3];
		_crate additemcargoGlobal ["Binocular", 4];
		_crate additemcargoGlobal ["FAK", 5];
		_crate additemcargoGlobal ["muzzle_snds_B", 1];
		_crate additemcargoGlobal ["ItemSilverBar", 3];
		_crate additemcargoGlobal ["Pelt_EPOCH", 2];
		//_crate additemcargoGlobal ["ChainSaw", 1];
		_crate additemcargoGlobal ["ItemMixOil", 1];
		_crate additemcargoGlobal ["ItemGPS", 1];
		_crate addbackpackcargoGlobal ["smallbackpack_teal_epoch", 1];
	};
			
	case 4:{	//good loot + basic weapons + rifle magazines
		_wpn = _rifles select (random (count _rifles -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 2];
		_crate addMagazineCargoGlobal [(_wpn select 1), 8];
		_crate addWeaponCargoGlobal ["Rollins_F", 1];
		_crate addMagazineCargoGlobal ["5Rnd_rollins_mag", 6];
		_crate additemcargoGlobal ["NVG_EPOCH", 1];
		_crate additemcargoGlobal ["ItemGPS", 2];
		_crate additemcargoGlobal ["ItemGoldBar", 2];
		_crate additemcargoGlobal ["Rangefinder", 2];
		_crate additemcargoGlobal ["FAK", 3];
		_crate additemcargoGlobal ["muzzle_snds_B", 1];
		_crate additemcargoGlobal ["Pelt_EPOCH", 2];
		//_crate additemcargoGlobal ["ChainSaw", 1];
		_crate additemcargoGlobal ["ItemMixOil", 2];
		_crate additemcargoGlobal ["jerrycan_epoch", 2];
		_crate addbackpackcargoGlobal ["smallbackpack_green_epoch", 1];
	};
			
	case 5:{	//good loot + higher tier weapons + usefull attachments
		_wpn = _DMRs select (random (count _DMRs -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 2];
		_crate addMagazineCargoGlobal [(_wpn select 1), 12];
		_wpn = _rifles select (random (count _rifles -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 2];
		_crate addMagazineCargoGlobal [(_wpn select 1), 12];
		_crate additemcargoGlobal ["optic_Hamr", 2];
		_crate additemcargoGlobal ["optic_Nightstalker", 1];
		_crate additemcargoGlobal ["NVG_EPOCH", 1];
		_crate additemcargoGlobal ["ItemGPS", 2];
		_crate additemcargoGlobal ["ItemGoldBar10oz", 2];
		_crate additemcargoGlobal ["Rangefinder", 1];
		_crate additemcargoGlobal ["VehicleRepair", 1];
		_crate additemcargoGlobal ["FAK", 6];
		_crate additemcargoGlobal ["sweetcorn_epoch", 2];
		_crate additemcargoGlobal ["ItemSodaRbull", 1];
		_crate additemcargoGlobal ["Pelt_EPOCH", 2];
		_crate additemcargoGlobal ["ItemKiloHemp", 5];
		_crate additemcargoGlobal ["Towelette", 4];
		_crate addbackpackcargoGlobal ["B_Carryall_cbr", 1];
	};	
	
	case 6:{	//excellent + high tier weapons + good attachments
		_wpn = _LMGs select (random (count _LMGs -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 1];
		_crate addMagazineCargoGlobal [(_wpn select 1), 5];
		_wpn = _riflesGL select (random (count _riflesGL -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 2];
		_crate addMagazineCargoGlobal [(_wpn select 1), 12];
		_crate addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", 10];
		_crate additemcargoGlobal ["optic_Hamr", 2];
		_crate additemcargoGlobal ["optic_Arco", 2];
		_crate addWeaponCargoGlobal ["MultiGun", 1];
		_crate additemcargoGlobal ["ItemGoldBar10oz", 1];
		_crate additemcargoGlobal ["ItemSilverBar", 2];
		_crate addMagazineCargoGlobal ["EnergyPack", 4];
		_crate additemcargoGlobal ["NVG_EPOCH", 2];
		_crate additemcargoGlobal ["ItemGPS", 2];
		_crate additemcargoGlobal ["Rangefinder", 1];
		_crate additemcargoGlobal ["FAK", 9];
		_crate additemcargoGlobal ["Repair_EPOCH", 1];
		_crate additemcargoGlobal ["Defib_EPOCH", 1];
		_crate additemcargoGlobal ["Heal_EPOCH", 2];
		_crate additemcargoGlobal ["jerrycan_epoch", 2];
		_crate addbackpackcargoGlobal ["B_Carryall_cbr", 1];
	};

	case 7:{	//DMRs, AR and Chainsaw
		_wpn = _DMRs select (random (count _DMRs -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 1];
		_crate addMagazineCargoGlobal [(_wpn select 1), 12];
		_wpn = _DMRs select (random (count _DMRs -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 1];
		_crate addMagazineCargoGlobal [(_wpn select 1), 12];
		_wpn = _riflesGL select (random (count _riflesGL -1));
		_crate addWeaponCargoGlobal [(_wpn select 0), 2];
		_crate addMagazineCargoGlobal [(_wpn select 1), 20];
		_crate addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", 10];
		_crate additemcargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_crate additemcargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_crate additemcargoGlobal ["NVG_EPOCH", 2];
		_crate additemcargoGlobal ["ItemGPS", 2];
		_crate additemcargoGlobal ["Rangefinder", 2];
		_crate additemcargoGlobal ["FAK", 8];
		//_crate additemcargoGlobal ["CinderBlocks", 16];
		_crate additemcargoGlobal ["ChainSaw", 1];
		_crate additemcargoGlobal ["ItemMixOil", 2];
		_crate additemcargoGlobal ["jerrycan_epoch", 2];
		_crate additemcargoGlobal ["EnergyPackLg", 4];
		_crate additemcargoGlobal ["MortarBucket", 6];
		//_crate additemcargoGlobal ["ItemCorrugated", 6];
		_crate addbackpackcargoGlobal ["B_Carryall_cbr", 1];
	};
};