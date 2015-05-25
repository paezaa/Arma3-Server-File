// for a future use

private ["_coords","_crate"];

_coords = _this;

//Creates the crate
_crate = objNull;
_crate = createVehicle ["Box_NATO_Wps_F",_coords,[], 0, "CAN_COLLIDE"];
//_crate setVariable ["LAST_CHECK", (diag_tickTime + 14400)];
_crate setVariable ["Mission",1,true];
_crate setVariable ["ObjectID","1",true];
_crate setVariable ["permaLoot",true,true];

_crate setPos _coords;

_crate
