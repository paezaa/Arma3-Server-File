/*
	for the Mission System by blckeagls
	Modified by Ghostrider
	2-1-15 Updates: changed how number of weapons and magazines of corresponding ammo are calculated lines 89 amd 90
	Fill a crate with items
*/

	private["_crate","_boxLoot","_wepCnt","_magCnt","_itemCnt","_opticsCnt","_a1","_item","_low","_high","_diff","_bkcPckCnt"];

	_crate = _this select 0;
	_boxLoot = _this select 1; // Array of [[weapons],[magazines],[items]]
	_wepCnt = _this select 2; // number of types of weapons to load
	_magCnt = _this select 3; // Number of types of additional, optional magazines to add (this includes building supplies)
	_opticsCnt = _this select 4; // number of types of optics to be added
	_itemCnt = _this select 5; // number of items (first aid packs, multigun bits) to load
	_bkcPckCnt = _this select 6; // Number of backpacks to add
	
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	
	_a1 = _boxLoot select 0; // choose the subarray of weapons and corresponding magazines
	// Add some randomly selected weapons and corresponding magazines
	for "_i" from 1 to _wepCnt do {
		_item = _a1 call BIS_fnc_selectRandom;
		_crate addWeaponCargoGlobal [_item select 0,1];
		_crate addMagazineCargoGlobal [_item select 1, 1 + round(random(3))];
	};
	// Add Magazines, which includes building supplies, grenades, and 40mm grenade shells
	_a1 = _boxLoot select 1;
	for "_i" from 0 to _magCnt do {
		_item = _a1 call BIS_fnc_selectRandom;
		_diff = (_item select 2) - (_item select 1);  // Take difference between max and min number of items to load and randomize based on this value
		_crate addMagazineCargoGlobal [_item select 0, (_item select 1) + round(random(_diff))];
	};
	// Add Optics
	_a1 = _boxLoot select 2;
	for "_i" from 0 to _opticsCnt do {
		_item = _a1 call BIS_fnc_selectRandom;
		_diff = (_item select 2) - (_item select 1); 
		_crate additemCargoGlobal [_item select 0, (_item select 1) + round(random(_diff))];		
	};		
	// Add Items (first aid kits, multitool bits, vehicle repair kits, food and drinks)
	_a1 = _boxLoot select 3;
	for "_i" from 0 to _itemCnt do {
		_item = _a1 call BIS_fnc_selectRandom;
		_diff = (_item select 2) - (_item select 1); 
		_crate additemCargoGlobal [_item select 0, (_item select 1) + round(random(_diff))];		
	};	
	_a1 = _boxLoot select 4;
	for "_i" from 0 to _bkcPckCnt do {
		_item = _a1 call BIS_fnc_selectRandom;
		_diff = (_item select 2) - (_item select 1); 
		_crate addbackpackcargoGlobal [_item select 0, (_item select 1) + round(random(_diff))];	
	};
