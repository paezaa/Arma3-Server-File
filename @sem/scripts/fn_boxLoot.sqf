/*
	[_box] call fn_boxLoadout;	== Random loadout is selected

	[_box, 3] call fn_boxLoadout;	== Loadout 3 is selected
*/
private ["_box","_loadout","_ran"];
_box = _this select 0;
if(count _this > 1)then[{_loadout = _this select 1},{_loadout = ceil(random 2)}];

_box call SEM_fnc_emptyGear;

_LMGs = [
	["m249_EPOCH",				"200Rnd_556x45_M249"],
	["m249Tan_EPOCH",			"200Rnd_556x45_M249"],
	["LMG_Mk200_F",				"200Rnd_65x39_cased_Box_Tracer"],
	["Arifle_MX_SW_F",			"100Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_SW_Black_F",	"100Rnd_65x39_caseless_mag_Tracer"],
	["LMG_Zafir_F",				"150Rnd_762x51_Box_Tracer"]
];

_rifleOptics = ["optic_Aco","optic_ACO_grn","optic_Holosight"]; //"optic_Hamr","optic_Arco"


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

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

switch(_loadout)do{
	case 1:{	//2xLMG 1xDMR
		_wpn = _LMGs select (random (count _LMGs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _LMGs select (random (count _LMGs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _DMRs select (random (count _DMRs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal ["optic_Hamr", 1];
		_box addItemCargoGlobal ["optic_Arco", 1];
		_box addItemCargoGlobal [_rifleOptics select (random (count _rifleOptics -1)), 1];
		_box addItemCargoGlobal [_rifleOptics select (random (count _rifleOptics -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 1];
	};

	case 2:{	//Sniper
		_wpn = _Sniper select (random (count _Sniper -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_box addItemCargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 2];
		_box addItemCargoGlobal ["ItemGPS", 1];
		_box addItemCargoGlobal ["Rangefinder", 1];
	};
};