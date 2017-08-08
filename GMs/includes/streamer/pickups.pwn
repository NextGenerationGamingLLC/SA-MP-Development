#include <YSI\y_hooks>

hook OnGameModeInit() {

	print("[Streamer] Loading Dynamic Pickups...");
	
    // Pickups
	CreateDynamicPickup(1239, 23, -4429.944824, 905.032470, 987.078186, -1); // VIP Garage Travel
	//CreateDynamicPickup(1239, 23, 2102.71,-103.97,2.28, -1); // Matrun 3
	/*CreateDynamicPickup(1239, 23, -1816.528686, -179.502624, 9.398437, -1); // Matrun 4 (pickup)
	CreateDynamicPickup(1239, 23, -1872.879760, 1416.312500, 7.180089, -1);*/ // Matrun 4 (dropoff)
  	//CreateDynamicPickup(1239, 23, 2565.346191, 1403.409790, 7699.584472, -1);// VIP ph changing station.
  	CreateDynamicPickup(1239, 23, 701.7953,-519.8322,16.3348, -1); //Rental Icon
	CreateDynamicPickup(1239, 23, 757.3734,5.7227,1000.7012, -1); // Train Pos
	CreateDynamicPickup(1239, 23, 758.43,-78.0,1000.65, -1); // Train Pos (MALL GYM)
	CreateDynamicPickup(1239, 23, 2903.371826, -2254.517333, 7.244657, -1); // Train Pos (New GYM)
	CreateDynamicPickup(1239, 23, 293.6505,188.3670,1007.1719, -1); //FBI
	//CreateDynamicPickup(1239, 23, 2354.2808,-1169.2959,28.0066, -1); //Drug Smuggler
	CreateDynamicPickup(1240, 23, 1179.4012451172,-1331.5632324219,2423.0461425781, -1);// /healme//Old Healme: 2103.4998,2824.2568,-16.1672
	CreateDynamicPickup(1239, 23, 1169.7209472656,-1348.3218994141,2423.0461425781, -1);// /Old Insurance: 2086.4915,2826.7122,-16.1744
    CreateDynamicPickup(1210, 23, 63.973995, 1973.618774, -68.786064, -1); //Hitman Pickup
	//CreateDynamicPickup(1240, 23, -1528.814331, 2540.706054, 55.835937, -1);// Deliverpt (TR - El Quebrados)
	//CreateDynamicPickup(1240, 23, 1142.4733,-1326.3633,13.6259, -1);// Deliverpt (All Saints)
	//CreateDynamicPickup(1240, 23, 2027.0599,-1410.6870,16.9922, -1);// Deliverpt (County General)
	//CreateDynamicPickup(1240, 23, 1227.2339,306.4730,19.7028, -1);// Deliverpt (Montgomery)
	//CreateDynamicPickup(1240, 23, -339.2989,1055.8138,19.7392, -1);// Deliverpt (Fort Carson)
	//CreateDynamicPickup(1240, 23, -2695.5725,639.4147,14.4531, -1); // Deliverpt (SF)
	//CreateDynamicPickup(1240, 23, 1165.1564,-1368.8240,26.6502, -1);// Deliverpt (All Saints Rooftop)
	//CreateDynamicPickup(1240, 23, 2024.5742,-1382.7844,48.3359, -1);// Deliverpt (County General)
	//CreateDynamicPickup(1240, 23, 1233.3384,316.4022,24.7578, -1);// Deliverpt (Montgomery Rooftop)
	//CreateDynamicPickup(1240, 23, -334.1560,1051.4434,26.0125, -1);// Deliverpt (Fort Carson Rooftop)
	//CreateDynamicPickup(1240, 23, -2656.0339,615.2567,66.0938, -1);// Deliverpt (SF Rooftop)
	//CreateDynamicPickup(1240, 23, 1579.58,1768.88,10.82, -1);// Deliverpt (LV Hospital)
	//CreateDynamicPickup(1240, 23, -2482.4338,2231.1106,4.8463, -1);// Deliverpt (TR - Bayside)
	//CreateDynamicPickup(1240, 23, 195.56, 2120.69, 18.03, -1); //Deliverpt (DeMorgan) floor 
	//CreateDynamicPickup(1240, 23, -2043.2212,-198.8035,15.0703, -1); // deliverpt doc
	//CreateDynamicPickup(1240, 23, -2196.9641,-2303.8191,30.6250, -1); // deliverpt angel pine
	CreateDynamicPickup(1239, 23, 366.54, 159.09, 1008.38, -1); // LICENSES @ CITY HALL
	CreateDynamicPickup(1239, 23, -1560.963867, 127.491157, 3.554687); //Trucker registration
	CreateDynamicPickup(371, 23, 1544.2,-1353.4,329.4); //LS towertop
	//CreateDynamicPickup(1239, 23, -1446.8916,1503.4746,1.7366); //Drug Boatrun
	CreateDynamicPickup(1239, 23, -1713.961425, 1348.545166, 7.180452, -1); //Pier 69 /getpizza
	CreateDynamicPickup(1239, 23, 2103.6714,-1785.5222,12.9849, -1); // Idlewood /getpizza

	CreateDynamicPickup(371, 23, 1536.0, -1360.0, 1150.0); //LS towertop
	CreateDynamicPickup(1242, 23, 1527.5,-12.1,1002.0); //binco armor
	//CreateDynamicPickup(1240, 23, 279.3000,1853.5619,8.7649); //area51 health
	CreateDynamicPickup(2485, 23, 2958.2200, -1339.2900, 5.2100, 1);// NGGShop - Car Shop
	CreateDynamicPickup(1239, 23, 2950.4014, -1283.0776, 4.6875, 1);// NGGShop - Plane Shop
	CreateDynamicPickup(1239, 23, 2974.7520, -1462.9265, 2.8184, 1);// NGGShop - Boat Shop
	CreateDynamicPickup(1314, 23, 2939.0134, -1401.2946, 11.0000, 1);// NGGShop - VIP Shop
	CreateDynamicPickup(1272, 23, 2938.2734, -1391.0596, 11.0000, 1);// NGGShop - House Shop
	CreateDynamicPickup(1239, 23, 2939.8442, -1411.2906, 11.0000, 1);// NGGShop - Misc Shop
	CreateDynamicPickup(1239, 23, 2927.5000, -1530.0601, 11.0000, 1);// NGGShop - ATM
	CreateDynamicPickup(1239, 23, 2958.0425, -1393.6724, 5.5500, 1);// NGGShop - Hotdog Stand
	CreateDynamicPickup(1241, 23, 2946.8672, -1484.9561, 11.0000, 1);// NGGShop - Healthcare
	CreateDynamicPickup(1239, 23, 2937.2878, -1357.2294, 11.0000, 1);// NGGShop - Gift Reset

	CreateDynamicPickup(1239, 23, 1973.0710, -1298.6427, 25.0172);// Glen Park - Hotdog Stand
	print("[Streamer] Dynamic Pickups have been loaded.");	
	return 1;
}