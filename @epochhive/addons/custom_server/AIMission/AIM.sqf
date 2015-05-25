//This script sends Message Information to allplayers
blck_Message = _this select 0;
{
	(owner _x) publicVariableClient "blck_Message";
} foreach playableUnits;


