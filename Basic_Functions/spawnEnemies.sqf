/*
 *
 *	THIS FUNCTION IS FOR
 *		Spawning squads in AO at markernames
 *		Some squads will fortify buildings, others will patrol the area
 *
 *
 *	PARAMETERS:
 *		0:		_nrOfEnemies		- How many enemies should be spawned?	
 *		1:		_enemySpawn			- Where should they be spawned? (array)
 *		2:		_squadTypes			- Types of squads to choose from (array)
 * 		3: 		_distanceToSpawn 	- Maximum distance to spawn away from the marker
 *		4:		_waypointType		- Waypoint type
 *		5:		_whereToAttack		- Where to set the attack waypoint
 *
 *
 *	RETURNS:
 *		Array of squads created
 */


// Get parameters
params ["_nrOfEnemies", "_enemySpawn", "_squadTypes", "_distanceToSpawn", "_waypointType", "_whereToAttack"];

// Array to store the squads in
private "_spawnedSquads";
_spawnedSquads = [];
if(count _this isEqualTo 4) then
{
	_distanceToSpawn = _this select 3;
} else 
{
	_distanceToSpawn = 100;
};



// Spawn the enemy units!
if(_nrOfEnemies > 0) then {
	// Spawn enemies, if parameter says so
	for "i" from 0 to _nrOfEnemies - 1 do
	{
		_squadToSpawn = floor random 4;
		_tempGroup = 0;
		if(_enemySpawn isEqualType []) then 
		{
			_placeToSpawn = floor random (count _enemySpawn);

			_tempGroup = [getMarkerPos (_enemySpawn select _placeToSpawn), resistance, _squadTypes select _squadToSpawn] Call BIS_fnc_spawnGroup;
			_spawnedSquads set [i, _tempGroup];
		} else 
		{
			_tempGroup = [getMarkerPos _enemySpawn, resistance, _squadTypes select _squadToSpawn] Call BIS_fnc_spawnGroup;
			_spawnedSquads set [i, _tempGroup];
		};
		
		
		if(_waypointType isEqualTo "PATROL") then {
			_angle = random 360;
			_randomPlaceToSpawn = [(getMarkerPos (_enemySpawn select _placeToSpawn) select 0) + (_distanceToSpawn * cos _angle), (getMarkerPos (_enemySpawn select _placeToSpawn) select 1) + (_distanceToSpawn * sin _angle)];
			[_tempGroup, _randomPlaceToSpawn, 200, 15] call CBA_fnc_taskPatrol;
		} else 
		{ 
			if (_waypointType isEqualTo "ATTACK") then 
			{
				// Make attack waypoint for the enemies
				[_tempGroup, _whereToAttack, 100] call CBA_fnc_taskAttack;
				
			} else 
			{
				// Creating tasks for the AI
				_grpTask = floor random 2;
				switch (_grpTask) do{
					// DEFEND waypoint
					case 0:
					{	
						_angle = random 360;
						_randomPlaceToSpawn = [(getMarkerPos (_enemySpawn select _placeToSpawn) select 0) + (_distanceToSpawn * cos _angle), (getMarkerPos (_enemySpawn select _placeToSpawn) select 1) + (_distanceToSpawn * sin _angle)];
						
						[_tempGroup, _randomPlaceToSpawn, 100, 2, true] call CBA_fnc_taskDefend;
					};
					
					// PATROL
					case 1:
					{
						_angle = random 360;
						_randomPlaceToSpawn = [(getMarkerPos (_enemySpawn select _placeToSpawn) select 0) + (_distanceToSpawn * cos _angle), (getMarkerPos (_enemySpawn select _placeToSpawn) select 1) + (_distanceToSpawn * sin _angle)];
						[_tempGroup, _randomPlaceToSpawn, 200, 15] call CBA_fnc_taskPatrol;
					};
					
				
				};
			};
		};	
	};
	_spawnedSquads;
};	

