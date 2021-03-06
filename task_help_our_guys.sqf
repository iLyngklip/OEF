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
 
params ["_tskTitle", "_tskDescL", "_tskDest", "_tskState", "_enemySpawn"];		// Getting the passed parameters


// Now we need to rename the parameters to variables we can use
_taskTitle 		= _this select 0;	// DO NOT USE THIS. USE _taskDescS instead.
_taskDescL		= _this select 1;
_taskDest		= _this select 2;
_taskState		= _this select 3;
_enemySpawn 	= _this select 4;

_spawnedSquads = [];

_task = "task_" + str(tasksDone);


// Make sure the task can't be startet 2 times
doWeHaveATask = true;
publicVariable "doWeHaveATask";


// Create the task
_actualTaskPos = getMarkerPos _taskDest;
_taskVar = [west, [_task], [_taskDescL, _taskTitle],   _actualTaskPos, _taskState, 1] call bis_fnc_taskCreate;
 
 // Spawn our units
 _ourSquad = [_actualTaskPos, west, (configFile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry" >> "rhs_group_nato_usmc_d_infantry_team")] Call BIS_fnc_spawnGroup;
 //_ourSquad set[0, _tempSquad];
 
 // Add DEFEND waypoint, so they take cover
 [_ourSquad, _actualTaskPos, 50, 1, false] call CBA_fnc_taskDefend;
 // rhs_group_nato_usmc_d_infantry_team
 
 
 
// Make an array with the squad types:
_squadTypes = [	(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Support_section"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Rifle_squad"),
				(configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_AT_section")];
 
for "i" from 0 to nrOfEnemySquadsForAssist - 1 do 
{
	_tempSquad = [1, _enemySpawn, _squadTypes, 100, "ATTACK", _actualTaskPos] call compile preprocessFileLineNumbers "Basic_Functions\spawnEnemies.sqf";
	_spawnedSquads set [i, _tempSquad];
};

// systemChat str(_spawnedSquads);
 
 
 /* OUTDATED!
// Spawn the enemy units!
if(nrOfEnemySquadsForAssist > 0) then {
	// Spawn enemies, if parameter says so
	for "i" from 1 to nrOfEnemySquadsForAssist do
	{
		if (i % 2 == 0) then {
			_InfSquad2 = [(getMarkerPos _enemySpawn1), resistance, (configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Support_section")] Call BIS_fnc_spawnGroup;
		
			_wp = _InfSquad2 addWaypoint [[getMarkerPos _taskDest select 0, getMarkerPos _taskDest select 1], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["True", ""];
			
		} else {
			_InfSquad2 = [(getMarkerPos _enemySpawn1), resistance, (configFile >> "CfgGroups" >> "Indep" >> "LOP_AM" >> "Infantry" >> "LOP_AM_Rifle_squad")] Call BIS_fnc_spawnGroup;
		
			_wp = _InfSquad2 addWaypoint [[getMarkerPos _taskDest select 0, getMarkerPos _taskDest select 1], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["True", ""];
		}
	};
};
 */
 
/*
// Create a trigger to check if task completed
_trig = createTrigger ["EmptyDetector", _actualTaskPos];
_trig setTriggerType "NONE";
_trig setTriggerActivation ["WEST", "PRESENT", false];
_trig setTriggerArea [200, 200, 0, false];
_trig setTriggerTimeout [80, 80, 80, false];
_trig setTriggerStatements ["this", "", ""];

// Create a trigger to check if task completed
_trig2 = createTrigger ["EmptyDetector", _actualTaskPos];
_trig2 setTriggerType "NONE";
_trig2 setTriggerActivation ["EAST", "NOT PRESENT", false];
_trig2 setTriggerArea [1200, 1200, 0, false];
_trig2 setTriggerTimeout [80, 80, 80, false];
_trig2 setTriggerStatements ["this", "", ""];


while {(triggerActivated _trig) && !(triggerActivated _trig2)} do 
{ 	
	// Now we wait for the trigger to fire
	sleep(10);
};

if((triggerActivated _trig) && (triggerActivated _trig2)) then 
{
	[_task, "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
	_shallWeStillCheck = false;
	doWeHaveATask = false;
	publicVariable "doWeHaveATask";
	tasksDone = tasksDone + 1;

} else {
		[_task, "Failed", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
};	
*/	
	
	
	
// Control structure
// This checks if the task is completed
_shallWeStillCheck = true;
_enemySquadsAlive = [];

while {_shallWeStillCheck && !(_enemySquadsAlive isEqualTo nrOfEnemySquadsForAssist)} do {
	
	// Check if the enemies are alive
	for "i" from 0 to nrOfEnemySquadsForAssist -1 do 
	{
		// Getting the selected group
		_tempGroupName = (_spawnedSquads select i) select 0;
		
					// For debugging
				// systemChat format["Temp Group Name: %1, with %2 entities", _tempGroupName, count units _tempGroupName];
				// systemChat format["GroupID: %1", groupId _tempGroupName];
		
		// Counting how many is alive, and saving it in array
		_enemySquadsAlive set [i, {alive _x} count (units _tempGroupName)];
		
		// For debugging
		// systemChat format["[enemySquadsAlive] - %1", _enemySquadsAlive select i];
	}; // for
	
	
	
	// Determining how many of the enemy units are alive
	_tempValForEnemiesAlive = 0;
	for "i" from 0 to count _enemySquadsAlive - 1 do 
	{
		// Getting the number of alive units in the squad
		_tempNumber = _enemySquadsAlive select i;
		
			//systemChat format["[tempNumber] - %1", _tempNumber];
		// And adding to pool of alive enemy units
		_tempValForEnemiesAlive = _tempValForEnemiesAlive + _tempNumber;
	};
	// systemChat format["tempValForEnemiesAlive: %1", _tempValForEnemiesAlive];
	
	// Checking if all enemies are dead, in which case mission is won
	if(_tempValForEnemiesAlive isEqualTo 0) then 
	{
		// MISSION IS OVER - ALL ENEMIES ARE DEAD
		[_task, "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
	};
	
	
	
	// Checking if our guys are alive. If not, mission is lost
	if(({alive _x} count units (_ourSquad)) < 1) then {
		[_task, "Failed", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
	}; // if
	
	sleep(20);
	
}; 

 // Despawn the enemy guys
[_spawnedSquads] call compile preprocessFileLineNumbers "Basic_Functions\deSpawnEnemies.sqf";
 
 
 
 /*
	if((_enemySquadsAlive isEqualTo nrOfEnemySquadsForAssist)) then 
	{
		// MISSION IS OVER - ALL ENEMIES ARE DEAD
		[_task, "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
		_shallWeStillCheck = false;
		doWeHaveATask = false;
		publicVariable "doWeHaveATask";
		tasksDone = tasksDone + 1;
	};
	*/
 
 
 
 
 
 
 
 
 
 /*		NOT USED
 
 // GAME-LOGIC GROUPING
 _temp_group1	= createGroup west;
 _temp_group2	= createGroup west;
 
 
 // INIT-fields for units
 gut_1_init = "[this, 'STAND'] call BIS_fnc_ambientAnim; this setDir 94.088; gut_1 = this; this addAction ['Talk', 'gut_1_talk.sqf'];";
 gut_2_init = "[this,'SIT_LOW_U','ASIS'] call BIS_fnc_ambientAnim; this setDir 210.692; gut_2 = this; this setVehiclePosition [gut_2_pos, [],0, 'CAN_COLLIDE']; this addAction ['Talk', 'gut_2_talk.sqf']";
 
 
 
 // CIVILIANS
 "CAF_AG_ME_CIV_03"	createUnit [gut_1_pos, _temp_group1, gut_1_init]; // GUT 1
 "CAF_AG_ME_CIV_03"	createUnit [[0,0,0], _temp_group2, gut_2_init]; // GUT 2


 
 // STATIC OBJECTS		EXAMPLE CODE		_veh_1		= "C_offroad_01_F" 	createVehicle position player;		EXAMPLE CODE
 
 
 
 // ENEMY UNITS
 
 
 */ 
 
 
 
 
 
  
 
  // TESTS
//  [group _this select 1, ["task_0"], ["We have reason to believe one of the locals know something about our enemies positions. Locate the guy and speak with him.", "Speak to the local"],    _dest_1, "ASSIGNED", 1] call bis_fnc_taskCreate;

	// hint "Dillermis!";
 
 // --END OF TESTS
 
 // HELPER FUNCTIONS
 /*
 KK_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};
*/







































