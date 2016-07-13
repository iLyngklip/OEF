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

params ["_tskTitle", "_tskDescL", "_tskDest", "_tskState","_tskStart", "_enemySpawn"];		// Getting the passed parameters


// Now we need to rename the parameters to variables we can use
_taskTitle 		= _this select 0;
_taskDescL		= _this select 1;
_taskDest		= _this select 2;
_taskState		= _this select 3;
_taskStart		= _this select 4;
_enemySpawn 	= _this select 5;


_spawnedSquads = [];
_distanceToSpawnWaypoint = 100;

// Make an array with the squad types:
_squadTypes = [	(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Support_section"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Rifle_squad"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_AT_section")];


// Setting up the local task var
_task = "task_" + str(tasksDone);
stratMap removeAction actionID;


// Make sure the task can't be startet 2 times
doWeHaveATask = true;
publicVariable "doWeHaveATask";

// Creating the task
_actualTaskPos = getMarkerPos _taskDest;
_taskVar = [west, [_task], [_taskDescL, _taskTitle],   _actualTaskPos, _taskState, 1] call bis_fnc_taskCreate;

_objectToTransport = 0;

_switchVal = floor random 5;
switch(_switchVal) do
{
	// Spawning the object
	case 0: 
	{
		_objectToTransport = "B_Slingload_01_Cargo_F" createVehicle getMarkerPos _taskStart;
	};

	case 1:
	{
		_objectToTransport = "rhsusf_m1025_d_s" createVehicle getMarkerPos _taskStart;
	};

	case 2:
	{
		_objectToTransport = "CargoNet_01_barrels_F" createVehicle getMarkerPos _taskStart;
	};

	case 3:
	{
		_objectToTransport = "CargoNet_01_box_F" createVehicle getMarkerPos _taskStart;
	};

	case 4:
	{
		_objectToTransport = "B_Slingload_01_Fuel_F" createVehicle getMarkerPos _taskStart;
	};
	
	default
	{
	
	};
};


// Creating a marker for players to see, so they can find the cargo to transport
_cargoMarker = createMarker ["Cargo", position _objectToTransport];
_cargoMarker setMarkerShape "ICON";
_cargoMarker setMarkerType "hd_objective";
_cargoMarker setMarkerColor "ColorGreen";
_cargoMarker setMarkerText "Cargo";




// Spawn the enemy units!
if(nrOfEnemySquadsForTransport > 0) then {
	// Spawn enemies, if parameter says so
	for "i" from 1 to nrOfEnemySquadsForTransport - 1 do
	{
		_squadToSpawn = floor random count _squadTypes;
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
	// For debugging
	// systemChat "Spawned a enemy!";
};




// Control structure
// This checks if the task is completed
	
_shallWeStillCheck = true;
while {_shallWeStillCheck} do {
	// Check the distance from the object to transport, to where is shall be delivered
	if(position _objectToTransport distance2D _actualTaskPos < 10) then {
		[_task, "Succeeded", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
		stratMap addAction ["Open strategic map","openStrategicMap.sqf"];
		deleteMarker _cargoMarker;
	};
	
	
	sleep(20);
	
};



// The mission is finished
// Delete the units and objects!
sleep(20);
// Delete cargo
deleteVehicle _objectToTransport;
// Delete units
[_spawnedSquads] call compile preprocessFileLineNumbers "Basic_Functions\deSpawnEnemies.sqf";




// penis




























