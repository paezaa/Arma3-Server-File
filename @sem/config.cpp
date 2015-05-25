class CfgPatches {
	class sem {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};	//"A3_server_settings"
	};
};

class CfgFunctions {
	class SEM {
		class main {
			file = "sem";
			class init {
				//preInit = 1;
				postInit = 1;
			};
		};

		class SEM_scripts
		{
			file = "sem\scripts";
			class createComposition {};
			class getWorldData {};
			class missionController {};
			class missionCleanup {};
			class findMissionPos {};
			class selectMission {};
			class selectClosest {};
			class endCondition {};
			class emptyGear {};
			class randomPos {};
			class crateLoot {};
			class boxLoot {};
		};
		
		class SEM_AIscripts
		{
			file = "sem\scripts\ai";
			class spawnAI {};
			class stripUnit {};
			class removeGear {};
			class findThread {};
			class AIactDeact {};
			class AIsetOwner {};
			class AIdamageEH {};
			class AIkilledEH {};
			class AIfiredEH {};
			class broadcastAI {};
			class AImove {};
		};
	};
};