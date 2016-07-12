/*
 *
 *	THIS FUNCTION IS FOR
 *	CREATING A TASK TO THE LEADER OF UNITS GROUP
 *
 *
 *
 *	NOTES:
 *		7: TASK-STATE needs some work. At this moment (23/4 2016) is only defaults to ASSIGNED no matter what you set in parameter.
 *
 *
 *
 *
 *	PARAMETERS:
 *		1:	TASK-TITLE 			- The name of the task
 *		2:	TASK-DECRIPTION_L	- Set the LONG description
 *		3:	TASK-DECRIPTION_S	- THIS IS THE TITLE! The SHORT description
 *		4:	TASK-DECRIPTION_H	- Set the HUD description				Default is nil
 *		5:	TASK_DESTINATION	- Marker name @ the DESTINATION
 *		6:  UNIT				- Unit of the group to give the task to
 *		7:	TASK-STATE			- Set the state of the created task. 	Default is ASSIGNED
 *
 *
 *	EXAMPLE CALL
 *		_someVariable = [TITLE_STRING, "DeskL", AC_TITLE_STRING, "DeskH", COORDINATES, UNIT, "ASSIGNED"] execVM "createTask.sqf";
 *			Where:
 *				COORDINATES:		[0, 0, 0] form. It only uses 0 and 1 (like coordinates for markers)
 *				UNIT				Some unit whose groupleader gets the task.
 *				TITLE_STRING		Should not have been used. It does not seem to do anything
 *				AC_TITLE_STRING		!USE THIS FOR THE TITLE! This is the actual title string.
 *
 *			[_unit,_taskid,[_tskDescL, _tskTitle],_tskDest,_tskState, 1,true] call bis_fnc_taskCreate;
 *			[_owner,_taskid,_texts,_destination,_state,_priority,_showNotification,_taskType,_alwaysVisible] call bis_fnc_taskCreate;
 *
 *
 *			EXAMPLE CALL:
 *				_nah = ["Title", "DeskL", "DeskS", "HER ER MAD!", [0, 0, 0], this, "ASSIGNED"] execVM "createTask.sqf";
 */

params ["_tskTitle", "_tskDescL", "_tskDest", "_tskState","_tskStart", "_enemySpawn1", "_enemySpawn2"];		// Getting the passed parameters


// Now we need to rename the parameters to variables we can use
_taskTitle 				= _this select 0;
_taskDescL				= _this select 1;
_taskDest				= _this select 2;
_taskState				= _this select 3;
_taskVehicleStartPos	= _this select 4;
_enemySpawn 			= _this select 5;

_spawnedSquads = [];
_distanceToSpawnWaypoint = 100;

// Make an array with the squad types:
_squadTypes = [	(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Support_section"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Rifle_squad"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_AT_section"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Patrol_section")];

// Setting up the local task var
_task 		= "task_" + str(tasksDone);
_task_out 	= _task + "_out";
_task_home 	= _task + "_home";
stratMap removeAction actionID;

// Make sure the task can't be startet 2 times
doWeHaveATask = true;
publicVariable "doWeHaveATask";

// Converting Markers to coordinates
_taskEndPos = getMarkerPos _taskDest;
_posOfCar 	= getMarkerPos _taskVehicleStartPos;

// Creating the task
_parrentTaskVar 	= [west, [_task], [_taskDescL, _taskTitle], _taskVehicleStartPos, _taskState, 1, false] call bis_fnc_taskCreate;
_childTaskToVehicle = [west, [_task_out, _parrentTaskVar], ["", "Get to the vehicle"], _taskVehicleStartPos, _taskState, 1] call bis_fnc_taskCreate;

// Spawning the vehicle to TOW, and setting damage states
_objectToTransport = "rhsusf_m1025_d_s" createVehicle _posOfCar;
_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_m1025_d_s" >> "HitPoints" >> "HitEngine" >> "name") , 1];
_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_m1025_d_s" >> "HitPoints" >> "HitFuel" >> "name") , 0.5];
_objectToTransport setFuel 0;








// Spawn the enemy units!
if(nrOfEnemySquadsForTowing > 0) then {
	// Spawn enemies, if parameter says so
	for "i" from 0 to nrOfEnemySquadsForTowing - 1 do
	{
		_squadToSpawn = floor random 4;
		_tempGroup = 0;
		
		// Spawning the group
		if(_enemySpawn isEqualType []) then 
		{
			_placeToSpawn = floor random (count _enemySpawn);

			_tempGroup = [getMarkerPos (_enemySpawn select _placeToSpawn), resistance, _squadTypes select _squadToSpawn] Call BIS_fnc_spawnGroup;
			// systemChat format["[spawnEnemies] - _tempGroup: %1", _tempGroup];
			_spawnedSquads set [i, _tempGroup];
			
			// Creating tasks for the AI
			_grpTask = floor random 2;
			switch (_grpTask) do{
				// DEFEND waypoint
				case 0:
				{	
					_angle = random 360;
					_randomPlaceToSpawnWaypoint = [(getMarkerPos (_enemySpawn select _placeToSpawn) select 0) + (_distanceToSpawnWaypoint * cos _angle), (getMarkerPos (_enemySpawn select _placeToSpawn) select 1) + (_distanceToSpawnWaypoint * sin _angle)];
					
					[_tempGroup, _randomPlaceToSpawnWaypoint, 100, 2, true] call CBA_fnc_taskDefend;
				};
				
				// PATROL
				case 1:
				{
					_angle = random 360;
					_randomPlaceToSpawnWaypoint = [(getMarkerPos (_enemySpawn select _placeToSpawn) select 0) + (_distanceToSpawnWaypoint * cos _angle), (getMarkerPos (_enemySpawn select _placeToSpawn) select 1) + (_distanceToSpawnWaypoint * sin _angle)];
					[_tempGroup, _randomPlaceToSpawnWaypoint, 200, 15] call CBA_fnc_taskPatrol;
				};
				
			
			};
		} else 
		{
			_tempGroup = [getMarkerPos _enemySpawn, resistance, _squadTypes select _squadToSpawn] Call BIS_fnc_spawnGroup;
			_spawnedSquads set [i, _tempGroup];
			// Creating tasks for the AI
			_grpTask = floor random 2;
			switch (_grpTask) do{
				// DEFEND waypoint
				case 0:
				{	
					_angle = random 360;
					_randomPlaceToSpawnWaypoint = [(getMarkerPos (_enemySpawn) select 0) + (_distanceToSpawnWaypoint * cos _angle), (getMarkerPos (_enemySpawn) select 1) + (_distanceToSpawnWaypoint * sin _angle)];
					
					[_tempGroup, _randomPlaceToSpawnWaypoint, 100, 2, true] call CBA_fnc_taskDefend;
				};
				
				// PATROL
				case 1:
				{
					_angle = random 360;
					_randomPlaceToSpawnWaypoint = [(getMarkerPos (_enemySpawn) select 0) + (_distanceToSpawnWaypoint * cos _angle), (getMarkerPos (_enemySpawn) select 1) + (_distanceToSpawnWaypoint * sin _angle)];
					[_tempGroup, _randomPlaceToSpawnWaypoint, 200, 15] call CBA_fnc_taskPatrol;
				};
				
			
			};
		};
		
		
		
	};
};







/* BACKUP
// Spawn the enemy units!
if(nrOfEnemySquadsForTowing > 0) then {
	// Spawn enemies, if parameter says so
	for "i" from 1 to nrOfEnemySquadsForTowing - 1 do
	{
		if (i % 2 == 0) then {
			_InfSquad2 = [(getMarkerPos _enemySpawn1), resistance, (configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Support_section")] Call BIS_fnc_spawnGroup;
		
			_wp = _InfSquad2 addWaypoint [[_posOfCar select 0,_posOfCar select 1], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["True", ""];
			
		} else {
			_InfSquad2 = [(getMarkerPos _enemySpawn1), resistance, (configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Rifle_squad")] Call BIS_fnc_spawnGroup;
		
			_wp = _InfSquad2 addWaypoint [[_posOfCar select 0,_posOfCar select 1], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["True", ""];
		};
	};
};

*/




















// Checking if the truck have moved
_shallWeStillCheck_1 = true;
while {_shallWeStillCheck_1} do {
	if(position _objectToTransport distance2D _posOfCar > 10) then {
		[_task_out, "Succeeded", false] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck_1 = false;
		// Setting the drive home task
		_childTaskVar2 = [west, [_task_home, _parrentTaskVar], ["", "Drop off vehicle"], _taskEndPos, _taskState, 1] call bis_fnc_taskCreate;
	};
	sleep(2);
	
};



		
/* GAMMEL KODE!

_objectToTransport = 0;





_switchVal = floor random 2;
switch(_switchVal) do
{
	// Spawning the object
	case 0: 
	{
		_objectToTransport = "rhsusf_rg33_d" createVehicle getMarkerPos _posOfCar;
		_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_rg33_d" >> "HitPoints" >> "HitEngine" >> "name") , 1];
		_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_rg33_d" >> "HitPoints" >> "HitFuel" >> "name") , 0.5];
		_objectToTransport setFuel 0;
		hint "it works!";
	};

	case 1:
	{
		_objectToTransport = "rhsusf_m1025_d_s" createVehicle getMarkerPos _posOfCar;
		_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_m1025_d_s" >> "HitPoints" >> "HitEngine" >> "name") , 1];
		_objectToTransport setHit [getText(configFile >> "cfgVehicles" >> "rhsusf_m1025_d_s" >> "HitPoints" >> "HitFuel" >> "name") , 0.5];
		_objectToTransport setFuel 0;		
		hint "it works!";
	};

	case 2:
	{
		_objectToTransport = "CargoNet_01_barrels_F" createVehicle getMarkerPos _posOfCar;
		_objectToTransport setHit ["motor" , 1];
		_objectToTransport setFuel 0;
		hint "it works!";
	};

	case 3:
	{
		_objectToTransport = "CargoNet_01_box_F" createVehicle getMarkerPos _posOfCar;
		_objectToTransport setHit ["motor" , 1];
		_objectToTransport setFuel 0;
		hint "it works!";
	};

	case 4:
	{
		_objectToTransport = "B_Slingload_01_Fuel_F" createVehicle getMarkerPos _posOfCar;
		_objectToTransport setHit ["motor" , 1];
		_objectToTransport setFuel 0;
		hint "it works!";
	};

	default
	{
	hint "it does not work";
	}
};
*/


// Control structure
// This checks if the task is completed

// CHANGE THE STATEMENTS, TO REFLECT THE NEW TASK!

_shallWeStillCheck = true;
while {_shallWeStillCheck} do {
	if(position _objectToTransport distance2D _taskEndPos < 10) then {
		[_task_home, "Succeeded", true] spawn BIS_fnc_taskSetState;
		sleep(5);
		[_task, "Succeeded", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
		stratMap addAction ["Open strategic map","openStrategicMap.sqf"];
	};
	
	
	sleep(20);
	
};




sleep(120);

// Despawn the vehicle
{
	_x action ["Eject", _objectToTransport];
} forEach crew _objectToTransport;
deleteVehicle _objectToTransport;

// Despawn the remaining enemy units
[_spawnedSquads] call compile preprocessFileLineNumbers "Basic_Functions\deSpawnEnemies.sqf";

































