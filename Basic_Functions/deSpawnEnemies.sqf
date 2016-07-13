/*
 *
 *	THIS FUNCTION IS FOR
 *		Spawning squads in AO at markernames
 *		Some squads will fortify buildings, others will patrol the area
 *
 *
 *	PARAMETERS:
 *		0:		_squadsToDespawn - The squads of which to despawn all units
 *
 *
 *	RETURNS:
 *		None
 */

// [_spawnedSquads] call compile preprocessFileLineNumbers "Basic_Functions\deSpawnEnemies.sqf";



// Get parameters
params ["_squadsToDespawn"];

{ 
	{
		deleteVehicle _x;
	} forEach units _x;
	
} forEach _squadsToDespawn;





