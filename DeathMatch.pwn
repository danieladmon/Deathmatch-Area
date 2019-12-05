/*

# DeathMatch Area [V0.3]
# Created: 15/03/2009
# Last edit: 05/12/2019

# By: BlueRey [2009-2019] ©

*/
#include <a_samp>

new DMTimer[MAX_PLAYERS];
new bool:InDM[MAX_PLAYERS];

new Weapon[] = {35,38}; // Add Weapons Here
new Float:Spawns[][3] =
{
	{-2044.1980,-497.2107,35.5313},
	{2591.5173,2820.3782,27.8203},
	{2610.1113,2729.1050,36.5386},
	{2637.7939,2771.6663,25.8222},
	{2693.0894,2780.2490,59.0212},
	{2595.7690,2640.1360,109.1719},
	{2499.0588,2704.6191,10.9844},
	{2531.0337,2849.6812,10.8203},
	{2556.6719,2806.6592,19.9922},
	{2607.7131,2825.2637,19.9922},
	{2682.6799,2679.4478,22.9472},
	{2647.3228,2807.8252,36.3222},
	{2670.8394,2809.9463,36.3222},
	{2681.0952,2750.8208,19.0722},
	{2647.7700,2805.2942,10.8203},
	{2602.3147,2800.9075,10.8203},
	{2581.4431,2752.7930,10.8203},
	{2612.7920,2662.9963,37.8865},
	{2661.2039,2663.2451,37.7669},
	{2688.1023,2648.0784,38.0345},
	{2574.3608,2658.6206,37.7509},
	{2506.0901,2788.3293,10.8203},
	{2575.3323,2808.3220,10.8203},
	{2621.7708,2839.4243,10.8203}
}; // Add / Edit Spawns Here

public OnFilterScriptInit()
{
	print("\n---------------------------------------");
	print("     DeathMatch Filterscript by BlueRey  ");
	print("---------------------------------------\n");
	return 1;
}

public OnPlayerCommandText(playerid,cmdtext[])
{
	if(!strcmp("/dm",cmdtext,true))
	{
		if(!InDM[playerid])
		{
			InDM[playerid] = true;
			TelePlayerToDM(playerid);
			SendClientMessage(playerid,0x0F66AFF/* Light Green */,"Welcome to DeathMatch area !");
			SendClientMessage(playerid,0x0F66AFF/* Light Green */,"To exit DeathMatch area type /DM again.");
		}
		else
		{
			SendClientMessage(playerid,0xFF9900AA/* Orange */,"You have left the DeathMatch area.");
			ClearVars(playerid,true);
		}
		return 1;
	}
	return 0;
}

stock TelePlayerToDM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new randw = random(sizeof(Spawns));
		new rands = random(sizeof(Weapon));
		DMTimer[playerid] = SetTimerEx("CheckArea",1000,1,"i",playerid);
		SetPlayerPos(playerid,Spawns[randw][0],Spawns[randw][1],Spawns[randw][2]);
	   	ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,Weapon[rands],1600);
	}
}

public OnFilterScriptExit()
{
	for(new i; i < MAX_PLAYERS; i++) ClearVars(i,true);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	ClearVars(playerid);
}

public OnPlayerDeath(playerid,killerid,reason)
{
	if(InDM[playerid]) KillTimer(DMTimer[playerid]);
}

public OnPlayerSpawn(playerid)
{
	if(InDM[playerid]) return SetTimerEx("TelePlayerToDM",350,0,"di",playerid),0;
	return 1;
}

stock CheckArea(playerid)
{
	if(InDM[playerid] && !IsPlayerInArea(playerid,2762.2783,2482.7942,2872.4058,2581.7100)) ClearVars(playerid);
}

stock IsPlayerInArea(playerid,Float:max_x,Float:min_x,Float:max_y,Float:min_y)
{
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	if(X <= max_x && X >= min_x && Y <= max_y && Y >= min_y) return 1;
	return 0;
}

stock ClearVars(playerid,bool:spawn=false)
{
	if(IsPlayerConnected(playerid) && InDM[playerid])
	{
		InDM[playerid] = false;
	    ResetPlayerWeapons(playerid);
		KillTimer(DMTimer[playerid]);
		if(spawn) SpawnPlayer(playerid);
	}
}
