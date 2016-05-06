#include <streamer>

public OnFilterScriptInit()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) TogglePlayerControllable(i, false);

	}
	// Bratva Mapping
	CreateDynamicObject(18239, 1865.62073, -1444.55249, 12.54600,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1432, 1873.27820, -1447.70801, 12.65780,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1537, 1870.63806, -1444.72681, 12.53630,   0.00000, 0.00000, 90.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(19878, 1870.77747, -1444.19409, 12.98090,   0.00000, 69.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(910, 1871.10413, -1442.84155, 13.47100,   0.00000, 0.00000, 90.00000, .worldid = -1, .streamdistance = 150);
	
	// Rolando Exterior
	CreateDynamicObject(1710, 2150.46338, -1210.28772, 22.87162,   0.00000, 0.00000, 180.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1432, 2140.15015, -1206.40784, 23.03014,   0.00000, 0.00000, -12.42000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1841, 2139.29639, -1190.37317, 22.98960,   0.00000, 0.00000, 180.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1841, 2139.29639, -1193.51819, 22.98960,   0.00000, 0.00000, 180.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(3399, 2105.14185, -1195.49609, 25.30458,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(3593, 2123.00317, -1180.17297, 23.51851,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1245, 2117.43628, -1166.93213, 24.72427,   0.00000, 0.00000, -97.73997, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1362, 2122.39551, -1175.36145, 23.57383,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(19447, 2139.40088, -1210.90515, 21.96020,   0.00000, 0.00000, 90.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(970, 2133.88501, -1208.88074, 23.17306,   0.00000, 0.00000, 110.88001, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1525, 2165.23804, -1188.50403, 23.83045,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1527, 2165.26367, -1183.81531, 23.75004,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1529, 2165.29492, -1178.54590, 23.68661,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1544, 2140.28394, -1206.19836, 23.64230,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(1543, 2140.26807, -1206.75830, 23.64230,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(947, 2154.23853, -1209.84973, 25.02095,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(933, 2145.91016, -1208.67493, 22.90322,   0.00000, 0.00000, 37.26000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(2114, 2153.82324, -1210.30518, 22.99584,   0.00000, 0.00000, 0.00000, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(2226, 2146.19971, -1208.88086, 23.88355,   0.00000, 0.00000, 88.85999, .worldid = -1, .streamdistance = 150);
	CreateDynamicObject(19812, 2144.36353, -1209.40857, 23.41605,   0.00000, 0.00000, -187.01999, .worldid = -1, .streamdistance = 150);


		// Rolando Interior 
	CreateDynamicObject(19378, 332.29019, 2891.81519, 2497.66162,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 330.17380, 2896.77515, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 330.85651, 2893.74609, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.41272, 2892.09204, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 323.11490, 2893.73779, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 327.31079, 2901.44849, 2497.66162,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 333.37979, 2896.77515, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.41089, 2888.88501, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 326.26529, 2887.36304, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1502, 327.05740, 2896.75854, 2497.74854,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.41269, 2895.26001, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.35370, 2898.45996, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.35370, 2901.65991, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 330.74069, 2902.95752, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1502, 324.59021, 2893.66821, 2497.74854,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.62720, 2890.53662, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.62750, 2887.32935, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 325.52380, 2896.77515, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 327.53271, 2902.95752, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 316.81360, 2901.44604, 2497.66162,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 321.79700, 2891.81567, 2497.66162,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 319.90179, 2893.73999, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 323.08701, 2887.35645, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 319.89182, 2887.35498, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 329.46329, 2887.36304, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.66129, 2887.36304, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 322.67120, 2901.59058, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 322.67120, 2898.38208, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 322.32581, 2896.77515, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.32071, 2902.89526, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 317.77310, 2904.36377, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 320.97672, 2904.35742, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.26331, 2904.86060, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1502, 319.20630, 2896.74438, 2497.74854,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 317.64581, 2896.77515, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.26331, 2898.46460, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.26331, 2901.67065, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 318.37579, 2892.07837, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 318.37579, 2888.86841, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(8572, 315.76199, 2890.48511, 2496.50928,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.68680, 2887.63208, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.03210, 2889.02832, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.03210, 2892.18823, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.03210, 2889.02832, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 319.34500, 2891.71875, 2494.23193,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.02393, 2892.20654, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.68680, 2887.63208, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 329.84201, 2898.13623, 2494.23193,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 319.81879, 2887.63208, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 322.95081, 2887.63208, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.60211, 2888.61426, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.60211, 2891.81226, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.03210, 2895.35620, 2495.80542,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.72079, 2896.27808, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 319.92081, 2896.27808, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 323.12079, 2896.27808, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 326.11710, 2893.49731, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 329.32309, 2893.49731, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.51819, 2893.49683, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 334.03329, 2895.19263, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 334.03329, 2898.37866, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 334.03329, 2901.56470, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 332.51819, 2902.75977, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 329.32309, 2902.76050, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 326.11710, 2902.76050, 2495.81128,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.65231, 2901.15161, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 324.65231, 2897.96582, 2495.81128,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 329.74799, 2898.23242, 2497.53857,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 321.79700, 2891.81567, 2497.52246,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 332.29019, 2891.81519, 2500.86035,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.68411, 2895.19727, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 316.68411, 2892.01123, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.03210, 2895.35620, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 315.09381, 2896.27808, 2499.28735,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 321.79700, 2891.81567, 2500.86035,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 316.81360, 2901.44604, 2500.86035,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 327.31079, 2901.44849, 2500.86035,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19378, 311.29901, 2891.81567, 2500.86035,   0.00000, 90.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1527, 323.02328, 2887.47900, 2499.09741,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1525, 318.49933, 2890.99463, 2499.20288,   0.00000, 0.00000, 180.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1529, 320.00992, 2887.52856, 2499.46533,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1712, 324.11023, 2890.97583, 2497.74878,   0.00000, 0.00000, -90.48000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(365, 323.90332, 2888.10767, 2497.92212,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(365, 324.11050, 2887.83228, 2497.76978,   90.00000, 0.00000, -38.46000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(365, 324.16330, 2888.80200, 2497.76978,   90.00000, 0.00000, -182.10004, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2297, 332.15503, 2888.58130, 2497.74878,   0.00000, 0.00000, 177.48009, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19441, 327.85410, 2896.78467, 2502.00513,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19441, 324.62790, 2892.93823, 2502.00513,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19441, 319.96802, 2896.79590, 2502.00513,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1529, 320.67746, 2893.63428, 2499.46533,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1712, 329.36423, 2889.08154, 2497.74902,   0.00000, 0.00000, 46.92001, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(14384, 319.89783, 2900.65381, 2499.22095,   0.00000, 0.00000, 88.98001, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1432, 321.43127, 2902.92334, 2497.85669,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(14780, 330.76434, 2899.62207, 2494.60620,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(14782, 330.87823, 2893.89331, 2495.25879,   0.00000, 0.00000, 180.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1810, 325.21820, 2899.84790, 2494.31885,   0.00000, 0.00000, 115.68002, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1810, 325.74792, 2901.90796, 2494.31885,   0.00000, 0.00000, 38.16000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1810, 325.41806, 2900.78516, 2494.31885,   0.00000, 0.00000, 80.52002, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2964, 326.40631, 2890.10498, 2497.74756,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(3004, 325.25381, 2887.52222, 2499.31445,   -90.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2229, 332.45117, 2893.13696, 2497.74927,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2314, 331.92453, 2892.78003, 2497.74902,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2229, 332.45120, 2890.28101, 2497.74927,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(14820, 331.93121, 2891.99023, 2498.25122,   0.00000, 0.00000, 89.58000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1527, 332.31369, 2892.02954, 2499.33325,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1525, 330.57361, 2899.53882, 2494.34155,   0.00000, 90.00000, 45.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2315, 322.32578, 2889.36060, 2497.74927,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 322.10022, 2889.57715, 2498.24341,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 322.43909, 2889.93555, 2498.24341,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 322.25250, 2890.71240, 2498.24341,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(348, 322.13513, 2891.11035, 2498.24365,   89.76001, -13.98000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(355, 331.30316, 2888.14526, 2499.43164,   85.49991, -66.62005, 80.38003, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2671, 326.75519, 2893.99829, 2497.74951,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 321.62546, 2902.84668, 2498.44189,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 321.52011, 2903.10352, 2498.45776,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1543, 321.13385, 2902.88965, 2498.46851,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1510, 321.43735, 2902.83887, 2498.48145,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2674, 321.05780, 2898.29443, 2497.79004,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1330, 322.06635, 2897.30981, 2498.13940,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(3004, 325.77911, 2887.46924, 2499.30127,   -90.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(3383, 322.52969, 2888.58179, 2494.31787,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(3383, 318.55170, 2888.58179, 2494.31787,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19473, 322.17410, 2888.60767, 2495.54346,   90.00000, 0.00000, 86.21998, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19473, 320.64417, 2888.55322, 2495.54346,   90.00000, 0.00000, 86.21998, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1575, 317.41083, 2888.28027, 2495.37109,   0.00000, 0.00000, -38.46001, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1575, 318.38589, 2888.41284, 2495.37109,   0.00000, 0.00000, 40.50000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1575, 317.72244, 2888.89673, 2495.37109,   0.00000, 0.00000, -29.64000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1230, 316.15778, 2888.62964, 2494.70288,   0.00000, 0.00000, 18.42000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1230, 315.71249, 2889.98853, 2494.70288,   0.00000, 0.00000, -62.22000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(3383, 322.70920, 2892.69727, 2494.31787,   0.00000, 0.00000, 180.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1580, 323.67990, 2892.71143, 2495.37354,   0.00000, 0.00000, 15.90000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1580, 321.64362, 2892.86597, 2495.37354,   0.00000, 0.00000, -25.74000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1580, 323.19339, 2893.02246, 2495.37354,   0.00000, 0.00000, 80.21999, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1580, 321.96484, 2892.12695, 2495.37354,   0.00000, 0.00000, 0.78000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(335, 322.82507, 2892.45850, 2495.33984,   90.00000, 0.00000, -78.54000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1502, 316.77158, 2892.55029, 2497.74854,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19441, 327.55164, 2908.76416, 2502.00513,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(14391, 328.90140, 2902.16724, 2498.64038,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19368, 322.67120, 2904.79150, 2499.28735,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1502, 325.24960, 2896.86450, 2497.74854,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19466, 325.19479, 2899.47290, 2498.68652,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19611, 324.78979, 2900.70288, 2501.00098,   180.00000, 0.00000, 9.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19610, 324.79825, 2900.71094, 2499.36792,   30.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2894, 324.76501, 2900.69727, 2498.55933,   0.00000, 0.00000, -89.58000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1671, 330.64764, 2900.08496, 2498.18408,   0.00000, 0.00000, 180.89992, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1671, 327.38373, 2900.14600, 2498.18408,   0.00000, 0.00000, 178.31995, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1671, 329.04495, 2900.09521, 2498.18408,   0.00000, 0.00000, 178.31995, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19617, 332.28589, 2898.17896, 2499.64868,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19617, 332.28589, 2899.47705, 2499.64868,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(365, 323.83353, 2888.60962, 2497.76978,   90.00000, 0.00000, -249.71997, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(365, 323.67325, 2887.88721, 2497.76978,   90.00000, 0.00000, -209.45998, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2670, 323.23422, 2895.33789, 2497.84668,   0.00000, 0.00000, -60.30000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2670, 320.22360, 2895.15210, 2497.84668,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2672, 319.63232, 2895.56250, 2498.04248,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2672, 328.27435, 2891.91235, 2498.04248,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1529, 315.12680, 2894.84229, 2496.06567,   0.00000, 0.00000, -180.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2725, 324.73642, 2900.69238, 2498.13965,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19422, 324.72751, 2900.70068, 2499.31396,   90.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2255, 327.82983, 2887.92798, 2499.34058,   0.00000, 0.00000, 180.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19460, 325.21710, 2901.59668, 2501.94067,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19466, 325.19479, 2901.69287, 2498.68652,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19466, 325.19479, 2901.69287, 2500.59912,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19466, 325.19479, 2899.47290, 2500.61914,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1498, 332.38312, 2894.47729, 2497.69629,   0.00000, 0.00000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2915, 324.98727, 2898.52075, 2494.40332,   0.00000, 0.00000, -112.13998, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(2915, 325.07834, 2897.86426, 2494.40332,   0.00000, 0.00000, -257.27991, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1544, 325.27734, 2900.11035, 2494.31982,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1544, 325.06253, 2900.04810, 2494.31982,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1544, 325.24515, 2901.37744, 2494.31982,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1544, 325.24490, 2901.15332, 2494.31982,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1544, 325.03073, 2901.53955, 2494.31982,   0.00000, 0.00000, 0.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1230, 316.12012, 2891.59668, 2494.70288,   0.00000, 0.00000, -31.56000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(1575, 319.18512, 2888.52148, 2495.37109,   0.00000, 0.00000, -52.44001, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19556, 330.68045, 2893.82104, 2496.31616,   113.52000, -6.96000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19556, 331.28879, 2893.75806, 2496.31616,   113.52000, -6.96000, 90.00000, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19555, 331.60678, 2893.69385, 2496.33496,   -118.68005, -8.16001, -84.53999, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19555, 330.44940, 2893.82690, 2496.32910,   -118.68005, -8.16001, -21.11998, .worldid = 543, .streamdistance = 150);
	CreateDynamicObject(19441, 317.57941, 2892.58276, 2502.00513,   0.00000, 0.00000, -90.00000, .worldid = 543, .streamdistance = 150);

	//
	CreateDynamicObject(10023, 11667.99414, 8386.33789, 1485.91357,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10023, 11667.42969, 8419.91992, 1485.91357,   0.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11697.60254, 8403.69043, 1476.31189,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11620.87598, 8403.73340, 1476.35925,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11609.12891, 8393.26660, 1476.03894,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11659.23926, 8402.66016, 1476.35925,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11609.99902, 8413.40430, 1476.03894,   0.00000, -90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11697.25293, 8403.79980, 1494.66003,   0.00000, 180.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11620.87695, 8403.75293, 1494.66003,   0.00000, 180.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11643.89941, 8411.61133, 1477.58032,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11670.46680, 8394.50684, 1482.30212,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11644.86816, 8394.61816, 1477.44739,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.08984, 8401.25293, 1477.23718,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.12891, 8407.88379, 1489.93640,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.11426, 8398.33008, 1489.93640,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11659.20020, 8405.24414, 1494.66003,   0.00000, 180.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3471, 11661.59863, 8398.21094, 1478.53418,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3471, 11661.23340, 8408.06934, 1478.53418,   0.00000, 0.00000, -90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11707.49512, 8401.87988, 1481.99683,   90.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11694.94336, 8394.49316, 1482.30212,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14416, 11686.18066, 8407.10059, 1474.39746,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14416, 11682.20215, 8407.09668, 1474.39746,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(12950, 11680.24902, 8398.49902, 1477.15991,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19449, 11675.07520, 8403.88672, 1480.39954,   0.00000, 90.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11704.20410, 8428.21680, 1481.99683,   90.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10023, 11712.37598, 8452.96875, 1486.67505,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10023, 11622.23145, 8454.35742, 1486.67505,   0.00000, 0.00000, -90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11630.14063, 8428.26465, 1481.99683,   90.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10023, 11667.48438, 8498.77148, 1486.67700,   0.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11704.25977, 8460.40723, 1481.99683,   90.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11689.75098, 8491.14648, 1481.99683,   90.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11668.71387, 8491.34863, 1481.99683,   90.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11642.72852, 8491.33984, 1481.99683,   90.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11630.36719, 8477.79785, 1481.99683,   90.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11629.75391, 8452.08887, 1481.99683,   90.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19340, 11689.42676, 8458.85840, 1498.26782,   0.00000, 180.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10060, 11672.95020, 8447.82715, 1454.87512,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11667.12695, 8469.29492, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11667.12305, 8467.98438, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11662.86328, 8467.98438, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11662.86816, 8469.29004, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11671.38574, 8467.98340, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2357, 11671.38379, 8469.29395, 1478.01013,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11659.73926, 8468.47656, 1477.60864,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11674.58594, 8468.61621, 1477.60864,   0.00000, 0.00000, 269.16660, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11667.30566, 8470.78125, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11668.50977, 8470.76758, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11669.71191, 8470.78418, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11670.87793, 8470.77832, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11672.11035, 8470.73926, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11673.29883, 8470.69629, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11666.28809, 8470.77051, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11665.21484, 8470.75879, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11664.13770, 8470.70508, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11663.02539, 8470.78809, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11661.88672, 8470.80664, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11660.94824, 8470.80273, 1477.60510,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11661.19629, 8466.35840, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11662.36133, 8466.36230, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11663.36523, 8466.32813, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11664.30469, 8466.26172, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11665.26074, 8466.27734, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11666.29785, 8466.28711, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11667.43359, 8466.30078, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11668.51465, 8466.30273, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11669.51465, 8466.28418, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11670.47070, 8466.33691, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11671.40723, 8466.31348, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11672.22559, 8466.34277, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1714, 11673.00293, 8466.28906, 1477.60510,   0.00000, 0.00000, 181.12212, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19894, 11673.32227, 8468.14453, 1478.41858,   0.00000, 0.00000, 103.34838, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19807, 11673.33789, 8468.88086, 1478.49866,   0.00000, 0.00000, 64.63070, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(10145, 11667.23633, 8470.91016, 1521.56226,   0.00000, 180.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14782, 11706.65332, 8404.73145, 1477.49878,   0.00000, 0.00000, 269.56479, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3015, 11706.53125, 8401.30371, 1476.57837,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3015, 11706.59570, 8400.76367, 1476.57837,   0.00000, 0.00000, 320.37033, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1271, 11706.12891, 8407.70313, 1476.79614,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1271, 11705.43652, 8408.29297, 1476.79614,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1271, 11705.73535, 8407.74805, 1477.49341,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18048, 11715.24512, 8399.19238, 1476.66028,   0.00000, 0.00000, 180.07164, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18044, 11713.10254, 8404.20898, 1478.11816,   0.00000, 0.00000, 180.37976, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3015, 11703.26855, 8397.09375, 1476.57837,   0.00000, 0.00000, 320.37033, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(964, 11702.07129, 8397.43555, 1476.42017,   0.00000, 0.00000, 355.69229, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(964, 11701.87012, 8398.74121, 1476.42017,   0.00000, 0.00000, 355.69229, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(964, 11701.89844, 8397.88184, 1477.41919,   0.00000, 0.00000, 12.47265, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11705.76660, 8411.73340, 1482.30212,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(5262, 11694.80176, 8404.55078, 1479.30701,   0.00000, 0.00000, 180.64484, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14629, 11618.76270, 8410.92090, 1493.68591,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14629, 11643.56055, 8403.10645, 1493.72571,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14629, 11667.62109, 8403.18555, 1493.72571,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9946, 11609.99902, 8413.40430, 1476.03894,   0.00000, -90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11601.20313, 8404.25488, 1483.70264,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1508, 11601.81836, 8403.32910, 1479.24719,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(9931, 11579.00781, 8403.23340, 1492.97119,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(18981, 11704.27441, 8483.98438, 1481.99683,   90.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(3462, 11668.01660, 8395.84570, 1478.63196,   0.00000, 0.00000, 269.20334, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1704, 11626.79492, 8410.62402, 1476.47607,   0.00000, 0.00000, -90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2311, 11624.08887, 8410.08691, 1476.47937,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1703, 11623.82227, 8411.58789, 1476.47864,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2855, 11624.84473, 8410.14355, 1476.96436,   0.00000, 0.00000, 340.71069, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1704, 11626.93848, 8396.43262, 1476.47607,   0.00000, 0.00000, -90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2311, 11624.01270, 8395.94824, 1476.47937,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(1703, 11625.77734, 8394.54883, 1476.47864,   0.00000, 0.00000, 180.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14560, 11634.56836, 8454.51855, 1482.06116,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14565, 11634.63867, 8454.47070, 1479.59558,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.39551, 8455.64063, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.43164, 8454.84570, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.32031, 8456.45703, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.36914, 8453.98535, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.41504, 8453.15332, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.20996, 8457.21875, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.31641, 8452.38477, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.07813, 8450.77441, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2723, 11639.21582, 8451.57227, 1477.96692,   0.00000, 0.00000, 0.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19786, 11634.70898, 8451.48633, 1480.75049,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19786, 11634.68945, 8454.48730, 1480.73047,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(19786, 11634.70020, 8457.56738, 1480.77051,   0.00000, 0.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(14835, 11625.51758, 8454.22754, 1478.98840,   0.00000, 0.00000, 94.82339, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1479.16809,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1481.08728,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1483.10754,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1485.11780,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1487.09644,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1489.09436,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);
	CreateDynamicObject(2774, 11674.03320, 8401.24707, 1491.09204,   0.00000, 90.00000, 90.00000, .interiorid = 5, .worldid = 333, .streamdistance = 200);

		// THE COMMUNITY GANG EXTERIOR 
	CreateDynamicObject(8613, 1266.81958, -1688.61780, 35.30072,   0.00000, 0.00000, 269.576810, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(18850, 1276.84741, -1629.52563, 21.68851,   0.00000, 0.00000, 0.509070, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(14782, 1225.07104, -1638.14172, 11.71435,   0.00000, 0.00000, 0.201000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(18766, 1254.98364, -1653.07263, 11.25776,   70.38840, 0.00000, 89.762370, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(18766, 1244.98499, -1653.63696, 10.46890,   72.38840, 0.00000, 90.468330, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(19905, 1248.33533, -1693.99072, 33.77090,   0.00000, 0.00000, 359.881470, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(19905, 1279.36816, -1665.72620, 33.77090,   0.00000, 0.00000, 269.497990, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(19909, 1282.73181, -1697.03625, 38.41956,   0.00000, 0.00000, 359.991330, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(18981, 1255.59802, -1655.90161, 26.88969,   0.00000, 90.00000, 0.000000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(8613, 1214.59766, -1635.71289, 30.65935,   0.00000, 0.00000, 359.270020, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(1267, 1254.44067, -1626.45142, 47.54469,   0.00000, 0.00000, 56.893260, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(14637, 1289.23706, -1652.41760, 20.79329,   0.00000, 0.00000, 0.000000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(9482, 1287.53723, -1652.40283, 18.45932,   0.00000, 0.00000, 0.000000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(8151, 1246.08374, -1649.53503, 28.84378,   0.00000, 0.00000, 90.187770, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(2774, 1206.52417, -1652.47852, 23.78114,   90.00000, 90.00000, 89.799000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(2774, 1206.41357, -1676.13452, 23.78114,   90.00000, 90.00000, 89.799000, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(8613, 1262.27930, -1650.04932, 31.01639,   0.00000, 0.00000, 269.296720, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(14782, 1278.97668, -1682.96460, 34.97759,   0.00000, 0.00000, 179.929630, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	CreateDynamicObject(19909, 1236.50916, -1667.09180, 33.99400,   0.00000, 0.00000, 359.991300, .interiorid = -1, .worldid = -1, .streamdistance = 200);
	//Hilltop
		//Interior
	CreateDynamicObject(19379, -72.12000, 573.31000, 1002.08002,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -72.12000, 582.92999, 1002.08002,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -82.61000, 582.92999, 1002.08002,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -82.59000, 573.31000, 1002.08002,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19366, -68.57000, 580.63000, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19366, -68.53000, 577.46997, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19366, -66.88000, 579.13000, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -74.89000, 580.63000, 1002.15002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -77.06000, 584.42999, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1536, -66.96000, 579.83002, 1002.15997,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1491, -74.84000, 577.46997, 1002.15002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -77.01000, 573.66998, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -78.64000, 582.92999, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19366, -78.64000, 575.23999, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19412, -80.19000, 576.81000, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19412, -80.19000, 581.48999, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -80.19000, 578.39001, 1002.15002,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19412, -75.92000, 576.35999, 1003.75000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19412, -75.96000, 581.76001, 1003.75000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19412, -71.77000, 580.63000, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19412, -71.74000, 577.46997, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19379, -72.12000, 582.92999, 1005.51001,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -72.12000, 573.31000, 1005.51001,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -82.61000, 582.92999, 1005.51001,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, -82.61000, 573.31000, 1005.51001,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19439, -80.19000, 579.15997, 1006.38000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19439, -74.08000, 580.63000, 1006.38000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19439, -74.04000, 577.46997, 1006.38000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19458, -72.27000, 587.78998, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19458, -72.08000, 570.03003, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19458, -69.73000, 569.45001, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19458, -69.73000, 588.71002, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19458, -87.92000, 579.32001, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19458, -84.87000, 583.17999, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19458, -89.40000, 575.21002, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -75.96000, 581.83002, 1003.66998,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19466, -75.89000, 576.40997, 1003.66998,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19466, -71.91000, 577.47998, 1003.66998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -71.96000, 580.65002, 1003.66998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -80.20000, 581.50000, 1003.66998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19466, -80.20000, 576.62000, 1003.66998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -77.01000, 570.46997, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -77.06000, 587.63000, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2205, -85.57000, 579.85999, 1002.16998,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1704, -83.69314, 581.04303, 1002.16998,   0.00000, 0.00000, -52.50000);
	CreateDynamicObject(1704, -83.14867, 578.12000, 1002.16998,   0.00000, 0.00000, -127.20000);
	CreateDynamicObject(1671, -87.28916, 579.31537, 1002.59003,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1829, -87.10000, 575.81000, 1002.60999,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2614, -87.78000, 579.22998, 1004.41998,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2190, -85.26000, 579.67999, 1003.09998,   0.00000, 0.00000, -91.26000);
	CreateDynamicObject(1510, -85.49000, 578.20001, 1003.12000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3044, -85.45000, 578.34003, 1003.15002,   -24.12000, 88.50000, 0.00000);
	CreateDynamicObject(1668, -85.40000, 578.58002, 1003.26001,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2894, -85.72000, 579.15997, 1003.09998,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(356, -86.16000, 580.10999, 1002.44000,   6.48000, 272.39999, 90.00000);
	CreateDynamicObject(14455, -85.27550, 575.27612, 1003.67999,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2043, -81.05000, 582.54999, 1002.27002,   0.00000, 0.00000, -199.56000);
	CreateDynamicObject(2985, -80.62000, 582.62000, 1002.15002,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2043, -81.50000, 582.76001, 1002.27002,   0.00000, 0.00000, -288.66000);
	CreateDynamicObject(2063, -86.50000, 582.81000, 1003.07001,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(359, -86.52000, 582.66998, 1003.00000,   90.00000, 0.00000, 180.00000);
	CreateDynamicObject(2061, -87.03000, 582.76001, 1004.12000,   0.24000, -0.18000, 0.00000);
	CreateDynamicObject(360, -86.22000, 582.59998, 1003.84998,   90.00000, 0.00000, 180.00000);
	CreateDynamicObject(2205, -74.11000, 572.21997, 1002.15002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1703, -74.41000, 573.96997, 1002.16998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2190, -74.02000, 572.38000, 1003.09003,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2894, -73.49000, 571.97998, 1003.09003,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1671, -73.72686, 570.59851, 1002.60999,   0.00000, 0.00000, 168.78000);
	CreateDynamicObject(356, -72.78000, 572.01001, 1003.10999,   94.80000, 32.04000, 90.00000);
	CreateDynamicObject(14455, -71.98000, 570.12000, 1003.71002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14455, -79.08000, 570.12000, 1003.71002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1736, -73.39000, 570.40002, 1004.62000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2004, -76.96000, 570.91998, 1004.03003,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2886, -76.99000, 571.90002, 1004.03003,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2400, -69.85000, 574.04999, 1002.37000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(359, -70.30000, 573.56000, 1003.25000,   90.00000, 0.00000, 93.36000);
	CreateDynamicObject(360, -70.14000, 571.35999, 1003.27002,   90.00000, 180.00000, 90.00000);
	CreateDynamicObject(2061, -69.92000, 574.34003, 1004.59003,   0.00000, 0.00000, 116.04000);
	CreateDynamicObject(2061, -69.98000, 574.03998, 1004.59003,   0.00000, 0.00000, 65.94000);
	CreateDynamicObject(2043, -70.08000, 573.53003, 1004.42999,   0.00000, 0.00000, 19.02000);
	CreateDynamicObject(19165, -76.92000, 573.67999, 1004.00000,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(2205, -72.52000, 585.64001, 1002.14001,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1703, -72.13000, 583.72998, 1002.15002,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2190, -72.70000, 585.48999, 1003.08002,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2894, -73.34000, 585.75000, 1003.08002,   0.00000, -0.06000, 151.02000);
	CreateDynamicObject(1510, -74.04000, 585.46002, 1003.09998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3044, -74.06000, 585.53998, 1003.03003,   -32.16000, -59.22000, 0.00000);
	CreateDynamicObject(2614, -73.27000, 587.65997, 1004.46002,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1671, -73.29270, 587.19476, 1002.63000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2985, -74.77000, 585.77002, 1002.15002,   0.00000, 0.00000, 291.78000);
	CreateDynamicObject(2985, -71.63000, 585.77002, 1002.15002,   0.00000, 0.00000, 246.78000);
	CreateDynamicObject(14455, -76.96000, 588.40997, 1003.70001,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(335, -73.99000, 585.77002, 1003.34003,   180.00000, 0.00000, 90.00000);
	CreateDynamicObject(2358, -70.22000, 580.96997, 1002.28998,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2358, -70.22000, 580.96997, 1002.51001,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2359, -70.02000, 581.65002, 1002.37000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1702, -79.86000, 582.29999, 1002.10999,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1702, -78.02000, 575.85999, 1002.10999,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1808, -77.50000, 575.53003, 1002.14001,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1808, -77.50000, 582.65002, 1002.14001,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2283, -79.00000, 575.34998, 1004.00000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2289, -78.89000, 582.79999, 1004.19000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2048, -73.19080, 585.15222, 1002.58661,   -1.26000, 0.00000, 0.00000);
	CreateDynamicObject(2048, -85.05890, 579.18390, 1002.61328,   -2.46000, 0.00000, 90.00000);
	CreateDynamicObject(2048, -73.45000, 572.67999, 1002.59998,   2.82000, 0.00000, 180.00000);
	CreateDynamicObject(1951, -74.24000, 585.94000, 1003.26001,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19366, -81.51010, 575.21002, 1003.75000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19439, -83.89280, 575.21002, 1006.20001,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1491, -84.62220, 575.15088, 1001.96997,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19394, -83.83160, 575.16779, 1003.70551,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -87.03510, 575.16779, 1003.70551,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -80.62000, 575.16779, 1003.70551,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, -87.19380, 570.28998, 1003.70551,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, -80.52390, 570.28278, 1003.70551,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, -83.92637, 568.69177, 1003.70551,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1810, -84.26760, 571.38977, 1002.16803,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2400, -80.64170, 573.18402, 1002.19928,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19086, -80.79026, 570.30627, 1003.12903,   90.00000, 0.00000, 103.56000);
	CreateDynamicObject(2907, -86.81910, 569.12628, 1002.56183,   303.54001, 18.92000, -23.58000);
	CreateDynamicObject(2905, -86.43113, 569.49994, 1002.29620,   -0.48000, 92.28000, 323.33990);
	CreateDynamicObject(2905, -86.63310, 569.66522, 1002.29620,   3.78000, 91.92000, 334.07959);
	CreateDynamicObject(2906, -86.99706, 569.20221, 1002.59961,   301.79980, -128.46001, 0.00000);
	CreateDynamicObject(2906, -86.65946, 569.30804, 1002.36035,   0.00000, 0.00000, 42.23999);
	CreateDynamicObject(335, -86.73788, 569.37262, 1002.67139,   110.10004, -0.48000, -28.92001);
	CreateDynamicObject(2908, -80.97620, 571.05243, 1004.20923,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2045, -81.07784, 572.95190, 1003.09668,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2045, -80.99838, 571.81458, 1003.09668,   0.00000, 0.00000, 178.68008);
	CreateDynamicObject(1886, -86.38642, 574.25452, 1005.57837,   26.88001, 2.64000, 43.02002);
	CreateDynamicObject(18067, -86.17015, 570.14813, 1002.18799,   0.00000, 0.00000, 35.69995);
	CreateDynamicObject(2475, -87.08010, 573.49280, 1002.07642,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(321, -86.83770, 573.13910, 1002.85730,   90.00000, 105.00000, 90.00000);
	CreateDynamicObject(321, -86.77398, 574.07709, 1002.85730,   90.00000, 105.00000, 117.96001);
	CreateDynamicObject(322, -86.97420, 573.07147, 1003.66553,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(322, -86.96729, 573.35413, 1003.66553,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2048, -83.93560, 568.78491, 1004.12360,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19088, -84.46944, 570.31763, 999.95313,   197.27991, 16.20000, 204.84059);
	CreateDynamicObject(2844, -83.35983, 571.31232, 1002.16803,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2673, -85.89436, 572.18665, 1002.26782,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2674, -81.99718, 574.11682, 1002.18817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19412, -69.73000, 575.86438, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19365, -68.10430, 576.85687, 1003.08868,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -68.04890, 574.88452, 1003.08868,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -68.60599, 575.63904, 1003.08868,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19365, -67.99740, 575.82593, 1004.71771,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19372, -67.95300, 575.52258, 1003.08759,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1610, -68.92432, 575.34790, 1003.17590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1604, -69.29088, 575.51929, 1003.91046,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1600, -69.41393, 576.13086, 1004.14050,   0.00000, 0.00000, 179.09999);
	CreateDynamicObject(1649, -69.77190, 575.30579, 1003.77832,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1604, -69.17329, 576.06805, 1003.38757,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1510, -72.44860, 572.07501, 1003.09998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3044, -72.48950, 572.15430, 1003.03003,   -32.16000, -59.22000, 0.00000);
	CreateDynamicObject(19412, -69.73000, 582.29303, 1003.75000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19365, -68.65316, 582.15149, 1003.08868,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19365, -68.14160, 583.27863, 1003.08868,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -68.19200, 581.30139, 1003.08868,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19365, -67.94337, 582.32574, 1004.71771,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19372, -68.02393, 582.62244, 1003.08759,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1605, -68.56343, 584.40637, 1003.80817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1611, -69.35867, 582.74316, 1003.17511,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1649, -69.79015, 583.35260, 1003.77832,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1606, -68.33160, 584.40607, 1004.22290,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2004, -76.64200, 587.74860, 1003.91779,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2886, -86.12320, 575.21771, 1003.95441,   0.00000, 0.00000, 180.00000);


	// older hilltop stuff
	// HILTOP NEW EXTERIOR 29/03/2016
CreateDynamicObject(987, 1005.81000, -285.14001, 72.99000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1005.84003, -369.04999, 72.55000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1039.13000, -369.17999, 72.73000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1051.18994, -369.07999, 72.99000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3279, 1033.76001, -287.57999, 72.99000,   0.00000, 0.00000, 267.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3279, 1115.42004, -266.89001, 72.09000,   0.00000, 0.00000, 205.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1063.30005, -369.28000, 72.99000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1075.19995, -369.34000, 72.99000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1087.12000, -369.48999, 72.96000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1099.17004, -369.50000, 72.89000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1110.88000, -369.54999, 72.92000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.03003, -369.67001, 72.54000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.06995, -357.92001, 72.96000,   0.00000, 0.00000, 90.71000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1122.92273, -345.97989, 72.96000,   0.00000, 0.00000, 87.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.34497, -334.14139, 72.96000,   0.00000, 0.00000, 87.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.81006, -322.26596, 72.96000,   0.00000, 0.00000, 87.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1135.48560, -298.69019, 72.20730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8614, 1043.54004, -284.76999, 75.22000,   0.00000, 0.00000, 181.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.90002, -356.95001, 72.87000,   0.00000, 0.00000, 266.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.84998, -344.97000, 72.89000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.46002, -333.07999, 72.83000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.15997, -321.12000, 72.85000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.03998, -309.13000, 72.92000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1005.82001, -297.12000, 72.98000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1015.85999, -278.51001, 72.55000,   0.00000, 0.00000, 213.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1027.75000, -278.26001, 72.43000,   0.00000, 0.00000, 182.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1039.69995, -279.17001, 72.37000,   0.00000, 0.00000, 176.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1050.90002, -279.75000, 72.98000,   0.00000, 0.00000, 177.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1057.40002, -269.70001, 72.60000,   0.00000, 0.00000, 237.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1060.30005, -258.10001, 72.50000,   0.00000, 0.00000, 256.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1082.09998, -253.10001, 73.00000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1116.90002, -256.79999, 71.49000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.90002, -266.50000, 71.10000,   0.00000, 0.00000, 126.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1121.50000, -286.89999, 72.80000,   0.00000, 0.00000, 81.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.67664, -298.54999, 73.01000,   0.00000, 0.00000, 101.54001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1027.06995, -369.17999, 72.74000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3279, 1012.29999, -358.50000, 73.00000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3648, 1115.17004, -356.06000, 75.74000,   0.02000, 0.02000, 358.04999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8572, 1021.04999, -284.39001, 75.21000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11503, 1095.95996, -299.79999, 73.11000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3355, 1035.76001, -353.37000, 72.99000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3356, 1116.48999, -337.47000, 77.39000,   0.00000, 0.00000, 267.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3802, 1109.83997, -353.50000, 75.68000,   0.00000, 0.00000, 172.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1105.69995, -331.20001, 73.62000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1035.76001, -346.89999, 77.52000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1069.71997, -348.82999, 75.29000,   0.00000, 0.00000, 181.67999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1736, 1033.71997, -346.54001, 76.77000,   0.00000, 0.00000, 177.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1255, 1107.85999, -333.14999, 73.60000,   0.00000, 0.00000, -150.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1095.95996, -302.79999, 76.25000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1106.48999, -303.31000, 75.15000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1109.81006, -356.85999, 75.46000,   0.00000, 0.00000, 268.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1031.28003, -314.01001, 76.25000,   0.00000, 0.00000, 357.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1101.92004, -333.00000, 73.60000,   0.00000, 0.00000, 271.20999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1102.80005, -332.89999, 73.70000,   0.00000, 0.00000, 357.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1080.43994, -326.45001, 74.70000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1736, 1037.87000, -346.60001, 76.79000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1016.69000, -342.22000, 75.18000,   0.00000, 0.00000, 88.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3525, 1082.80005, -292.70001, 73.50000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1099.85999, -298.64999, 72.99000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1045.48999, -315.50000, 78.30000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2725, 1089.22998, -298.85001, 73.43000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2922, 1013.70001, -386.10001, 71.90000,   0.00000, 10.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1009.46002, -337.60001, 73.50000,   0.00000, 0.00000, 179.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1013.00000, -321.00000, 73.00000,   0.00000, 0.00000, 91.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1009.04999, -321.10001, 73.60000,   0.00000, 0.00000, 181.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1019.90002, -329.10001, 75.20000,   0.00000, 0.00000, 92.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1016.32001, -369.26999, 76.01000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1028.59998, -369.39999, 76.01000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3398, 1008.70001, -366.89999, 75.10000,   0.00000, 0.00000, 150.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3398, 1008.52002, -286.26001, 75.12000,   0.00000, 0.00000, 48.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3398, 1122.19995, -269.10001, 75.10000,   0.00000, 0.00000, 297.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3398, 1122.59998, -368.97000, 75.12000,   0.00000, 0.00000, 225.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(5837, 1015.00000, -386.10001, 72.30000,   0.00000, 349.98999, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(16326, 1082.95996, -324.85999, 72.99000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1084.45996, -331.03000, 72.76000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1118.63000, -346.91000, 73.43000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1506, 1079.31006, -322.16000, 72.86000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2063, 1087.96997, -316.82001, 76.55000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1736, 1079.00000, -322.89001, 75.87000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3461, 1076.44995, -324.66000, 73.03000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3461, 1076.43994, -321.20001, 73.03000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 157.53999, 59.16000, 468.31000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1086.48999, -314.07001, 72.76000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1090.41003, -314.09000, 73.39000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17063, 1035.75000, -354.56000, 81.80000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2235, 1035.26001, -357.04999, 81.81000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2063, 1039.78003, -350.29001, 82.62000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1520, 1035.97998, -356.60001, 82.32000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1665, 1035.35999, -356.56000, 82.31000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1846, 1035.95996, -359.16000, 83.76000,   90.00000, 90.00000, 268.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2229, 1033.98999, -360.42001, 83.08000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2229, 1037.30005, -360.34000, 83.08000,   0.00000, 0.00000, 185.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1099.76001, -294.76999, 73.48000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(6865, 1089.51001, -349.04999, 82.38000,   0.00000, 0.00000, 226.64000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1045.51001, -285.70999, 78.35000,   0.00000, 0.00000, 89.97000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1019.35999, -285.31000, 78.35000,   0.00000, 0.00000, 89.97000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1508, 1045.70996, -315.70001, 74.20000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3249, 1089.53003, -355.85999, 72.98000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3525, 1090.55005, -346.89999, 74.12000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3525, 1088.50000, -346.91000, 74.12000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1106.84998, -312.01999, 73.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1087.55005, -345.17001, 73.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1091.77002, -345.32999, 73.08000,   0.00000, 0.00000, 2.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1037.76001, -344.67001, 73.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1034.62000, -343.34000, 73.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1508, 1031.28003, -356.17999, 83.53000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2714, 1074.13000, -348.79001, 75.34000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1089.46997, -348.51999, 79.18000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11497, 1013.90002, -344.00000, 73.00000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1087.50000, -299.67001, 73.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11496, 1035.79004, -354.70001, 81.67000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11496, 1035.75000, -354.70001, 81.67000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8615, 1030.82996, -361.39999, 74.54000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(12950, 1044.58997, -354.88000, 78.36000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11496, 1034.48999, -306.04999, 81.42000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11496, 1030.48999, -306.01999, 81.42000,   0.00000, 0.00000, 179.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8614, 1032.40002, -354.23001, 83.84000,   0.00000, 0.00000, 87.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1089.19995, -324.70999, 76.24000,   90.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1086.40002, -324.79001, 76.24000,   90.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2064, 1087.77002, -323.22000, 76.23000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2290, 1034.77002, -354.20001, 81.87000,   0.00000, 0.00000, 358.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1754, 1033.92004, -355.79001, 81.87000,   0.00000, 0.00000, 44.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2566, 1034.54004, -351.35001, 82.45000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2004, 1038.18994, -348.88000, 83.67000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11445, 1032.34998, -308.95001, 81.62000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3066, 1032.20996, -299.79999, 82.50000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8613, 1021.84003, -304.56000, 78.04000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8614, 1027.62000, -294.60001, 74.47000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1083.70996, -299.53000, 73.10000,   0.00000, 0.00000, 37.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1109.40002, -341.20001, 73.64000,   0.00000, 0.00000, 357.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(13360, 1087.83997, -295.20999, 74.93000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(12937, 1090.31006, -292.09000, 75.91000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(16285, 1032.79004, -310.42999, 72.99000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3525, 1091.30005, -295.60001, 73.60000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3403, 1065.52002, -355.39999, 80.00000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1025.69995, -360.60001, 73.10000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1020.40002, -361.10001, 73.10000,   0.00000, 0.00000, 348.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1045.53003, -315.57999, 78.00000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(16285, 1114.00000, -318.50000, 73.00000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1106.42004, -343.03000, 73.58000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1028.80005, -368.00000, 73.80000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1022.79999, -315.17999, 73.50000,   90.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1016.00000, -315.22000, 73.50000,   90.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11501, 1014.21997, -327.20001, 73.00000,   0.00000, 0.00000, 91.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1016.90002, -359.10001, 73.80000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1027.90002, -360.29999, 73.80000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1033.69995, -364.60001, 77.20000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3415, 1096.27002, -332.81000, 73.00000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1764, 1098.59998, -331.50000, 73.00000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2207, 1094.90002, -333.60001, 73.00000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1765, 1095.69995, -331.39999, 73.00000,   0.00000, 0.00000, 308.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1765, 1096.30005, -333.20001, 73.00000,   0.00000, 0.00000, 240.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1765, 1092.80005, -333.04999, 73.00000,   0.00000, 0.00000, 88.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1093.90002, -334.89999, 75.10000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1015.90997, -367.10001, 73.84000,   0.00000, 0.30000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1010.40002, -367.10001, 73.87000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1017.40997, -341.10001, 75.20000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1037.40002, -364.50000, 77.30000,   0.00000, 0.00000, 360.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1108.69995, -331.20001, 73.70000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1107.19995, -360.17999, 73.60000,   0.00000, 0.00000, 87.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3532, 1106.92004, -349.69000, 73.60000,   0.00000, 0.00000, 91.26000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1255, 1107.41003, -357.57001, 73.60000,   0.00000, 0.00000, 179.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1114.73999, -346.76999, 72.90000,   0.00000, 0.00000, 89.16000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1107.28003, -315.76001, 75.18000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1550, 1038.80005, -349.29999, 82.30000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2345, 1110.80005, -337.50000, 76.37000,   0.00000, 0.00000, 266.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2345, 1110.80005, -335.79999, 76.37000,   0.00000, 0.00000, 268.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2345, 1111.00000, -333.60001, 76.32000,   0.00000, 0.00000, 268.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2345, 1110.90002, -331.39999, 76.35000,   0.00000, 0.00000, 268.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3785, 1114.06995, -335.60001, 75.40000,   0.00000, 0.00000, 198.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(16011, 1072.30005, -353.89999, 73.50000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1070.40002, -251.80000, 72.70000,   0.00000, 0.00000, 211.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1094.00000, -254.30000, 73.30000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1105.09998, -255.50000, 72.60000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1122.40002, -278.29999, 71.60000,   0.00000, 0.00000, 81.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3279, 1068.80005, -260.50000, 72.80000,   0.00000, 0.00000, 317.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3283, 1061.00000, -274.50000, 72.80000,   0.00000, 0.00000, 152.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3285, 1114.09998, -278.10001, 74.60000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3362, 1104.14001, -259.67999, 72.40000,   0.00000, 0.00000, 242.47000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3171, 1087.40002, -263.00000, 74.00000,   0.00000, 0.00000, 66.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3167, 1077.80005, -260.79999, 73.50000,   0.00000, 0.00000, 204.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3168, 1090.40002, -274.79999, 73.50000,   4.00000, 0.00000, 16.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3175, 1081.40002, -280.29999, 72.80000,   0.00000, 0.00000, 266.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3174, 1097.05005, -265.64999, 73.70000,   0.00000, 0.00000, 65.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3173, 1102.80005, -287.29999, 73.00000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1116.90002, -256.79999, 76.30000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1105.09998, -255.50000, 77.50000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1094.00000, -254.30000, 78.10000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1082.09998, -253.10001, 77.80000,   0.00000, 0.00000, 174.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1070.40002, -251.80000, 77.70000,   0.00000, 0.00000, 211.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1060.30005, -258.10001, 77.30000,   0.00000, 0.00000, 255.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1057.40002, -269.70001, 77.40000,   0.00000, 0.00000, 237.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1050.90002, -279.70001, 77.70000,   0.00000, 0.00000, 177.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1039.69995, -279.20001, 77.30000,   0.00000, 0.00000, 176.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1027.80005, -278.29999, 77.20000,   0.00000, 0.00000, 182.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1015.90002, -278.50000, 77.10000,   0.00000, 0.00000, 213.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1005.79999, -285.10001, 77.70000,   0.00000, 0.00000, 269.98999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1005.79999, -297.10001, 78.00000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.00000, -309.10001, 77.70000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.20001, -321.10001, 77.60000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.50000, -333.10001, 77.60000,   0.00000, 0.00000, 272.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.90002, -345.00000, 77.40000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1006.90002, -357.00000, 77.60000,   0.00000, 0.00000, 266.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1005.84003, -369.04999, 77.50000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1027.09998, -369.20001, 77.60000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1039.09998, -369.20001, 77.70000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1063.30005, -369.29999, 77.70000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1051.19995, -369.10001, 77.70000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1075.19995, -369.29999, 77.70000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1099.19995, -369.50000, 77.60000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1087.09998, -369.50000, 77.70000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1110.90002, -369.50000, 77.40000,   0.00000, 0.00000, 359.98001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.00000, -369.70001, 77.40000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.90002, -266.50000, 75.90000,   0.00000, 0.00000, 126.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1122.40002, -278.29999, 76.40000,   0.00000, 0.00000, 81.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1121.50000, -286.89999, 77.60000,   0.00000, 0.00000, 81.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1100.88000, -262.34000, 73.34000,   0.00000, 0.00000, 347.47000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1084.69995, -264.79999, 74.08000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1100.00000, -272.20001, 73.78000,   0.00000, 0.00000, 348.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11503, 1096.50000, -320.50000, 73.10000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1052.54004, -346.42999, 73.10000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1055.48999, -346.66000, 73.10000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8615, 1043.20996, -348.20999, 74.30000,   0.00000, 0.00000, 178.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(12957, 1106.40002, -269.10001, 73.70000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3594, 1085.30005, -256.89999, 74.70000,   0.00000, 0.00000, 82.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10832, 1060.69995, -311.29999, 71.60000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3934, 1060.54004, -311.39999, 73.30000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10832, 1060.59998, -301.60001, 71.60000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10832, 1060.40002, -291.39999, 71.60000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3934, 1060.40002, -301.70001, 73.30000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3934, 1060.40002, -291.50000, 73.30000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11455, 1019.40002, -315.20001, 77.57000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1018.16998, -315.25000, 78.20000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1017.34003, -315.23001, 71.80000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1021.04999, -315.23001, 71.79000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1017.90002, -315.25000, 78.20000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3279, 1099.01001, -362.14001, 73.00000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1358, 1097.93005, -257.54001, 74.50000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1369, 1018.72998, -323.98999, 74.10000,   0.00000, 0.00000, 65.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(14638, 1090.57996, -363.26001, 73.00000,   0.00000, 4.44000, 91.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1033.80005, -367.89999, 73.72000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1049.35999, -367.29999, 73.80000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(8615, 1059.43994, -352.57001, 75.50000,   0.00000, 0.00000, 270.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1062.98999, -366.85001, 73.86000,   0.00000, 0.00000, 360.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1075.53003, -358.10999, 77.92000,   2.90000, 0.00000, 360.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3403, 1032.09998, -309.00000, 84.66000,   0.00000, 0.00000, 3.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3403, 1078.42004, -354.54999, 79.99000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(944, 1080.13000, -357.98999, 77.92000,   2.90000, 0.00000, 360.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11445, 1066.28003, -357.72000, 77.01000,   0.00000, 0.00000, 162.88000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1107.40002, -348.79001, 73.51000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3250, 1105.01001, -321.34000, 72.94000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3250, 1108.51001, -297.73001, 73.04000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19315, 1104.76001, -359.20999, 73.47000,   0.00000, 0.00000, 55.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19315, 1104.05005, -332.51999, 73.47000,   0.00000, 0.00000, -145.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1736, 1086.84998, -295.48999, 75.67000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1090.07996, -295.35999, 75.55000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1052.88000, -350.94000, 78.01000,   0.00000, 0.00000, 181.67999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11503, 1119.70996, -297.50000, 73.11000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1079.90002, -272.29999, 73.64000,   0.00000, 0.00000, 348.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19317, 1102.18005, -261.22000, 73.79000,   0.00000, 0.00000, -25.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19173, 1036.10999, -348.92001, 84.25000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19170, 1032.93005, -360.20001, 83.99000,   270.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19171, 1039.06995, -360.20001, 83.78000,   270.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1508, 1094.16003, -355.16000, 74.20000,   0.00000, 0.00000, 0.77000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2672, 1103.38000, -266.67999, 73.55000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1765, 1090.25000, -298.14999, 72.99000,   0.00000, 0.00000, 310.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1767, 1105.13000, -264.45001, 72.80000,   0.00000, 0.00000, -65.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1137.14001, -197.37000, 40.79000,   0.00000, 0.00000, 14.42000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1136.10999, -193.56000, 41.34000,   0.00000, 0.00000, 104.41000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1493, 1034.98999, -361.75000, 73.40000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1017.34003, -315.23001, 74.50000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1021.04999, -315.23001, 74.50000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2878, 1018.72998, -315.17001, 74.12000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(18368, 1128.53003, -215.83000, 50.72000,   0.00000, 0.00000, 100.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19314, 1019.54999, -343.35999, 75.87000,   90.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1506, 1114.26001, -335.23001, 73.57000,   0.00000, 0.00000, 89.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(13360, 1045.45996, -285.66000, 77.52000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(13360, 1019.26001, -285.25000, 77.52000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1052.97998, -309.31000, 70.46000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1045.68005, -285.72000, 70.95000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1018.15997, -285.39999, 70.57000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1038.18994, -291.51001, 70.42000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1011.98999, -291.89999, 70.43000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2415, 1118.04004, -344.00000, 77.10000,   0.00000, 0.00000, 0.47000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19375, 1026.81006, -308.67001, 70.42000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1106.48999, -330.01999, 73.51000,   3.14000, 0.00000, 0.02000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1110.40002, -351.51001, 73.60000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1104.83997, -330.01001, 73.51000,   0.00000, 0.00000, 178.21001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1104.31006, -358.75000, 73.60000,   0.00000, 0.00000, 269.57001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1104.35999, -351.29999, 73.60000,   0.00000, 0.00000, 269.57001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1107.18005, -361.38000, 73.60000,   0.00000, 0.00000, 359.29999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1109.97998, -343.63000, 73.60000,   0.00000, 0.00000, 0.94000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1408, 1104.56006, -343.70001, 73.60000,   0.00000, 0.00000, 0.94000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1110.47998, -341.39999, 78.35000,   0.00000, 0.00000, 268.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3802, 1113.58997, -331.63000, 75.38000,   0.00000, 0.00000, 172.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1369, 1024.19995, -316.00000, 73.60000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2833, 1114.17004, -334.94000, 73.58000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1759, 1113.32996, -336.75000, 73.54000,   0.00000, 0.00000, 267.42999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17036, 1013.40002, -337.63000, 72.90000,   0.00000, 0.00000, 89.99000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10150, 1088.37000, -331.07999, 73.39000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2100, 1104.77002, -262.69000, 72.87000,   0.00000, 0.00000, -25.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19314, 1035.75000, -346.85001, 76.18000,   90.00000, 90.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1481, 1144.81006, -211.39999, 55.86000,   0.00000, 0.00000, 304.91000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1810, 1142.29004, -214.97000, 55.18000,   0.00000, 0.00000, -180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1810, 1144.19995, -213.72000, 55.18000,   0.00000, 0.00000, -100.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1810, 1140.68005, -213.62000, 55.18000,   0.00000, 0.00000, 126.07000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(933, 1142.41003, -213.16000, 55.13000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3927, 1038.92004, -443.56000, 52.57000,   0.00000, 0.00000, 15.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1038.73999, -443.67001, 53.38000,   0.00000, 0.00000, 15.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3927, 1146.27002, -219.78000, 57.30000,   0.00000, 0.00000, 40.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1146.07996, -219.86000, 58.15000,   0.00000, 0.12000, -140.03000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3927, 1013.03998, -453.60999, 52.57000,   0.00000, 0.00000, 15.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1012.84003, -453.72000, 53.38000,   0.00000, 0.00000, 15.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2146, 1013.59998, -315.85999, 73.47000,   0.00000, 0.00000, 92.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1800, 1032.72998, -365.87000, 73.28000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3525, 1017.70001, -327.17999, 74.21000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2673, 1139.88000, -210.56000, 55.26000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2670, 1146.71997, -215.81000, 55.29000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1736, 1017.92999, -325.19000, 74.87000,   0.00000, 0.00000, 91.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19315, 1021.08002, -327.75000, 73.52000,   0.00000, 0.00000, 33.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 999.48999, -128.95000, 0.35000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 1009.75000, -129.39000, 0.35000,   0.00000, 0.00000, 85.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 989.31000, -128.94000, 2.57000,   25.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 979.71002, -128.94000, 4.70000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 977.70001, -136.17000, 4.66000,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3927, 979.81000, -130.85001, 7.49000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 979.59998, -130.92999, 8.34000,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(994, 1017.97192, -375.25201, 72.21960,   0.00000, -6.26000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(994, 1017.97418, -381.55280, 71.42540,   0.00000, -6.70000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(994, 1027.64172, -374.66599, 72.15260,   0.00000, -7.18000, 89.88000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(994, 1027.66626, -380.91391, 71.32090,   0.00000, -7.48000, 90.54000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(994, 1027.67737, -387.09561, 70.06610,   0.00000, -11.80000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3927, 1136.31006, -193.50000, 44.80000,   0.00000, 0.00000, 14.42000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1136.09998, -193.48000, 45.63000,   0.00000, 0.00000, 194.42000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3886, 1020.17999, -130.31000, 0.35000,   0.00000, 0.00000, 85.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3174, 1116.68005, -287.56000, 72.90000,   -4.00000, 0.00000, -25.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(10766, 1050.92493, -327.09927, 70.51957,   0.00000, 0.00000, -90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(791, 1157.42139, -361.72687, 56.34456,   0.00000, 0.00000, -239.57922, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1147.20947, -298.69019, 72.20730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1153.22473, -298.69019, 72.20730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.22119, -298.69019, 72.20730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -310.76410, 72.20730,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -322.72470, 72.20730,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -334.72891, 72.20730,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -346.70230, 72.20730,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -355.69632, 72.20730,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1138.15210, -355.59760, 72.20730,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1126.21753, -354.92725, 72.20730,   0.00000, 0.00000, -3.12000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.19507, -354.74127, 72.42719,   0.00000, 0.00000, -3.48000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.00000, -366.69901, 77.40000,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.19507, -354.74130, 77.08240,   0.00000, 0.00000, -3.48000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1150.09216, -355.59760, 72.20730,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1123.67664, -298.54999, 77.80000,   0.00000, 0.00000, 101.54000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1126.21753, -354.92719, 77.08240,   0.00000, 0.00000, -3.12000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1138.15210, -355.59760, 77.08240,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1150.09216, -355.59760, 77.08240,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -355.69629, 77.08240,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.15503, -346.72031, 77.08240,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -334.72891, 77.08240,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -322.72470, 77.08240,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.14636, -310.76410, 77.08240,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1162.22119, -298.69019, 77.08240,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1153.22473, -298.69019, 77.08240,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1147.20947, -298.69019, 77.08240,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(987, 1135.48560, -298.69019, 77.08238,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(694, 1161.15698, -298.02872, 62.15560,   0.00000, 0.00000, 95.10004, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(17324, 1131.83459, -340.80026, 72.60115,   0.00000, 0.00000, -180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(16770, 1146.26697, -326.22858, 74.36684,   0.00000, 0.00000, -89.58001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -308.27390, 73.60710,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -306.13400, 73.60710,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -303.69360, 73.60710,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -301.23029, 73.60710,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -298.97910, 73.60710,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1215, 1124.42676, -310.29855, 73.60708,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11445, 1152.15674, -307.72159, 72.83017,   0.00000, 0.00000, 120.58012, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(705, 1154.65161, -315.05899, 72.74644,   0.00000, 0.00000, -17.82001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3403, 1151.99707, -307.52856, 75.23817,   0.00000, 0.00000, -55.02003, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(832, 1158.61035, -307.24869, 74.06133,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(833, 1151.92651, -315.63150, 73.47649,   0.00000, 0.00000, 44.58003, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(844, 1157.21753, -319.43011, 73.57754,   -0.24000, -3.60000, -70.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(647, 1158.48645, -305.20245, 73.86030,   0.00000, 0.00000, -56.52003, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(647, 1156.83032, -301.63852, 73.86030,   0.00000, 0.00000, 87.60004, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(833, 1143.28662, -347.75137, 73.32142,   0.00000, 0.00000, -153.90009, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(672, 1146.95081, -349.29251, 73.59031,   0.00000, 0.00000, -5.70000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(660, 1154.13477, -347.92331, 72.78374,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(660, 1147.98279, -343.35089, 72.78374,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(11446, 1156.39368, -302.20285, 72.69294,   0.00000, 0.00000, 174.66017, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1463, 1136.56824, -315.48218, 73.35160,   0.00000, 43.32000, 85.98004, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1463, 1137.21008, -317.59445, 73.09712,   0.00000, 0.00000, -78.24001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2905, 1137.34497, -315.84079, 73.50523,   0.00000, 0.00000, -17.88001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2908, 1135.97729, -315.13101, 72.88986,   0.00000, 0.00000, -77.82004, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2907, 1136.67590, -316.76425, 73.85734,   -7.56000, -36.30000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3260, 1134.69861, -316.29385, 72.27910,   30.36001, 7.07999, 73.68000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1463, 1137.67212, -316.52798, 73.31767,   0.00000, 43.32000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1463, 1135.50610, -317.70813, 73.12519,   0.00000, 0.00000, 133.91983, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(831, 1136.39246, -316.68936, 72.96049,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(18691, 1136.52246, -316.78781, 70.51070,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2905, 1136.53979, -317.77689, 73.18829,   -52.07994, -7.32000, -201.53960, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(839, 1136.36401, -317.10965, 74.20282,   0.00000, 0.00000, 24.84002, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1368, 1136.86865, -312.14124, 73.53126,   0.00000, 0.00000, -3.30000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1368, 1141.42358, -316.98392, 73.53840,   0.00000, 0.00000, -90.90000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1368, 1135.99426, -321.97729, 73.52680,   0.00000, 0.00000, 171.05991, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2051, 1156.27087, -344.09503, 73.99009,   0.00000, 0.00000, 201.84018, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2051, 1146.83020, -348.40018, 73.99009,   -4.32000, 0.84000, 177.66049, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2051, 1144.44250, -347.86838, 73.29879,   -4.32000, 0.84000, 130.98070, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(831, 1140.95215, -345.39703, 73.70485,   0.00000, 0.00000, -52.02002, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2051, 1141.16650, -344.78601, 74.06978,   0.00000, 0.00000, 174.47990, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2051, 1140.36523, -347.41974, 76.17490,   0.00000, 0.00000, 174.47990, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3415, 1126.73706, -315.39999, 72.75799,   0.00000, 0.00000, 90.00001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2048, 1131.83032, -328.72424, 79.18000,   0.00000, 0.00000, 179.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3398, 1160.98376, -354.87366, 75.12000,   0.00000, 0.00000, 225.99001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1138.29993, -328.75360, 72.59251,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1137.31995, -328.75360, 75.32730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19386, 1134.28564, -328.89359, 74.58290,   0.00000, 0.00000, -90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1133.04834, -328.75360, 72.59250,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1129.32068, -328.75360, 72.59250,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1129.32068, -328.75360, 75.32730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1133.04834, -328.75360, 75.32730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2395, 1134.59399, -328.75339, 75.32730,   0.00000, 0.00000, 180.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19448, 1135.92395, -333.74719, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19448, 1135.92395, -343.35840, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19386, 1132.71704, -330.51901, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1132.71704, -333.71680, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19386, 1132.71704, -336.91461, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1132.71704, -340.12061, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19448, 1131.16272, -348.20105, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1131.11963, -341.62390, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1127.93066, -341.62390, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19448, 1126.32654, -345.03772, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1131.12451, -328.90289, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1127.91626, -328.90289, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1131.08191, -333.45581, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1127.88647, -333.45581, 74.58290,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19448, 1126.45667, -333.68060, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19356, 1126.45667, -340.08560, 74.58290,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19378, 1131.08862, -334.06799, 72.82370,   0.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19378, 1131.08862, -344.55121, 72.82370,   0.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19378, 1131.08862, -344.55121, 76.28532,   0.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19378, 1131.08862, -334.06799, 76.28530,   0.00000, 90.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19425, 1134.30566, -328.85809, 72.81600,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2063, 1126.85339, -331.95987, 73.73650,   0.00000, 0.00000, 90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(14782, 1128.94751, -329.37939, 73.89320,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1131.81775, -332.58005, 72.88200,   0.00000, 0.00000, 185.39998, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(964, 1130.40381, -332.71262, 72.88200,   0.00000, 0.00000, 182.58008, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2358, 1126.87122, -332.54453, 73.30170,   0.00000, 0.00000, 102.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(355, 1126.74634, -331.66122, 73.69410,   -84.24000, 58.02000, -26.51999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(348, 1126.89160, -332.43903, 74.13387,   -90.12004, -52.68000, -124.31999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(358, 1126.90820, -331.28146, 74.57169,   -83.27999, -244.49998, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(355, 1126.90857, -331.01511, 74.13877,   -84.24000, 58.02000, -53.27999, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2589, 1128.30042, -343.38696, 78.35415,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(3092, 1128.92615, -346.73364, 73.12876,   95.46004, 115.80003, -85.68002, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2907, 1130.56909, -345.58704, 74.80592,   -95.10001, 9.18001, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2905, 1130.96606, -345.51889, 72.94656,   0.00000, 0.00000, -19.74001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2908, 1130.64246, -345.52213, 75.35977,   -90.00000, 90.00000, -35.94003, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2590, 1130.59680, -345.67310, 77.48338,   0.00000, 0.00000, -64.97998, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2905, 1130.54138, -345.57178, 74.04482,   -90.00000, 0.00000, -91.92001, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2906, 1130.76099, -345.76846, 74.78140,   -112.01993, 60.48001, 22.98000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2906, 1130.41516, -345.48233, 74.78140,   -112.01993, 60.48001, 184.43982, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(19386, 1134.27527, -341.60611, 74.58290,   0.00000, 0.00000, -90.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2803, 1126.94470, -347.55759, 73.32620,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2803, 1128.16687, -347.54764, 73.32620,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(2805, 1127.29956, -346.58704, 73.01507,   87.96009, 76.62003, 0.00000, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1415, 1134.68555, -347.33585, 72.99973,   0.00000, 0.00000, -178.61977, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(1439, 1132.74731, -347.56427, 72.99944,   0.00000, 0.00000, 178.26006, .worldid = 0, .streamdistance = 150);
CreateDynamicObject(12986, 1130.01062, -336.89389, 74.33800,   0.00000, 0.00000, 0.00000, .worldid = 0, .streamdistance = 150);


	//Hilltop Barn Interiors 9-22-2012
	CreateDynamicObject(14607, -569.09, -1142.38, 488.56,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14675, -583.00, -1120.90, 493.80,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14674, -581.14, -1120.36, 487.96,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(617, -567.54, -1125.05, 489.52,   0.00, 0.00, 342.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14602, -79.10, 504.10, 1027.68,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(11455, -102.07, 504.05, 1027.19,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1241, -102.00, 502.36, 1026.91,   0.00, 0.00, 284.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1241, -101.98, 505.71, 1026.91,   0.00, 0.00, 84.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14736, -87.31, 508.20, 1023.42,   0.00, 0.00, 271.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1846, -102.88, 498.68, 1025.36,   90.00, 90.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1846, -102.99, 510.37, 1025.36,   90.00, 90.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(3962, -94.15, 488.59, 1025.35,   0.00, 0.00, 267.99, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1892, -89.58, 519.42, 1022.31,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1622, -87.53, 504.99, 1026.03,   0.00, 330.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1808, -90.46, 488.76, 1022.31,   0.00, 0.00, 176.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.55, 504.09, 1023.92,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(3383, -96.99, 535.54, 1022.26,   0.00, 0.00, 270.92, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(11455, -86.76, 503.78, 1027.19,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2232, -102.17, 508.44, 1025.37,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2232, -102.25, 512.33, 1025.37,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2232, -102.20, 500.73, 1025.37,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2232, -102.16, 496.57, 1025.37,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2007, -101.59, 506.66, 1022.31,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2007, -101.60, 502.30, 1022.31,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(912, -101.73, 504.25, 1022.88,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(912, -101.73, 504.25, 1023.96,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.60, 504.36, 1023.92,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1023.92,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1024.28,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1023.56,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.64, 504.35, 1023.56,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.61, 503.81, 1023.56,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.61, 503.81, 1023.19,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.65, 504.53, 1023.19,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.65, 504.53, 1022.83,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -101.63, 504.17, 1022.83,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1671, -96.47, 504.02, 1022.78,   0.00, 0.00, 92.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2852, -94.04, 491.25, 1022.81,   0.00, 0.00, 284.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1502, -91.34, 529.44, 1022.30,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1502, -91.18, 521.43, 1022.30,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2686, -74.22, 535.10, 1024.14,   0.00, 0.00, 88.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2773, -96.06, 518.59, 1022.83,   0.00, 0.00, 2.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2773, -95.98, 516.23, 1022.83,   0.00, 0.00, 2.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2773, -95.92, 513.88, 1022.83,   0.00, 0.00, 2.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1998, -93.02, 523.73, 1022.31,   0.00, 0.00, 91.81, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2197, -93.01, 525.78, 1022.30,   0.00, 0.00, 269.17, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1663, -92.62, 524.86, 1022.81,   0.00, 0.00, 318.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2008, -95.24, 531.23, 1022.30,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2010, -97.00, 528.60, 1022.37,   0.00, 0.00, 42.06, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2010, -87.91, 533.04, 1022.55,   0.00, 0.00, 46.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14532, -92.08, 520.87, 1023.27,   0.00, 0.00, 58.97, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1714, -96.76, 530.91, 1022.42,   0.00, 0.00, 86.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1417, -97.07, 527.48, 1022.66,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.00, 536.50, 1023.44,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2266, -89.52, 532.91, 1025.40,   0.00, 0.00, 179.99, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2269, -97.03, 527.52, 1024.89,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1523, -89.82, 519.78, 1022.31,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(949, -96.78, 525.54, 1023.25,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(949, -92.07, 526.65, 1022.98,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2319, -90.65, 525.65, 1022.36,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2284, -94.63, 531.66, 1024.64,   0.00, 0.00, 1.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2855, -90.62, 526.08, 1022.86,   0.00, 0.00, 84.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2285, -90.71, 526.90, 1024.95,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2281, -94.45, 520.66, 1024.15,   0.00, 0.00, 179.99, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(5399, -79.74, 500.89, 1027.42,   0.00, 0.00, 180.03, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(5399, -109.26, 486.03, 1027.42,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(5399, -79.75, 518.34, 1027.42,   0.00, 0.00, -180.03, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(5399, -109.28, 503.76, 1027.42,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -95.03, 531.07, 1023.23,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2010, -88.24, 537.43, 1022.55,   0.00, 0.00, 46.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 535.36, 1023.88,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 535.35, 1027.37,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19401, -93.21, 537.19, 1024.02,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19401, -93.21, 537.19, 1027.49,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1649, -93.22, 536.15, 1023.63,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1768, -92.11, 537.97, 1022.32,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1768, -87.83, 536.17, 1022.32,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19175, -87.17, 525.86, 1025.49,   0.00, 0.00, -89.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19173, -94.23, 526.34, 1024.75,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2146, -94.99, 535.39, 1023.04,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2613, -96.64, 536.29, 1023.27,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2613, -96.92, 536.43, 1023.29,   0.00, 0.00, -0.06, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2613, -96.92, 536.12, 1023.31,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2146, -91.65, 518.93, 1022.78,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2146, -94.40, 526.80, 1022.78,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -93.01, 523.61, 1023.23,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.34, 536.30, 1023.44,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.36, 536.50, 1023.42,   0.00, 0.00, -0.06, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.35, 536.73, 1023.42,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.19, 536.62, 1023.44,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2709, -97.18, 536.40, 1023.44,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(341, -97.05, 534.77, 1023.55,   0.00, 25.00, -88.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2146, -94.57, 520.66, 1022.78,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2146, -94.58, 518.93, 1022.78,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -96.78, 513.10, 1022.91,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -96.99, 518.99, 1022.91,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -96.94, 517.44, 1022.91,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -96.90, 515.87, 1022.91,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -96.88, 514.51, 1022.91,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -90.08, 502.89, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -90.24, 505.32, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -90.19, 506.53, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -92.41, 506.51, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -92.42, 505.31, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -92.50, 502.99, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -92.55, 501.67, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2777, -90.12, 501.69, 1022.71,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2674, -88.36, 511.48, 1022.34,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2674, -89.58, 525.01, 1022.32,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2674, -91.23, 505.83, 1022.32,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -90.02, 512.16, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -91.15, 502.41, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -93.55, 506.04, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -96.14, 493.12, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -88.27, 495.27, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -88.95, 526.95, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -93.06, 521.95, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -95.72, 529.23, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -90.29, 534.90, 1022.41,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2674, -89.39, 513.62, 1022.34,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -102.05, 492.66, 1025.24,   0.00, 0.00, 90.21, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -102.08, 516.20, 1025.24,   0.00, 0.00, 90.21, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2614, -87.01, 493.97, 1025.10,   0.00, 0.00, -90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2614, -86.99, 513.74, 1025.32,   0.00, 0.00, 270.30, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19377, -98.38, 536.99, 1022.48,   0.00, 90.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 533.82, 1020.80,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1523, -90.07, 532.26, 1022.31,   0.00, 0.00, 1.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18808, -24.54, 500.80, 973.23,   0.00, 110.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19376, -47.93, 505.43, 981.57,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19376, -47.97, 495.81, 981.57,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19376, -1.48, 498.09, 964.66,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19376, -1.47, 507.72, 964.66,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1508, -2.00, 500.74, 963.19,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1508, -48.35, 500.86, 980.03,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(12814, -25.74, 499.11, 970.15,   20.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -47.21, 500.89, 983.16,   20.00, 0.00, 89.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -1.13, 500.80, 965.92,   -20.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -43.10, 499.55, 976.59,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -45.20, 501.97, 977.35,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -23.73, 500.24, 969.52,   0.00, 20.00, 359.70, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -11.00, 502.03, 964.94,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -38.65, 500.18, 974.96,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -33.75, 502.38, 973.18,   0.00, 20.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -95.64, 536.62, 1022.57,   0.00, 0.00, 315.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -89.17, 536.69, 1022.31,   0.00, 0.00, 225.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2906, -96.11, 537.71, 1022.67,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2908, -95.56, 536.47, 1022.68,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2905, -96.72, 537.89, 1022.68,   0.00, 0.00, 75.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(16150, -108.36, 582.06, 1022.67,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18028, -82.13, 574.31, 1022.66,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19456, -73.10, 573.28, 1025.05,   0.00, 180.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(13360, -78.24, 580.26, 1021.55,   0.00, 0.00, 90.30, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -78.23, 580.22, 1023.74,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19448, -109.44, 578.06, 1024.43,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -108.38, 587.89, 1024.53,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19168, -106.05, 587.90, 1024.53,   90.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19169, -110.56, 587.90, 1024.53,   90.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1736, -105.00, 583.07, 1024.79,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1846, -108.16, 579.14, 1024.40,   90.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2229, -110.16, 577.75, 1023.62,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2229, -106.74, 577.75, 1023.62,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1816, -108.65, 578.11, 1022.67,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1718, -108.04, 578.69, 1023.24,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1756, -109.07, 580.82, 1022.66,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1767, -111.35, 579.49, 1022.59,   0.00, 0.00, 55.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2173, -108.01, 585.61, 1022.66,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14455, -111.90, 588.61, 1024.10,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14455, -104.64, 584.27, 1024.10,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(3265, -104.60, 580.26, 1022.28,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1671, -108.27, 586.92, 1023.10,   0.00, 0.00, -11.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1520, -108.27, 585.62, 1023.50,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1665, -108.53, 585.53, 1023.48,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2587, -110.93, 578.26, 1024.35,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2588, -105.59, 578.20, 1024.22,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1762, -107.11, 584.35, 1022.71,   0.00, 0.00, -142.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1762, -109.03, 583.61, 1022.71,   0.00, 0.00, 153.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -109.62, 582.73, 1022.79,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19448, -112.11, 582.97, 1024.43,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(13360, -112.00, 582.29, 1023.72,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -106.36, 586.11, 1022.77,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1829, -110.43, 587.27, 1023.11,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1550, -106.81, 587.36, 1023.27,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1550, -106.32, 587.29, 1023.27,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2207, -72.94, 566.81, 1020.68,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19314, -73.84, 567.27, 1021.42,   90.00, 90.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -74.13, 564.66, 1021.46,   0.00, 0.00, 171.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -75.71, 564.87, 1020.70,   0.00, 0.00, 54.78, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19456, -73.10, 573.28, 1021.59,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -71.26, 565.10, 1020.70,   0.00, 0.00, 142.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -69.65, 566.61, 1021.62,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -71.39, 571.52, 1020.70,   0.00, 0.00, 222.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -75.72, 571.43, 1020.70,   0.00, 0.00, 309.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -73.47, 572.49, 1020.70,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -76.88, 568.59, 1020.70,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -72.42, 568.47, 1021.46,   0.00, 0.00, 338.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1369, -75.50, 568.40, 1021.46,   0.00, 0.00, 33.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2906, -76.91, 572.43, 1020.74,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2905, -77.26, 571.91, 1020.77,   0.00, 0.00, -105.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2908, -76.53, 568.48, 1020.74,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2908, -70.69, 569.14, 1020.74,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2907, -69.95, 569.58, 1020.90,   -33.00, 18.00, 68.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2907, -70.16, 572.33, 1020.76,   0.00, 0.00, 47.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2906, -71.02, 572.51, 1020.77,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(341, -73.24, 566.20, 1021.60,   0.00, 18.00, 98.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2908, -76.46, 563.83, 1020.74,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2906, -75.99, 563.85, 1020.72,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2905, -77.08, 563.78, 1020.74,   0.00, 0.00, 40.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1498, -74.16, 573.20, 1020.67,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2908, -70.26, 564.96, 1020.80,   0.00, 0.00, 62.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2907, -70.42, 563.86, 1020.75,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2048, -73.39, 573.18, 1024.18,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2614, -70.92, 573.14, 1022.52,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2614, -75.90, 573.14, 1022.52,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1736, -75.89, 572.89, 1024.02,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1736, -70.91, 572.83, 1024.02,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1439, -69.93, 567.13, 1020.76,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(3092, -70.02, 566.77, 1021.44,   40.00, 25.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -70.31, 569.21, 1020.70,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(18067, -69.94, 567.02, 1021.62,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(3092, -70.24, 567.09, 1021.48,   40.00, 25.00, 113.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19448, -104.58, 582.91, 1024.43,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(14455, -104.62, 577.41, 1024.10,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1520, -74.19, 566.63, 1021.50,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2673, -72.08, 569.50, 1020.79,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2670, -75.17, 569.24, 1020.79,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(348, -109.04, 585.75, 1023.48,   95.00, 9.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19448, -109.05, 588.00, 1024.05,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(19174, -112.02, 579.92, 1024.76,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2803, -72.55, 563.54, 1021.19,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2805, -75.10, 563.33, 1021.14,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1764, -87.33, 514.62, 1022.30,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1764, -87.37, 494.39, 1022.30,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1764, -94.73, 493.22, 1022.30,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1764, -92.86, 489.21, 1022.30,   0.00, 0.00, 180.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1765, -96.18, 490.68, 1022.31,   0.00, 0.00, 90.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1765, -91.41, 491.77, 1022.31,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2319, -94.60, 491.35, 1022.32,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1755, -90.77, 528.09, 1022.30,   0.00, 0.00, 62.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1755, -90.22, 523.82, 1022.28,   0.00, 0.00, 120.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1759, -93.82, 531.85, 1022.26,   0.00, 0.00, -47.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1759, -93.20, 530.16, 1022.26,   0.00, 0.00, -127.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1769, -95.84, 524.24, 1022.26,   0.00, 0.00, 84.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1769, -95.48, 522.21, 1022.26,   0.00, 0.00, 127.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(5399, -86.71, 481.35, 1027.42,   0.00, 0.00, 90.03, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2878, -86.94, 504.85, 1023.46,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1520, -97.10, 527.44, 1023.76,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(1520, -90.67, 527.05, 1022.92,   0.00, 0.00, 0.00, .worldid = 123564, .streamdistance = 300);
	CreateDynamicObject(2894, -95.03, 504.05, 1023.11,   0.00, 0.00, 270.00, .worldid = 123564, .streamdistance = 300);
	//Hilltop Interior
	CreateDynamicObject(14607, -569.09, -1142.38, 488.56,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14675, -583.00, -1120.90, 493.80,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14674, -581.14, -1120.36, 487.96,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(617, -567.54, -1125.05, 489.52,   0.00, 0.00, 342.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14602, -79.10, 504.10, 1027.68,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(11455, -102.07, 504.05, 1027.19,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1241, -102.00, 502.36, 1026.91,   0.00, 0.00, 284.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1241, -101.98, 505.71, 1026.91,   0.00, 0.00, 84.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14736, -87.31, 508.20, 1023.42,   0.00, 0.00, 271.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1846, -102.88, 498.68, 1025.36,   90.00, 90.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1846, -102.99, 510.37, 1025.36,   90.00, 90.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(3962, -94.15, 488.59, 1025.35,   0.00, 0.00, 267.99, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1892, -89.58, 519.42, 1022.31,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1622, -87.53, 504.99, 1026.03,   0.00, 330.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1808, -90.46, 488.76, 1022.31,   0.00, 0.00, 176.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.55, 504.09, 1023.92,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(3383, -96.99, 535.54, 1022.26,   0.00, 0.00, 270.92, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(11455, -86.76, 503.78, 1027.19,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2232, -102.17, 508.44, 1025.37,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2232, -102.25, 512.33, 1025.37,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2232, -102.20, 500.73, 1025.37,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2232, -102.16, 496.57, 1025.37,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2007, -101.59, 506.66, 1022.31,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2007, -101.60, 502.30, 1022.31,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(912, -101.73, 504.25, 1022.88,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(912, -101.73, 504.25, 1023.96,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.60, 504.36, 1023.92,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1023.92,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1024.28,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.66, 504.71, 1023.56,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.64, 504.35, 1023.56,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.61, 503.81, 1023.56,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.61, 503.81, 1023.19,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.65, 504.53, 1023.19,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.65, 504.53, 1022.83,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -101.63, 504.17, 1022.83,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1671, -96.47, 504.02, 1022.78,   0.00, 0.00, 92.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2852, -94.04, 491.25, 1022.81,   0.00, 0.00, 284.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1502, -91.34, 529.44, 1022.30,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1502, -91.18, 521.43, 1022.30,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2686, -74.22, 535.10, 1024.14,   0.00, 0.00, 88.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2773, -96.06, 518.59, 1022.83,   0.00, 0.00, 2.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2773, -95.98, 516.23, 1022.83,   0.00, 0.00, 2.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2773, -95.92, 513.88, 1022.83,   0.00, 0.00, 2.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1998, -93.02, 523.73, 1022.31,   0.00, 0.00, 91.81, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2197, -93.01, 525.78, 1022.30,   0.00, 0.00, 269.17, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1663, -92.62, 524.86, 1022.81,   0.00, 0.00, 318.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2008, -95.24, 531.23, 1022.30,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2010, -97.00, 528.60, 1022.37,   0.00, 0.00, 42.06, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2010, -87.91, 533.04, 1022.55,   0.00, 0.00, 46.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14532, -92.08, 520.87, 1023.27,   0.00, 0.00, 58.97, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1714, -96.76, 530.91, 1022.42,   0.00, 0.00, 86.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1417, -97.07, 527.48, 1022.66,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.00, 536.50, 1023.44,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2266, -89.52, 532.91, 1025.40,   0.00, 0.00, 179.99, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2269, -97.03, 527.52, 1024.89,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1523, -89.82, 519.78, 1022.31,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(949, -96.78, 525.54, 1023.25,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(949, -92.07, 526.65, 1022.98,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2319, -90.65, 525.65, 1022.36,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2284, -94.63, 531.66, 1024.64,   0.00, 0.00, 1.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2855, -90.62, 526.08, 1022.86,   0.00, 0.00, 84.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2285, -90.71, 526.90, 1024.95,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2281, -94.45, 520.66, 1024.15,   0.00, 0.00, 179.99, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(5399, -79.74, 500.89, 1027.42,   0.00, 0.00, 180.03, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(5399, -109.26, 486.03, 1027.42,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(5399, -79.75, 518.34, 1027.42,   0.00, 0.00, -180.03, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(5399, -109.28, 503.76, 1027.42,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -95.03, 531.07, 1023.23,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2010, -88.24, 537.43, 1022.55,   0.00, 0.00, 46.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 535.36, 1023.88,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 535.35, 1027.37,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19401, -93.21, 537.19, 1024.02,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19401, -93.21, 537.19, 1027.49,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1649, -93.22, 536.15, 1023.63,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1768, -92.11, 537.97, 1022.32,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1768, -87.83, 536.17, 1022.32,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19175, -87.17, 525.86, 1025.49,   0.00, 0.00, -89.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19173, -94.23, 526.34, 1024.75,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2146, -94.99, 535.39, 1023.04,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2613, -96.64, 536.29, 1023.27,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2613, -96.92, 536.43, 1023.29,   0.00, 0.00, -0.06, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2613, -96.92, 536.12, 1023.31,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2146, -91.65, 518.93, 1022.78,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2146, -94.40, 526.80, 1022.78,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -93.01, 523.61, 1023.23,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.34, 536.30, 1023.44,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.36, 536.50, 1023.42,   0.00, 0.00, -0.06, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.35, 536.73, 1023.42,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.19, 536.62, 1023.44,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2709, -97.18, 536.40, 1023.44,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(341, -97.05, 534.77, 1023.55,   0.00, 25.00, -88.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2146, -94.57, 520.66, 1022.78,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2146, -94.58, 518.93, 1022.78,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -96.78, 513.10, 1022.91,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -96.99, 518.99, 1022.91,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -96.94, 517.44, 1022.91,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -96.90, 515.87, 1022.91,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -96.88, 514.51, 1022.91,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -90.08, 502.89, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -90.24, 505.32, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -90.19, 506.53, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -92.41, 506.51, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -92.42, 505.31, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -92.50, 502.99, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -92.55, 501.67, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2777, -90.12, 501.69, 1022.71,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2674, -88.36, 511.48, 1022.34,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2674, -89.58, 525.01, 1022.32,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2674, -91.23, 505.83, 1022.32,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -90.02, 512.16, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -91.15, 502.41, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -93.55, 506.04, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -96.14, 493.12, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -88.27, 495.27, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -88.95, 526.95, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -93.06, 521.95, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -95.72, 529.23, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -90.29, 534.90, 1022.41,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2674, -89.39, 513.62, 1022.34,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -102.05, 492.66, 1025.24,   0.00, 0.00, 90.21, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -102.08, 516.20, 1025.24,   0.00, 0.00, 90.21, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2614, -87.01, 493.97, 1025.10,   0.00, 0.00, -90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2614, -86.99, 513.74, 1025.32,   0.00, 0.00, 270.30, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19377, -98.38, 536.99, 1022.48,   0.00, 90.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19401, -93.20, 533.82, 1020.80,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1523, -90.07, 532.26, 1022.31,   0.00, 0.00, 1.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18808, -24.54, 500.80, 973.23,   0.00, 110.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19376, -47.93, 505.43, 981.57,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19376, -47.97, 495.81, 981.57,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19376, -1.48, 498.09, 964.66,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19376, -1.47, 507.72, 964.66,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1508, -2.00, 500.74, 963.19,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1508, -48.35, 500.86, 980.03,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(12814, -25.74, 499.11, 970.15,   20.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -47.21, 500.89, 983.16,   20.00, 0.00, 89.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -1.13, 500.80, 965.92,   -20.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -43.10, 499.55, 976.59,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -45.20, 501.97, 977.35,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -23.73, 500.24, 969.52,   0.00, 20.00, 359.70, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -11.00, 502.03, 964.94,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -38.65, 500.18, 974.96,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -33.75, 502.38, 973.18,   0.00, 20.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -95.64, 536.62, 1022.57,   0.00, 0.00, 315.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -89.17, 536.69, 1022.31,   0.00, 0.00, 225.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2906, -96.11, 537.71, 1022.67,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2908, -95.56, 536.47, 1022.68,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2905, -96.72, 537.89, 1022.68,   0.00, 0.00, 75.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(16150, -108.36, 582.06, 1022.67,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18028, -82.13, 574.31, 1022.66,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19456, -73.10, 573.28, 1025.05,   0.00, 180.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(13360, -78.24, 580.26, 1021.55,   0.00, 0.00, 90.30, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -78.23, 580.22, 1023.74,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19448, -109.44, 578.06, 1024.43,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -108.38, 587.89, 1024.53,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19168, -106.05, 587.90, 1024.53,   90.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19169, -110.56, 587.90, 1024.53,   90.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1736, -105.00, 583.07, 1024.79,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1846, -108.16, 579.14, 1024.40,   90.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2229, -110.16, 577.75, 1023.62,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2229, -106.74, 577.75, 1023.62,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1816, -108.65, 578.11, 1022.67,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1718, -108.04, 578.69, 1023.24,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1756, -109.07, 580.82, 1022.66,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1767, -111.35, 579.49, 1022.59,   0.00, 0.00, 55.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2173, -108.01, 585.61, 1022.66,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14455, -111.90, 588.61, 1024.10,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14455, -104.64, 584.27, 1024.10,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(3265, -104.60, 580.26, 1022.28,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1671, -108.27, 586.92, 1023.10,   0.00, 0.00, -11.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1520, -108.27, 585.62, 1023.50,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1665, -108.53, 585.53, 1023.48,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2587, -110.93, 578.26, 1024.35,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2588, -105.59, 578.20, 1024.22,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1762, -107.11, 584.35, 1022.71,   0.00, 0.00, -142.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1762, -109.03, 583.61, 1022.71,   0.00, 0.00, 153.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -109.62, 582.73, 1022.79,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19448, -112.11, 582.97, 1024.43,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(13360, -112.00, 582.29, 1023.72,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -106.36, 586.11, 1022.77,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1829, -110.43, 587.27, 1023.11,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1550, -106.81, 587.36, 1023.27,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1550, -106.32, 587.29, 1023.27,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2207, -72.94, 566.81, 1020.68,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19314, -73.84, 567.27, 1021.42,   90.00, 90.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -74.13, 564.66, 1021.46,   0.00, 0.00, 171.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -75.71, 564.87, 1020.70,   0.00, 0.00, 54.78, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19456, -73.10, 573.28, 1021.59,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -71.26, 565.10, 1020.70,   0.00, 0.00, 142.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -69.65, 566.61, 1021.62,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -71.39, 571.52, 1020.70,   0.00, 0.00, 222.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -75.72, 571.43, 1020.70,   0.00, 0.00, 309.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -73.47, 572.49, 1020.70,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -76.88, 568.59, 1020.70,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -72.42, 568.47, 1021.46,   0.00, 0.00, 338.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1369, -75.50, 568.40, 1021.46,   0.00, 0.00, 33.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2906, -76.91, 572.43, 1020.74,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2905, -77.26, 571.91, 1020.77,   0.00, 0.00, -105.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2908, -76.53, 568.48, 1020.74,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2908, -70.69, 569.14, 1020.74,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2907, -69.95, 569.58, 1020.90,   -33.00, 18.00, 68.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2907, -70.16, 572.33, 1020.76,   0.00, 0.00, 47.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2906, -71.02, 572.51, 1020.77,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(341, -73.24, 566.20, 1021.60,   0.00, 18.00, 98.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2908, -76.46, 563.83, 1020.74,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2906, -75.99, 563.85, 1020.72,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2905, -77.08, 563.78, 1020.74,   0.00, 0.00, 40.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1498, -74.16, 573.20, 1020.67,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2908, -70.26, 564.96, 1020.80,   0.00, 0.00, 62.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2907, -70.42, 563.86, 1020.75,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2048, -73.39, 573.18, 1024.18,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2614, -70.92, 573.14, 1022.52,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2614, -75.90, 573.14, 1022.52,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1736, -75.89, 572.89, 1024.02,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1736, -70.91, 572.83, 1024.02,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1439, -69.93, 567.13, 1020.76,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(3092, -70.02, 566.77, 1021.44,   40.00, 25.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -70.31, 569.21, 1020.70,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(18067, -69.94, 567.02, 1021.62,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(3092, -70.24, 567.09, 1021.48,   40.00, 25.00, 113.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19448, -104.58, 582.91, 1024.43,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(14455, -104.62, 577.41, 1024.10,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1520, -74.19, 566.63, 1021.50,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2673, -72.08, 569.50, 1020.79,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2670, -75.17, 569.24, 1020.79,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(348, -109.04, 585.75, 1023.48,   95.00, 9.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19448, -109.05, 588.00, 1024.05,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(19174, -112.02, 579.92, 1024.76,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2803, -72.55, 563.54, 1021.19,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2805, -75.10, 563.33, 1021.14,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1764, -87.33, 514.62, 1022.30,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1764, -87.37, 494.39, 1022.30,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1764, -94.73, 493.22, 1022.30,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1764, -92.86, 489.21, 1022.30,   0.00, 0.00, 180.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1765, -96.18, 490.68, 1022.31,   0.00, 0.00, 90.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1765, -91.41, 491.77, 1022.31,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2319, -94.60, 491.35, 1022.32,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1755, -90.77, 528.09, 1022.30,   0.00, 0.00, 62.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1755, -90.22, 523.82, 1022.28,   0.00, 0.00, 120.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1759, -93.82, 531.85, 1022.26,   0.00, 0.00, -47.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1759, -93.20, 530.16, 1022.26,   0.00, 0.00, -127.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1769, -95.84, 524.24, 1022.26,   0.00, 0.00, 84.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1769, -95.48, 522.21, 1022.26,   0.00, 0.00, 127.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(5399, -86.71, 481.35, 1027.42,   0.00, 0.00, 90.03, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2878, -86.94, 504.85, 1023.46,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1520, -97.10, 527.44, 1023.76,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(1520, -90.67, 527.05, 1022.92,   0.00, 0.00, 0.00, .worldid = 1, .streamdistance = 300);
	CreateDynamicObject(2894, -95.03, 504.05, 1023.11,   0.00, 0.00, 270.00, .worldid = 1, .streamdistance = 300);




	//Varrios Los Aztecas
		//Exterior
	CreateDynamicObject(3819,1815.2998000,-2039.9004000,13.6000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx)(1)
	CreateDynamicObject(3819,1815.2998000,-2023.5996100,13.6000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx)(2)
	CreateDynamicObject(946,1822.7998000,-2046.0000000,14.7000000,0.0000000,0.0000000,0.0000000); //object(bskball_lax)(1)
	CreateDynamicObject(946,1822.6999500,-2018.6999500,14.7000000,0.0000000,0.0000000,179.9950000); //object(bskball_lax)(3)
	CreateDynamicObject(17513,1821.0000000,-2029.7998000,4.5100000,0.2400000,0.0000000,0.0000000); //object(lae2_ground04)(2)
	CreateDynamicObject(4837,1823.0078100,-2087.1718700,12.5000000,0.0000000,0.0000000,0.0000000); //object(lapedhusrea_las)(3)
	CreateDynamicObject(4808,1892.3359400,-2037.6484400,12.5000000,0.0000000,0.0000000,0.0000000); //object(laroadss_30_las)(3)
	CreateDynamicObject(1946,1821.0000000,-2041.7998000,12.6600000,0.0000000,0.0000000,0.0000000); //object(baskt_ball_hi) (1)

	CreateDynamicObject(1766,1925.9000000,-2070.3000000,12.6000000,0.0000000,0.0000000,125.00); //object(med_couch_1)(2)
	CreateDynamicObject(1766,1929.6000000,-2070.1001000,12.5000000,0.0000000,0.0000000,200.00); //object(med_couch_1)(3)
	CreateDynamicObject(1362,1927.1999500,-2068.8000500,13.1000000,0.0000000,0.0000000,0.0000); //object(cj_firebin)(1)
	CreateDynamicObject(3525,1927.2000000,-2068.8000000,12.3000000,0.0000000,347.9970000,188.0000000); //object(exbrtorch01)(1)
	CreateDynamicObject(853,1934.3474000,-2066.5996000,12.9000000,0.0000000,0.0000000,0.0000); //object(cj_urb_rub_5)(1)
	CreateDynamicObject(3008,1927.4000000,-2068.3999000,13.5000000,0.0000000,222.0000000,42.0); //object(chopcop_armr)(1)
	CreateDynamicObject(1358,1923.5000000,-2076.1001000,13.8000000,0.0000000,0.0000000,0.0000); //object(cj_skip_rubbish) (1)
	CreateDynamicObject(1531,1913.1000000,-2066.3999000,14.0000000,0.0000000,0.0000000,180.00); //object(tag_azteca) (1)

	CreateDynamicObject(1728,1848.1000000,-2070.2000000,14.0000000,0.0000000,0.0000000,182.0000000); //object(mrk_seating3) (1)
	CreateDynamicObject(1820,1846.5000000,-2069.1001000,14.0000000,0.0000000,0.0000000,0.0000000); //object(coffee_low_4) (1)
	CreateDynamicObject(1670,1847.0000000,-2068.6001000,14.5000000,0.0000000,0.0000000,0.0000000); //object(propcollecttable) (1)
	CreateDynamicObject(1531,1845.3000000,-2073.0000000,15.9000000,0.0000000,0.0000000,0.0000000); //object(tag_azteca) (1)
		//Interior
	CreateDynamicObject(14700,168.5000000,1344.9004000,971.70,0.0000000,0.0000000,0.0000000); //object(int2smsf01_int01) (2)
	CreateDynamicObject(1491,169.2002000,1350.2998000,970.200,0.0000000,0.0000000,0.0000000); //object(gen_doorint01) (2)
	CreateDynamicObject(2184,172.3000000,1353.9000000,970.200,0.0000000,0.0000000,272.0000000); //object(med_office6_desk_2) (1)
	CreateDynamicObject(1562,174.4003900,1352.7998000,970.900,0.0000000,0.0000000,267.9950000); //object(ab_jetseat) (1)
	CreateDynamicObject(1670,173.0996100,1352.2002000,971.000,0.0000000,0.0000000,287.9960000); //object(propcollecttable) (1)
	CreateDynamicObject(1829,174.2002000,1355.0000000,970.700,0.0000000,0.0000000,270.0000000); //object(man_safenew) (1)
	CreateDynamicObject(1531,174.8999900,1353.5000000,972.099,0.0000000,0.0000000,0.0000000); //object(tag_azteca) (1)
	CreateDynamicObject(3111,172.5000000,1353.2000000,971.000,0.0000000,0.0000000,0.0000000); //object(st_arch_plan) (1)
	CreateDynamicObject(2032,168.5000000,1354.9004000,970.200,0.0000000,0.0000000,0.0000000); //object(med_dinning_2) (1)
	CreateDynamicObject(330,168.5634800,1355.4482000,971.2049,0.0000000,0.0000000,0.0000000); //object(1)
	CreateDynamicObject(2710,172.5000000,1351.5996000,971.099,0.0000000,0.0000000,283.9970000); //object(watch_pickup) (1)
	CreateDynamicObject(2035,169.2998000,1355.2002000,971.000,0.0000000,0.0000000,0.0000000); //object(cj_m16) (1)
	CreateDynamicObject(2036,169.4003900,1354.7998000,971.000,0.0000000,0.0000000,0.0000000); //object(cj_psg1) (1)
	CreateDynamicObject(2044,168.5996100,1355.2002000,971.000,0.0000000,0.0000000,0.0000000); //object(cj_mp5k) (1)
	CreateDynamicObject(1650,168.3000000,1355.2000000,971.299,0.0000000,0.0000000,0.0000000); //object(petrolcanm) (1)
	CreateDynamicObject(2045,168.7002000,1354.5996000,971.099,0.0000000,0.0000000,0.0000000); //object(cj_bbat_nails) (1)
	CreateDynamicObject(2891,168.4003900,1354.7002000,971.000,0.0000000,0.0000000,0.0000000); //object(kmb_packet) (1)
	CreateDynamicObject(2952,171.3000000,1348.5000000,970.200,0.0000000,0.0000000,0.0000000); //object(kmb_gimpdoor) (1)
	CreateDynamicObject(2519,173.7000000,1348.8000500,970.200,0.0000000,0.0000000,0.0000000); //object(cj_bath2) (1)
	CreateDynamicObject(2908,173.3999900,1348.2000000,970.299,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (1)
	CreateDynamicObject(2907,173.3999900,1348.7000000,970.900,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (1)
	CreateDynamicObject(2906,173.8999900,1348.6000000,970.900,0.0000000,0.0000000,284.0000000); //object(kmb_deadarm) (1)
	CreateDynamicObject(2906,173.0000000,1348.5000000,970.299,0.0000000,0.0000000,94.0000000); //object(kmb_deadarm) (2)
	CreateDynamicObject(2905,174.3999900,1348.5000000,970.900,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (1)
	CreateDynamicObject(2905,174.8999900,1348.5000000,970.900,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (2)
	CreateDynamicObject(341,173.7000000,1348.4000000,971.0000,0.0000000,18.0000000,350.0000000); //object(2)
	CreateDynamicObject(16151,164.0996100,1352.7998000,970.20,0.0000000,0.0000000,90.0000000); //object(ufo_bar) (1)
	CreateDynamicObject(2967,165.1000100,1351.6000000,970.799,0.0000000,0.0000000,0.0000000); //object(mobile1993a) (1)
	CreateDynamicObject(2967,172.3999900,1353.4000000,971.000,0.0000000,0.0000000,0.0000000); //object(mobile1993a) (2)
	CreateDynamicObject(2615,169.0000000,1355.4000000,972.099,0.0000000,0.0000000,0.0000000); //object(police_nb3) (1)
	CreateDynamicObject(2051,169.8999900,1355.4000000,972.099,0.0000000,0.0000000,0.0000000); //object(cj_target4) (1)
	CreateDynamicObject(1077,159.8999900,1349.9000000,970.700,0.0000000,347.9970000,0.0000000); //object(wheel_lr1) (1)
	CreateDynamicObject(1077,159.8000000,1348.9000000,970.700,0.0000000,0.0000000,0.0000000); //object(wheel_lr1) (2)
	CreateDynamicObject(1077,159.8999900,1347.9000000,970.700,0.0000000,0.0000000,0.0000000); //object(wheel_lr1) (3)
	CreateDynamicObject(1077,159.7998000,1346.9004000,970.700,0.0000000,0.0000000,0.0000000); //object(wheel_lr1) (4)
	CreateDynamicObject(1531,159.7998000,1348.7998000,972.200,0.0000000,0.0000000,179.9950000); //object(tag_azteca) (2)
	CreateDynamicObject(1531,166.2002000,1353.7998000,972.200,0.0000000,0.0000000,87.9950000); //object(tag_azteca) (3)
	CreateDynamicObject(1442,167.3000000,1346.4000000,970.799,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (1)
	CreateDynamicObject(1442,167.0996100,1353.4004000,970.799,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (2)
	CreateDynamicObject(2691,161.8999900,1345.9000000,971.700,0.0000000,0.0000000,180.0000000); //object(cj_banner09) (1)
	CreateDynamicObject(2695,167.7000000,1351.0000000,971.200,0.0000000,340.0000000,266.0000000); //object(cj_banner12) (1)
	CreateDynamicObject(2695,159.8999900,1351.0000000,972.000,0.0000000,336.0000000,96.0000000); //object(cj_banner12) (2)
	CreateDynamicObject(1766,162.8000000,1346.3000000,970.200,0.0000000,0.0000000,178.0000000); //object(med_couch_1) (1)
	CreateDynamicObject(3029,169.3999900,1340.8000000,970.200,0.0000000,1.0000000,89.2470000); //object(cr1_door) (1)
	CreateDynamicObject(356,164.3999900,1353.8000500,972.5000,0.0000000,0.0000000,0.0000000); //object(3)
	CreateDynamicObject(356,160.7000000,1353.8000000,972.5000,0.0000000,2.0000000,4.0000000); //object(4)
	CreateDynamicObject(1492,171.3000000,1342.4000000,970.200,0.0000000,0.0000000,88.0000000); //object(gen_doorint02) (1)
	CreateDynamicObject(2104,167.8000000,1349.9000000,970.200,0.0000000,0.0000000,266.0000000); //object(swank_hi_fi) (1)
	CreateDynamicObject(1840,167.6000100,1350.6000000,970.200,0.0000000,0.0000000,0.0000000); //object(speaker_2) (1)
	CreateDynamicObject(1840,167.3999900,1352.6000000,970.799,0.0000000,0.0000000,92.0000000); //object(speaker_2) (2)
	CreateDynamicObject(1840,160.7000000,1353.0000000,970.799,0.0000000,0.0000000,96.0000000); //object(speaker_2) (3)
	CreateDynamicObject(3092,160.0000000,1347.0996000,972.200,0.0000000,355.9950000,275.9990000); //object(dead_tied_cop) (1)
	CreateDynamicObject(3092,163.3999900,1346.1000000,972.000,0.0000000,0.0000000,0.0000000); //object(dead_tied_cop) (2)
	CreateDynamicObject(3012,166.0000000,1351.5000000,970.400,0.0000000,342.0000000,202.0000000); //object(chopcop_head) (1)
	CreateDynamicObject(1668,166.3999900,1351.9000000,971.000,0.0000000,0.0000000,0.0000000); //object(propvodkabotl1) (1)
	CreateDynamicObject(2714,161.3000000,1353.8000000,972.099,0.0000000,0.0000000,0.0000000); //object(cj_open_sign_2) (1)
	CreateDynamicObject(2906,166.2000000,1348.9000000,970.299,0.0000000,0.0000000,78.0000000); //object(kmb_deadarm) (3)
	CreateDynamicObject(2905,164.3999900,1345.9000000,970.299,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (3)
	CreateDynamicObject(2907,169.6000100,1347.6000000,970.400,0.0000000,0.0000000,122.0000000); //object(kmb_deadtorso) (2)
	CreateDynamicObject(2906,172.8999900,1343.2000000,970.299,0.0000000,0.0000000,296.0000000); //object(kmb_deadarm) (4)
	CreateDynamicObject(2905,174.3999900,1345.3000000,970.299,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (4)
	CreateDynamicObject(2908,169.1000100,1343.4000000,970.299,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (2)
	CreateDynamicObject(1531,167.7002000,1346.7002000,972.299,0.0000000,0.0000000,0.0000000); //object(tag_azteca) (4)
	CreateDynamicObject(1362,170.8000000,1341.3000000,970.799,0.0000000,0.0000000,0.0000000); //object(cj_firebin) (1)
	CreateDynamicObject(1531,170.3000000,1340.9000000,971.200,0.0000000,0.0000000,270.0000000); //object(tag_azteca) (5)
	CreateDynamicObject(1893,172.8999900,1352.8000000,973.200,0.0000000,0.0000000,88.0000000); //object(shoplight1) (1)
	CreateDynamicObject(1516,94.7000000,1313.6000000,923.7000,0.0000000,0.0000000,0.0000000); //object(dyn_table_03) (1)
	CreateDynamicObject(2032,168.5000000,1352.9000000,970.200,0.0000000,0.0000000,90.0000000); //object(med_dinning_2) (2)
	CreateDynamicObject(2977,170.6000100,1355.0000000,970.200,0.0000000,0.0000000,0.0000000); //object(kmilitary_crate) (1)
	CreateDynamicObject(2985,171.8000000,1354.9000000,970.200,0.0000000,0.0000000,248.0000000); //object(minigun_base) (1)
	CreateDynamicObject(348,169.2470700,1355.4502000,972.0114,0.0000000,0.0000000,0.0000000); //object(5)
	CreateDynamicObject(360,168.2000000,1353.7000000,971.0000,0.0000000,0.0000000,88.0000000); //object(6)
	CreateDynamicObject(344,168.8000000,1354.5000000,971.2000,0.0000000,0.0000000,0.0000000); //object(7)
	CreateDynamicObject(344,169.2000000,1354.5000000,971.2000,0.0000000,0.0000000,0.0000000); //object(8)
	CreateDynamicObject(344,169.6000100,1354.5000000,971.2000,0.0000000,0.0000000,0.0000000); //object(9)
	CreateDynamicObject(362,170.3000000,1354.7000000,971.5999,0.0000000,14.0000000,12.0000000); //object(10)
	CreateDynamicObject(373,168.7000000,1352.7000000,971.2000,0.0000000,0.0000000,0.0000000); //object(11)
	CreateDynamicObject(373,168.7000000,1353.4000000,971.2000,0.0000000,0.0000000,0.0000000); //object(12)
	CreateDynamicObject(2232,166.3000000,1346.2000000,970.799,0.0000000,0.0000000,180.0000000); //object(med_speaker_4) (1)
	CreateDynamicObject(16444,175.2000000,1342.1000000,970.59,0.0000000,0.0000000,0.0000000); //object(des_blackbags) (1)
	CreateDynamicObject(3092,175.3999900,1342.6000000,971.200,0.0000000,76.0000000,28.0000000); //object(dead_tied_cop) (3)
	CreateDynamicObject(2907,174.6000100,1343.1000000,970.900,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (3)
	CreateDynamicObject(2907,176.1000100,1341.4000000,970.799,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (4)
	CreateDynamicObject(2905,174.1000100,1341.8000000,971.200,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (5)
	CreateDynamicObject(2908,175.5000000,1343.2000000,971.200,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (3)
	CreateDynamicObject(3525,168.6000100,1350.2000000,971.599,0.0000000,6.0000000,346.0000000); //object(exbrtorch01) (1)
	CreateDynamicObject(3525,171.1000100,1340.9000000,972.200,0.0000000,34.0000000,128.0000000); //object(exbrtorch01) (2)
	CreateDynamicObject(2844,169.0000000,1344.6000000,970.200,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes03) (1)
	CreateDynamicObject(2846,170.3000000,1342.5000000,970.200,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes05) (1)
	CreateDynamicObject(2846,173.2000000,1344.0000000,970.200,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes05) (2)
	CreateDynamicObject(2844,172.2000000,1341.2000000,970.200,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes03) (2)
	CreateDynamicObject(2007,160.2998000,1341.5000000,970.200,0.0000000,0.0000000,90.0000000); //object(filing_cab_nu01) (1)
	CreateDynamicObject(1760,160.2000000,1342.5000000,970.200,0.0000000,0.0000000,90.0000000); //object(med_couch_2) (1)
	CreateDynamicObject(1760,163.8000000,1341.4000000,970.200,0.0000000,0.0000000,180.0000000); //object(med_couch_2) (2)
	CreateDynamicObject(1531,165.3999900,1341.0000000,971.200,0.0000000,0.0000000,270.0000000); //object(tag_azteca) (6)
	CreateDynamicObject(1531,177.2998000,1344.0000000,971.200,0.0000000,2.0000000,0.0000000); //object(tag_azteca) (7)
	CreateDynamicObject(1531,162.2000000,1344.9000000,971.200,0.0000000,0.0000000,92.0000000); //object(tag_azteca) (8)
	CreateDynamicObject(1528,171.3000000,1345.2000000,971.799,0.0000000,350.0000000,0.0000000); //object(tag_seville) (1)
	CreateDynamicObject(2007,174.5000000,1350.8000000,970.200,0.0000000,0.0000000,270.0000000); //object(filing_cab_nu01) (2)
	CreateDynamicObject(350,163.5000000,1352.3000000,970.7999,0.0000000,4.0000000,270.0000000); //object(13)
	CreateDynamicObject(358,162.8000000,1353.8000000,972.9000,0.0000000,4.0000000,6.0000000); //object(14)
	CreateDynamicObject(348,169.5000000,1355.4000000,971.2999,0.0000000,0.0000000,0.0000000); //object(15)
	CreateDynamicObject(351,168.8000000,1355.4000000,971.4000,0.0000000,0.0000000,0.0000000); //object(16)
	CreateDynamicObject(355,83.6000000,1392.1000000,944.29999,0.0000000,0.0000000,0.0000000); //object(17)
	CreateDynamicObject(356,168.2000000,1355.4000000,971.5999,0.0000000,0.0000000,0.0000000); //object(18)
	CreateDynamicObject(2952,167.2000000,1340.8000000,970.200,0.0000000,0.0000000,86.0000000); //object(kmb_gimpdoor) (2)
	CreateDynamicObject(1528,171.3000000,1345.2000000,971.799,0.0000000,350.0000000,0.0000000); //object(tag_seville) (1)
	CreateDynamicObject(19357, -289.10370, 718.33710, 999.00000, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -289.11133, 721.54834, 998.97406, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -292.59628, 721.54510, 998.99335, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -292.58990, 718.34363, 999.01837, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -296.09064, 718.34015, 999.03186, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -296.09445, 721.54620, 999.00586, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -289.09946, 715.14124, 999.02759, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -292.58212, 715.13959, 999.04810, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -296.07791, 715.14905, 999.04810, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19362, -287.41440, 720.70001, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -287.41849, 715.00623, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -287.40762, 717.75385, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -287.40140, 721.59937, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -297.81027, 721.61804, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -297.74954, 718.45258, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -297.80670, 715.27356, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -288.92407, 723.13348, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -292.11166, 723.14185, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -295.31201, 723.13818, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -296.23529, 723.13513, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -287.40656, 718.75751, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -289.08618, 715.11206, 1002.42535, -0.18000, -90.23979, 0.00002);
	CreateDynamicObject(19362, -289.08575, 718.29175, 1002.41473, -0.18000, -90.23979, 0.00002);
	CreateDynamicObject(19362, -289.08997, 721.48840, 1002.41473, -0.18000, -90.23979, 0.00002);
	CreateDynamicObject(19362, -292.58411, 721.44244, 1002.40039, -0.18000, -90.23979, 0.00002);
	CreateDynamicObject(19362, -292.57706, 718.23938, 1002.40869, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -292.58307, 715.12634, 1002.41791, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -296.04370, 715.24286, 1002.40271, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -296.06583, 718.44965, 1002.39880, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -296.01895, 721.60266, 1002.38440, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(14831, -283.01340, 720.53363, 1000.62146, 0.00000, 0.00000, -90.42002);
	CreateDynamicObject(19357, -296.07614, 712.00775, 999.06708, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -292.57547, 712.01929, 999.06708, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19357, -289.08368, 711.99524, 999.04785, -0.48000, -89.75980, 0.00000);
	CreateDynamicObject(19362, -297.81558, 712.09088, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -287.42517, 712.00635, 1000.76593, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19362, -296.28925, 710.47083, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -293.08630, 710.47839, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -296.06406, 712.08667, 1002.41541, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -292.79984, 712.04199, 1002.42340, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -289.29651, 712.05463, 1002.43390, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -289.11530, 712.05688, 1002.43390, -0.18000, -90.23980, 0.00000);
	CreateDynamicObject(19362, -289.97778, 710.46912, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(19362, -288.92862, 710.48505, 1000.76593, 0.00000, 0.00000, -90.05998);
	CreateDynamicObject(1710, -293.59360, 711.01160, 999.14667, 0.00000, 0.00000, -179.87976);
	CreateDynamicObject(2206, -290.26559, 712.18024, 999.12531, 0.00000, 0.00000, 43.20001);
	CreateDynamicObject(14820, -289.50937, 712.73633, 1000.17755, 0.00000, 0.00000, 43.02002);
	CreateDynamicObject(2232, -289.39557, 714.19696, 999.73627, 0.00000, 0.00000, -136.61992);
	CreateDynamicObject(2232, -290.97150, 712.73468, 999.73627, 0.00000, 0.00000, -136.61992);
	CreateDynamicObject(2232, -288.02457, 711.08258, 999.73627, 0.00000, 0.00000, -135.77992);
	CreateDynamicObject(2232, -288.02457, 711.08258, 1000.91650, 0.00000, 0.00000, -135.77992);
	CreateDynamicObject(19422, -289.74661, 712.07245, 1000.10938, 62.46001, -2.70000, 43.85999);
	CreateDynamicObject(19422, -288.85400, 712.91003, 1000.10938, 62.46001, -2.70000, 43.85999);
	CreateDynamicObject(14651, -290.62268, 720.55341, 1001.19434, 0.00000, 0.00000, -90.59999);
	CreateDynamicObject(2232, -292.74741, 710.93726, 999.73627, 0.00000, 0.00000, -178.91989);
	CreateDynamicObject(1716, -293.37421, 715.79956, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, -293.37094, 716.64600, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, -293.34421, 717.41132, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, -293.33286, 718.19495, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, -293.33112, 718.99786, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, -293.31952, 719.85767, 999.13348, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1665, -294.99878, 715.53888, 1000.20361, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1670, -294.88388, 717.04608, 1000.19495, 0.00000, 0.00000, 95.82000);
	CreateDynamicObject(1670, -294.87460, 718.15466, 1000.19495, 0.00000, 0.00000, 95.82000);
	CreateDynamicObject(1668, -294.97101, 715.82166, 1000.33441, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1668, -294.86673, 719.24963, 1000.37183, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4227, -297.61130, 724.04797, 1000.89703, 0.00000, 0.00000, 89.10001);
	CreateDynamicObject(17969, -294.47394, 710.60107, 1001.04962, 0.00000, 0.00000, -89.94000);
	CreateDynamicObject(4227, -286.96506, 723.08899, 1000.77332, 0.00000, 0.00000, -0.24000);
	CreateDynamicObject(2700, -297.29953, 722.78424, 1001.82648, 0.00000, 0.00000, -46.31999);
	CreateDynamicObject(2714, -297.45364, 720.81458, 1000.39856, 0.00000, 0.00000, 88.80001);
	CreateDynamicObject(19171, -297.61261, 717.60400, 1001.43610, -269.46005, -89.09982, -180.72011);
	CreateDynamicObject(18661, -297.58087, 717.61200, 1001.42651, 0.00000, 0.00000, -179.75999);
	CreateDynamicObject(1368, -294.01654, 722.68781, 999.75952, 0.00000, 0.00000, 0.30000);
	CreateDynamicObject(1737, -297.23877, 713.50867, 999.14362, 0.00000, 0.00000, -89.40002);
	CreateDynamicObject(18897, -297.08865, 713.03955, 999.97504, 102.42003, 24.60000, 0.00000);
	CreateDynamicObject(18897, -297.08578, 713.38678, 999.97504, 102.42003, 24.60000, 0.00000);
	CreateDynamicObject(18897, -297.07883, 712.24896, 999.97504, 102.42003, 24.60000, 0.00000);
	CreateDynamicObject(18897, -297.09277, 713.75922, 999.97504, 102.42003, 24.60000, 0.00000);
	CreateDynamicObject(18897, -297.08945, 712.63739, 999.97504, 102.42003, 24.60000, 0.00000);
	CreateDynamicObject(14699, -298.05618, 711.17651, 1000.65765, 0.00000, 0.00000, -92.16000);
	CreateDynamicObject(1569, -287.45224, 717.59534, 999.09424, 0.00000, 0.00000, -270.48001);
	CreateDynamicObject(3265, -287.46606, 719.75854, 999.14380, 0.00000, 0.00000, -90.12003);
	CreateDynamicObject(336, -296.92261, 713.08588, 999.91461, 83.09998, -28.50001, 30.09625);
	CreateDynamicObject(336, -297.48349, 713.11609, 999.91461, 83.09998, -28.50001, 28.53712);
	CreateDynamicObject(365, -297.01202, 713.61005, 999.99365, -91.80001, -36.41999, 334.07077);
	CreateDynamicObject(365, -297.01498, 712.93964, 999.99365, -91.80001, -36.41999, 328.07095);
	CreateDynamicObject(365, -297.44128, 713.64557, 999.99365, -91.80001, -36.41999, 334.07077);
	CreateDynamicObject(365, -297.37671, 712.34735, 999.99365, -91.80001, -36.41999, 334.07077);
	CreateDynamicObject(1668, -294.93408, 716.34045, 1000.33441, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1668, -295.41330, 718.19257, 1000.33441, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1668, -296.96951, 717.99017, 1000.33441, 0.00000, 0.00000, 0.00000);

	//Las Colinas Vagos
		//Exterior
	CreateDynamicObject(1342,2152.7002000,-1008.5996000,62.8000000,356.0000000,0.0000000,72.9990000); //object(noodlecart_prop) (1)
	CreateDynamicObject(1432,2147.9004000,-1010.0996000,61.6000000,0.0000000,357.0000000,339.9990000); //object(dyn_table_2) (2)
	CreateDynamicObject(1709,2190.5000000,-996.2998000,66.3000000,0.0000000,0.0000000,0.0000000); //object(kb_couch08) (1)
	CreateDynamicObject(1710,2165.9980000,-995.7019700,62.0000000,0.0000000,0.0000000,349.9970000); //object(kb_couch07) (1)
	CreateDynamicObject(1442,2172.0000000,-995.5000000,63.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (1)
	CreateDynamicObject(1442,2196.2000000,-1000.0000000,66.9000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0) (2)
	CreateDynamicObject(3497,2185.4004000,-999.4003900,65.7000100,0.0000000,0.0000000,167.9970000); //object(vgsxrefbballnet2) (1)
	CreateDynamicObject(2114,2183.7000000,-999.7999900,62.0000000,0.0000000,0.0000000,0.0000000); //object(basketball) (1)
	CreateDynamicObject(1431,2194.1999500,-999.7000100,66.9000000,0.0000000,0.0000000,345.0000000); //object(dyn_box_pile) (1)
	CreateDynamicObject(3061,2191.8999000,-985.2000100,67.5000000,0.0000000,0.0000000,349.0000000); //object(ad_flatdoor) (1)
	CreateDynamicObject(1786,2192.3000000,-999.5000000,66.3000000,0.0000000,0.0000000,160.0000000); //object(swank_tv_4) (1)
	CreateDynamicObject(1349,2151.1001000,-1012.3000000,62.4000000,0.0000000,355.0000000,0.0000000); //object(cj_shtrolly) (2)
	CreateDynamicObject(970,2187.5000000,-997.3000500,67.2000000,0.0000000,0.0000000,78.0000000); //object(fencesmallb) (1)


	//Northside Asian Boyz
		//Exterior
	CreateDynamicObject(3684, 1030.7998, -905.40039, 44.6, 0, 0, 5.999);
	CreateDynamicObject(3684, 1050.8, -887.40002, 44.6, 0, 0, 274);
	CreateDynamicObject(8613, 1062.9, -921.20001, 46, 0, 0, 188);
	CreateDynamicObject(910, 1065.9, -923.40002, 43.3, 0, 0, 192);
	CreateDynamicObject(2971, 1041.7, -915.90002, 41.5, 0, 0, 0);
	CreateDynamicObject(1344, 1063.2, -924.09998, 42.7, 0, 0, 192);
	CreateDynamicObject(12957, 1064.6, -897.40002, 42.7, 0, 0, 327);
	CreateDynamicObject(3461, 1063.2, -919.79999, 41.6, 0, 0, 0);
	CreateDynamicObject(1442, 1063.3, -919.90002, 42.6, 0, 0, 0);
	CreateDynamicObject(2987, 1038.8, -928.5, 42.6, 0, 0, 188);
	CreateDynamicObject(8673, 1021, -911.79999, 42.6, 0, 0, 278);
	CreateDynamicObject(8673, 1018.42, -893.46002, 42.6, 0, 0, 277.998);
	CreateDynamicObject(946, 1045.3, -908.70001, 43.8, 0, 0, 272);
	CreateDynamicObject(17037, 1054.2, -924.09998, 44, 0, 0, 97.995);
	CreateDynamicObject(946, 1061.2, -908, 44.2, 0, 0, 90.001);
	CreateDynamicObject(17037, 1047, -925.09998, 44, 0, 0, 97.993);
	CreateDynamicObject(1570, 1041.8, -898.70001, 42.73, 0, 0, 38);
	CreateDynamicObject(2114, 1060.1, -906.79999, 42.1, 0, 0, 0);
	CreateDynamicObject(3459, 1025.4, -921.20001, 48.7, 0, 0, 0);
	CreateDynamicObject(3459, 1062.7, -895.70001, 49.7, 0, 0, 5.25);


	//San Fierro Triads
	CreateDynamicObject(1346,1540.400390625,-1881.599609375,13.89999961853,0.00000,0.00000,179.99450683594);
	CreateDynamicObject(1342,1545.8396, -1878.0000, 13.6000, 0.00000,0.00000,90);
	CreateDynamicObject(1364,1557.2998046875,-1863,13.300000190735,0.00000,0.00000,0.00000);
	CreateDynamicObject(3881,1542.2998046875,-1909.400390625,28,0.00000,0.00000,179.99450683594) ;
	CreateDynamicObject(3881,1594.099609375,-1909.5,28,0.00000,0.00000,179.99450683594);
	CreateDynamicObject(1568,1560.099609375,-1862.7998046875,12.5,0.00000,0.00000,0.00000);
	CreateDynamicObject(1364,1560.5,-1860.2998046875,13.300000190735,0.00000,0.00000,90 );
	CreateDynamicObject(9482,1569.5234375,-1857.2998046875,17.930000305176,0.00000,0.00000,90 );
	CreateDynamicObject(1364,1579.400390625,-1860.599609375,13.300000190735,0.00000,0.00000,270 );
	CreateDynamicObject(1568,1579.900390625,-1863.2001953125,12.5,0.00000,0.00000,0.00000);
	CreateDynamicObject(1364,1582.5,-1863.2001953125,13.300000190735,0.00000,0.00000,0.00000);
	CreateDynamicObject(3471,1563.400390625,-1742.900390625,13.800000190735,0.00000,0.00000,0.00000);
	CreateDynamicObject(3471,1575.7998046875,-1742.7998046875,13.800000190735,0.00000,0.00000,179.99450683594);
	CreateDynamicObject(3038,1569.7001953125,-1857.400390625,22,0.00000,0.00000,90);
	CreateDynamicObject(1371,1547.900390625,-1878,13.300000190735,0.00000,0.00000,149.99633789063);
	CreateDynamicObject(1257,1602.7001953125,-1878.400390625,13.800000190735,0.0000,0.0000,270);
	CreateDynamicObject(3467,1603.7001953125,-1864.099609375,13.199999809265,0.00000,0.00000,39.995727539063);
	CreateDynamicObject(2098,1606.5,-1862.3095703125,14,0.0000,0.0000,0.0000);
	CreateDynamicObject(1536,1605,-1862.2998046875,12.5,0.0000,0.0000,0.0000);
	CreateDynamicObject(1536,1608,-1862.2802734375,12.5,0.0000,0.00000,179.99450683594);

	// 18th Street Lokotes

	// exterior
	CreateDynamicObject(3582, 2030.93884, -1686.98901, 14.93902,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1362, 2040.66895, -1685.00073, 13.20970,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(18689, 2040.72095, -1685.32751, 11.94539,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2670, 2041.08508, -1684.05933, 12.63780,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(946, 2037.73340, -1694.36292, 14.71527,   0.00000, 0.00000, -90.00000, .streamdistance = 180.0);
	CreateDynamicObject(1946, 2038.57300, -1693.26306, 12.73226,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2672, 2040.12146, -1687.81885, 12.86123,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1331, 2045.81738, -1697.52722, 13.34801,   0.00000, 0.00000, -91.97998, .streamdistance = 180.0);
	CreateDynamicObject(1946, 2022.76196, -1684.42322, 12.69687,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2672, 2024.16064, -1686.29175, 12.82801,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1460, 2036.14050, -1689.92053, 13.24401,   -20.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(3006, 2045.69849, -1699.78491, 12.31320,   0.00000, 0.00000, -177.89995, .streamdistance = 180.0);
	CreateDynamicObject(1712, 2037.75415, -1684.66528, 12.51489,   0.00000, 0.00000, 82.74000, .streamdistance = 180.0);
	CreateDynamicObject(1712, 2038.69165, -1687.36121, 12.51489,   0.00000, 0.00000, 115.37998, .streamdistance = 180.0);
	CreateDynamicObject(1712, 2025.19885, -1683.32397, 12.51489,   0.00000, 0.00000, 180.06006, .streamdistance = 180.0);
	CreateDynamicObject(2370, 2043.20447, -1686.61841, 12.39034,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(335, 2043.46021, -1687.02344, 13.20950,   90.00000, 90.00000, 25.00000, .streamdistance = 180.0);
	CreateDynamicObject(2674, 2043.47937, -1686.37878, 13.24480,   0.00000, 0.00000, 98.63998, .streamdistance = 180.0);
	CreateDynamicObject(1486, 2044.17749, -1685.95520, 13.25880,   90.00000, 45.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1369, 2045.89941, -1696.17383, 12.94830,   15.00000, 90.00000, -156.89980, .streamdistance = 180.0);


	// interior

	CreateDynamicObject(1501, 1191.54468, -2051.38745, 	100000.86719 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(14476, 1190.36487, -2059.06396, 100000.85156 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(19454, 1193.07007, -2069.82520, 100000.79688 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(19454, 1189.58142, -2069.81958, 100000.79688 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1206.46216, -2065.05640, 	100001.50781 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1206.43604, -2065.04565,	100002.86719 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1206.43604, -2065.04565, 	100003.11719 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(19454, 1192.75012, -2069.60522, 100003.50000 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1194.33411, -2077.57275, 	100001.57031 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1194.33411, -2077.57275, 	100002.96875 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1193.00830, -2074.13306, 	100001.57031 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1193.00830, -2074.13306, 	100002.96875 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(19454, 1185.95337, -2069.74048, 100003.50000 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(14414, 1186.50830, -2067.60327, 99997.66406  - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1178.17358, -2065.05640, 	100001.50781 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1178.17358, -2065.05640, 	100002.33594 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.19556, -2074.84473, 	100001.57031 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.19556, -2074.84473, 	100000.17188 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(19454, 1189.27356, -2069.61084, 100003.50000 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.21558, -2074.84473, 	100002.95313 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1178.17358, -2065.05640, 	100003.71094 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(14794, 1179.58606, -2050.11230, 99997.36719 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.17566, -2073.89990, 	99998.97656 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.15564, -2073.89990, 	99997.60938 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1178.00000, -2060.81519, 	99998.15625 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1201.14001, -2060.81519, 	99995.39844 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1187.97754, -2073.62354, 	100000.01563 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1187.97754, -2073.64355, 	99998.62500 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1187.97754, -2073.62231, 	99997.35156 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1187.97754, -2073.62354, 	99995.98438 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1201.14001, -2060.81519, 	99996.77344 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1200.90002, -2060.81519, 	99994.82031 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.15564, -2073.89990, 	99996.21094 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.13562, -2073.89990, 	99995.03906 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1178.00000, -2060.81519, 	99999.52344 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1177.40381, -2065.05029, 	100000.70313 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1187.04187, -2052.12744, 	100000.15625 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1198.00000, -2052.12744, 	100000.13281 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1188.42224, -2052.12744, 	100000.15625 - 90000,   0.00000, 90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(970, 1187.93140, -2067.33081, 	100001.40625 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(9339, 1186.19556, -2048.71997, 	100000.17188 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(14781, 1179.41516, -2050.34766, 99995.62500 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(19898, 1180.35046, -2050.57764, 99995.50000 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(911, 1170.71289, -2039.93677, 	99995.51563 - 90000,   0.00000, 0.00000, 26.82001, .streamdistance = 180.0);
	CreateDynamicObject(1429, 1170.87915, -2039.74573, 	99996.32813 - 90000,   0.00000, 0.00000, 23.88000, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1170.39612, -2040.43176, 	99995.13281 - 90000,   40.00000, 0.00000, -20.00000, .streamdistance = 180.0);
	CreateDynamicObject(18663, 1174.74695, -2039.11133, 99996.89063 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(18663, 1182.66125, -2039.11328, 99996.89063 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1172.64539, -2044.43494, 	99994.93750 - 90000,   0.00000, 0.00000, -168.53998, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1174.42700, -2040.77283, 	99994.93750 - 90000,   0.00000, 0.00000, -91.68001, .streamdistance = 180.0);
	CreateDynamicObject(2677, 1172.01074, -2041.94653, 	99995.24219 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2670, 1187.21045, -2057.46997, 	99995.04688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2672, 1186.70129, -2043.46570, 	99995.21875 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2670, 1177.33142, -2056.98950, 	99995.04688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2087, 1187.01453, -2054.35132, 	100000.86719 - 90000,   0.00000, 0.00000, 33.96001, .streamdistance = 180.0);
	CreateDynamicObject(1518, 1187.14038, -2054.40015, 	100002.28125 - 90000,   0.00000, 0.00000, 26.52000, .streamdistance = 180.0);
	CreateDynamicObject(2853, 1187.84253, -2053.94604, 	100002.00000 - 90000,   0.00000, 0.00000, -64.80003, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1189.06555, -2057.85181, 	100000.88281 - 90000,   0.00000, 0.00000, -189.96001, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1190.65503, -2054.53418, 	100000.88281 - 90000,   0.00000, 0.00000, -76.20004, .streamdistance = 180.0);
	CreateDynamicObject(2370, 1188.00525, -2055.21802, 	100000.67969 - 90000,   0.00000, 0.00000, -65.03999, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1189.24304, -2055.46118, 	100001.56250 - 90000,   0.00000, 90.00000, -25.00000, .streamdistance = 180.0);
	CreateDynamicObject(19896, 1188.51343, -2055.32202, 100001.53125 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(19571, 1188.09875, -2055.32422, 100001.52344 - 90000,   -90.00000, 0.00000, 64.62000, .streamdistance = 180.0);
	CreateDynamicObject(335, 1188.30237, -2055.66724, 	100001.49219 - 90000,   90.00000, 0.00000, -24.84000, .streamdistance = 180.0);
	CreateDynamicObject(2100, 1187.79785, -2064.36401, 	100000.84375 - 90000,   0.00000, 0.00000, 147.66003, .streamdistance = 180.0);
	CreateDynamicObject(1497, 1188.43408, -2063.85767, 	100000.78906 - 90000,   20.00000, 0.00000, -7.01998, .streamdistance = 180.0);
	CreateDynamicObject(1264, 1187.76331, -2061.04688, 	100001.05469 - 90000,   0.00000, 0.00000, -0.60000, .streamdistance = 180.0);
	CreateDynamicObject(1441, 1187.14404, -2061.92969, 	100001.50781 - 90000,   0.00000, 0.00000, 87.95994, .streamdistance = 180.0);
	CreateDynamicObject(2672, 1188.89270, -2059.67017, 	100001.16406 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2677, 1193.50549, -2063.33447, 	100001.14844 - 90000,   0.00000, 0.00000, -193.73993, .streamdistance = 180.0);
	CreateDynamicObject(2319, 1194.25696, -2055.69409, 	100000.83594 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1194.40967, -2054.09839, 	100001.44531 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2867, 1194.31616, -2054.77368, 	100001.35156 - 90000,   0.00000, 0.00000, 39.06000, .streamdistance = 180.0);
	CreateDynamicObject(372, 1194.05750, -2055.65186, 	100001.32031 - 90000,   90.00000, 0.00000, 28.26000, .streamdistance = 180.0);
	CreateDynamicObject(1491, 1187.95203, -2068.76660, 	100004.46094 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2475, 1188.97852, -2072.06030, 	100004.10156 - 90000,   0.00000, 0.00000, 180.00000, .streamdistance = 180.0);
	CreateDynamicObject(2332, 1189.72168, -2070.11548, 	100005.92969 - 90000,   0.00000, 0.00000, -90.00000, .streamdistance = 180.0);
	CreateDynamicObject(348, 1188.26038, -2071.86523, 	100005.60938 - 90000,   90.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(348, 1188.86121, -2071.85059, 	100005.60938 - 90000,   90.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1189.15588, -2071.94702, 	100004.88281 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1188.29834, -2071.85938, 	100004.88281 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(357, 1188.36682, -2072.04346, 	100005.92969 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2044, 1188.99719, -2071.88403, 	100006.31250 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2044, 1188.61719, -2071.89502, 	100006.31250 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2044, 1188.25378, -2071.86475, 	100006.31250 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1810, 1190.49475, -2063.44238, 	100000.79688 - 90000,   0.00000, 0.00000, 212.76003, .streamdistance = 180.0);
	CreateDynamicObject(1810, 1189.63379, -2062.93188, 	100000.79688 - 90000,   0.00000, 0.00000, 137.52007, .streamdistance = 180.0);
	CreateDynamicObject(1810, 1188.93604, -2060.73657, 	100000.79688 - 90000,   0.00000, 0.00000, 80.22009, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1188.65857, -2067.09253, 	100000.86719 - 90000,   0.00000, 0.00000, 92.34002, .streamdistance = 180.0);
	CreateDynamicObject(1712, 1189.24023, -2069.52515, 	100000.86719 - 90000,   0.00000, 0.00000, 107.46004, .streamdistance = 180.0);
	CreateDynamicObject(2311, 1190.86340, -2067.97192, 	100000.88281 - 90000,   0.00000, 0.00000, 97.13999, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1190.84277, -2066.82983, 	100001.52344 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1190.67480, -2067.47876, 	100001.52344 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1486, 1191.21606, -2068.09888, 	100001.52344 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1462, 1170.16699, -2060.22192,	99994.92969 - 90000,   0.00000, 0.00000, 77.64001, .streamdistance = 180.0);
	CreateDynamicObject(3006, 1170.63086, -2056.82373,	99994.68750 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2677, 1173.08508, -2058.05371,	99995.21875 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2816, 1170.98608, -2055.43872,	99994.92969 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(943, 1187.75525, -2040.88928, 	99995.57813 - 90000,   0.00000, 0.00000, 180.00000, .streamdistance = 180.0);
	CreateDynamicObject(941, 1186.64246, -2040.96631, 	99995.33594 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(941, 1188.90002, -2040.96631, 	99995.33594 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1186.53284, -2039.91724, 	99995.79688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1186.50867, -2040.75916, 	99995.79688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1186.74036, -2041.49023, 	99995.79688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2780, 1186.72009, -2039.64429, 	99991.03125 - 90000,   -90.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(934, 1182.36499, -2040.06311, 	99996.18750 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(936, 1180.73169, -2041.54834, 	99995.37500 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(937, 1182.62488, -2041.51917, 	99995.37500 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1182.14282, -2041.75830, 	99995.09375 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1183.04578, -2041.63416, 	99995.09375 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1182.08740, -2041.49646, 	99995.46875 - 90000,   0.00000, 0.00000, -58.02001, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1183.20105, -2041.62695, 	99995.46875 - 90000,   0.00000, 0.00000, 55.31997, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1182.63538, -2041.63403, 	99995.46875 - 90000,   0.00000, 0.00000, 5.87998, .streamdistance = 180.0);
	CreateDynamicObject(920, 1183.19800, -2041.37463, 	99996.34375 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(920, 1188.71960, -2059.96948, 	100005.79688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(3675, 1187.54895, -2060.00342, 	100008.32813 - 90000,   90.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(921, 1189.47388, -2059.71509, 	100006.07813 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2677, 1191.61804, -2063.05933, 	100004.77344 - 90000,   0.00000, 0.00000, 199.32004, .streamdistance = 180.0);
	CreateDynamicObject(1462, 1187.02820, -2065.24194, 	100004.46094 - 90000,   0.00000, 0.00000, 85.50003, .streamdistance = 180.0);
	CreateDynamicObject(3006, 1186.72083, -2066.60132, 	100004.13281 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1501, 1189.66553, -2064.98730, 	100004.32813 - 90000,   15.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(348, 1191.31055, -2065.11914, 	100004.48438 - 90000,   90.00000, 0.00000, 11.58000, .streamdistance = 180.0);
	CreateDynamicObject(1620, 1193.04248, -2064.14795, 	100006.19531 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(936, 1188.14502, -2060.23486, 	100004.86719 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1808, 1185.33838, -2061.46875, 	100004.57813 - 90000,   90.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(1485, 1188.29907, -2059.99536, 	100006.21875 - 90000,   -20.00000, -90.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2671, 1188.19861, -2061.24609, 	100004.47656 - 90000,   0.00000, 0.00000, -73.31998, .streamdistance = 180.0);
	CreateDynamicObject(930, 1191.12146, -2068.13135, 	100004.92969 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1217, 1192.62207, -2065.10913, 	100004.82813 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1810, 1187.39417, -2064.24927, 	100004.85938 - 90000,   -90.00000, 0.00000, 4.50000, .streamdistance = 180.0);
	CreateDynamicObject(2418, 1192.24194, -2061.66089, 	100004.51563 - 90000,   0.00000, 0.00000, -90.00000, .streamdistance = 180.0);
	CreateDynamicObject(941, 1190.57495, -2063.97852, 	100005.00000 - 90000,   90.00000, 0.00000, 50.40000, .streamdistance = 180.0);
	CreateDynamicObject(1510, 1187.33948, -2060.61133, 	100005.35156 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1951, 1187.70947, -2060.45581, 	100005.50781 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1951, 1192.25830, -2061.84766, 	100005.62500 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1192.23083, -2061.74048, 	100005.06250 - 90000,   0.00000, 0.00000, 84.84000, .streamdistance = 180.0);
	CreateDynamicObject(1578, 1192.15332, -2062.29395, 	100004.71875 - 90000,   0.00000, 0.00000, 146.99994, .streamdistance = 180.0);
	CreateDynamicObject(2437, 1187.76904, -2059.70117, 	100004.88281 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(924, 1189.34668, -2060.32837, 	100004.67188 - 90000,   0.00000, 0.00000, 98.63999, .streamdistance = 180.0);
	CreateDynamicObject(14578, 1189.82214, -2068.30005, 100008.08594 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1455, 1192.67493, -2062.74927,	100005.55469 - 90000,   180.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1455, 1192.10315, -2062.44946,	100005.55469 - 90000,   180.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(17969, 1189.74487, -2059.62451, 100005.99219 - 90000,   -15.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(14804, 1196.03467, -2068.11255, 100005.39063 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1217, 1194.22119, -2058.77319, 	100001.28125 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2037, 1194.24316, -2057.16260, 	100000.90625 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(2042, 1194.01538, -2056.68750, 	100000.95313 - 90000,   0.00000, 0.00000, 241.98000, .streamdistance = 180.0);
	CreateDynamicObject(2042, 1188.36121, -2060.35254, 	100000.97656 - 90000,   0.00000, 0.00000, 51.36000, .streamdistance = 180.0);
	CreateDynamicObject(930, 1192.96594, -2073.57422, 	100001.32813 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1217, 1193.66370, -2065.71240, 	100001.28125 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(3016, 1180.17407, -2059.48413, 	99995.07813 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(930, 1183.03284, -2060.06909, 	99995.36719 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1217, 1189.14001, -2059.97339,	99995.29688 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(3071, 1179.36707, -2059.22437,	99995.10156 - 90000,   0.00000, 90.00000, -56.34000, .streamdistance = 180.0);
	CreateDynamicObject(2627, 1178.52539, -2059.05664,	99994.91406 - 90000,   0.00000, 0.00000, 22.43999, .streamdistance = 180.0);
	CreateDynamicObject(2629, 1176.45789, -2058.61255,	99994.93750 - 90000,   0.00000, 0.00000, 182.34004, .streamdistance = 180.0);
	CreateDynamicObject(2630, 1174.38062, -2058.88501,	99994.93750 - 90000,   0.00000, 0.00000, 157.02003, .streamdistance = 180.0);
	CreateDynamicObject(1368, 1170.80200, -2053.47534,	99995.63281 - 90000,   0.00000, 0.00000, 99.65990, .streamdistance = 180.0);
	CreateDynamicObject(1368, 1173.31079, -2055.23633,	99995.58594 - 90000,   0.00000, 0.00000, 205.13994, .streamdistance = 180.0);
	CreateDynamicObject(11730, 1170.18677, -2050.52197, 99994.92969 - 90000,   0.00000, 0.00000, 93.18000, .streamdistance = 180.0);
	CreateDynamicObject(11730, 1170.54065, -2049.42749, 99994.92969 - 90000,   0.00000, 0.00000, 67.31998, .streamdistance = 180.0);
	CreateDynamicObject(964, 1170.72620, -2047.91663, 	99994.88281 - 90000,   0.00000, 0.00000, 90.77998, .streamdistance = 180.0);
	CreateDynamicObject(964, 1170.72620, -2046.59998, 	99994.88281 - 90000,   0.00000, 0.00000, 90.78000, .streamdistance = 180.0);
	CreateDynamicObject(964, 1170.72620, -2047.25000, 	99995.85156 - 90000,   0.00000, 0.00000, 90.78000, .streamdistance = 180.0);
	CreateDynamicObject(1893, 1181.06104, -2041.27771,	99999.78125 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1893, 1188.25293, -2061.13184, 	100008.19531 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1893, 1193.76196, -2057.16992, 	100004.30469 - 90000,   0.00000, 0.00000, 90.00000, .streamdistance = 180.0);
	CreateDynamicObject(930, 1192.46362, -2060.07373, 	100004.86719 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);
	CreateDynamicObject(1431, 1190.78357, -2060.42847, 	100004.89844 - 90000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.0);

	// ballas

	/*CreateDynamicObject(970, 2072.28638, -1785.77551, 13.09417,   0.00000, 0.00000, -107.75999, .streamdistance = 150.00);
	CreateDynamicObject(970, 2073.55444, -1781.80957, 13.09417,   0.00000, 0.00000, -107.75999, .streamdistance = 150.00);
	CreateDynamicObject(970, 2074.82715, -1777.83557, 13.09417,   0.00000, 0.00000, -107.75999, .streamdistance = 150.00);
	CreateDynamicObject(970, 2077.75244, -1768.27087, 13.09417,   0.00000, 0.00000, -105.12000, .streamdistance = 150.00);
	CreateDynamicObject(970, 2076.57764, -1772.25146, 13.09417,   0.00000, 0.00000, -107.75999, .streamdistance = 150.00);
	CreateDynamicObject(970, 2078.78955, -1764.30847, 13.09417,   0.00000, 0.00000, -104.22002, .streamdistance = 150.00);
	CreateDynamicObject(970, 2076.81689, -1762.30945, 13.09417,   0.00000, 0.00000, -179.64000, .streamdistance = 150.00);
	CreateDynamicObject(970, 2072.66479, -1762.33936, 13.09417,   0.00000, 0.00000, -179.64000, .streamdistance = 150.00);
	CreateDynamicObject(970, 2068.48364, -1762.36865, 13.09417,   0.00000, 0.00000, -179.87999, .streamdistance = 150.00);
	CreateDynamicObject(1498, 2063.55078, -1787.85657, 12.53814,   0.00000, 0.00000, 180.71997, .streamdistance = 150.00);
	CreateDynamicObject(3095, 2062.33105, -1782.76526, 15.70000,   0.00000, 0.00000, -88.20000, .streamdistance = 150.00);
	CreateDynamicObject(3095, 2060.36499, -1791.82910, 15.70000,   0.00000, 0.00000, -88.20000, .streamdistance = 150.00);
	CreateDynamicObject(1756, 2074.62573, -1763.09180, 12.52246,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1753, 2077.77246, -1765.12073, 12.53641,   0.00000, 0.00000, -104.82002, .streamdistance = 150.00);
	CreateDynamicObject(933, 2075.61792, -1765.08105, 12.43922,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1711, 2073.56177, -1765.43152, 12.53642,   0.00000, 0.00000, 96.18001, .streamdistance = 150.00);
	CreateDynamicObject(18667, 2061.04663, -1784.69617, 18.65212,   0.00000, 0.00000, -179.70026, .streamdistance = 150.00);
	CreateDynamicObject(1442, 2072.22681, -1778.52368, 13.11095,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2676, 2071.83179, -1771.41492, 12.65525,   0.00000, 0.00000, -49.20000, .streamdistance = 150.00);
	CreateDynamicObject(18688, 2072.15308, -1778.49927, 11.89560,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);*/

	// SACC

	// exterior

	CreateDynamicObject(1766, 1952.70019, -1762.00000, 12.50000, 0.00000, 0.00000, 134.99450, .streamdistance = 180.00);
	CreateDynamicObject(1271, 1954.20019, -1759.79980, 12.89999, 0.00000, 0.00000, 21.99462, .streamdistance = 180.00);
	CreateDynamicObject(1711, 1951.79980, -1758.79980, 12.50000, 0.00000, 0.00000, 27.99865, .streamdistance = 180.00);
	CreateDynamicObject(1820, 1952.40039, -1760.40039, 12.50000, 0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
	CreateDynamicObject(1497, 1940.50000, -1828.40039, 6.09999, 334.05578, 0.00000, 345.99792, .streamdistance = 180.00);

	CreateDynamicObject(3454,1936.0000000,-1808.8000000,16.8000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(3698,1913.4000000,-1805.5000000,15.3000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(1712,1933.9500000,-1809.5000000,16.4000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(8417,897.4003900,-1034.5996000,30.5600000,179.9950000,0.0000000,90.0000000);
	CreateDynamicObject(3109,909.5703100,-1014.0000000,107.7900000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(984,883.2998000,-1015.0000000,38.7000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(3920,914.2500000,-1005.0000000,40.7000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(1280,934.3499800,-997.7000100,37.6000000,0.0000000,0.0000000,0.5000000);
	CreateDynamicObject(3037,1509.4102000,-1476.0000000,10.7000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(1215,1540.1000000,-1450.9500000,13.1000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(1215,1529.4102000,-1450.9502000,13.1000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(1368,1525.8000000,-1450.5000000,13.2400000,0.0000000,0.0000000,180.0000000);
	CreateDynamicObject(18257,1520.0500000,-1457.3000000,8.5000000,0.0000000,0.0000000,180.0000000);
	CreateDynamicObject(14782,1521.5000000,-1456.8700000,9.4550000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(996,1515.5000000,-1445.9300500,13.3000000,0.0000000,0.0000000,0.0000000);

	// interior

	CreateDynamicObject(19379, 1182.22974, -991.26727, -60.78130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -976.89050, -61.42130, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19379, 1171.72925, -991.26727, -60.78130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19379, 1182.22974, -981.63281, -60.78130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19379, 1171.72925, -981.63281, -60.78130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.72925, -976.89050, -61.42130, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(14416, 1180.13550, -994.47760, -59.80000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1187.43188, -981.63281, -61.42130, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1187.43188, -992.13379, -61.42130, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -996.04089, -61.42130, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.72925, -996.04089, -61.42130, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.54004, -981.63281, -61.42130, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.54004, -992.13379, -61.42130, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2207, 1180.93738, -988.36670, -60.70030, 0.00000, 0.00000, 43.00000, .streamdistance = 150.00);
	CreateDynamicObject(2208, 1179.62390, -985.07373, -60.78800, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(2208, 1179.06152, -985.59106, -60.78850, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1182.30432, -992.59998, -61.42130, 90.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1180.02563, -992.60199, -61.42130, 90.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2208, 1177.15247, -983.53558, -60.78830, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(2208, 1177.70544, -983.01093, -60.78860, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(2207, 1177.69775, -982.11981, -60.70010, 0.00000, 0.00000, -137.00000, .streamdistance = 150.00);
	CreateDynamicObject(1649, -987.43970, -56.61000, -56.61000, 90.00000, 90.00000, -180.00000, .streamdistance = 150.00);
	CreateDynamicObject(19462, 1169.90015, -990.08020, -56.69000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19462, 1176.54932, -994.22180, -56.69000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19462, 1173.18420, -994.22180, -56.69100, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19462, 1169.89990, -999.71332, -56.69000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.40002, -985.25671, -51.96230, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1173.04932, -990.07800, -53.32330, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1173.05005, -999.71179, -53.32130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19376, 1171.72925, -996.04089, -51.80000, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19379, 1162.90002, -990.08130, -56.69000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.72925, -980.53278, -53.32130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -980.53278, -53.32130, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -991.26727, -53.32100, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -982.74731, -53.31740, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1178.22778, -991.15460, -51.96500, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1178.22778, -994.26398, -61.60000, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -996.04089, -51.79000, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.54004, -981.63281, -51.79000, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.72925, -976.89050, -51.78700, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1182.22974, -976.89050, -51.78700, 90.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1187.43188, -981.63281, -51.78700, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1187.43188, -992.13379, -51.78700, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1180.02563, -992.60199, -51.78700, 90.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1569, 1176.21472, -976.97540, -60.70000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1569, 1179.21326, -976.97540, -60.70000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.54004, -997.31000, -51.80000, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1166.53796, -985.38501, -51.79000, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1166.53894, -991.01971, -52.82000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19456, 1161.65552, -994.17181, -55.69000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19456, 1161.65552, -987.56262, -55.69000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19456, 1157.67615, -991.06097, -55.69000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19455, 1164.72180, -991.30920, -53.90000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19455, 1161.22095, -991.30920, -53.90000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19455, 1157.72205, -991.30920, -53.90000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2205, 1169.82471, -987.56116, -56.61100, 0.00000, 0.00000, -127.00000, .streamdistance = 150.00);
	CreateDynamicObject(1714, 1168.17651, -987.14325, -56.60100, 0.00000, 0.00000, 53.00000, .streamdistance = 150.00);
	CreateDynamicObject(1726, 1169.36572, -995.24799, -56.63100, 0.00000, 0.00000, 125.00000, .streamdistance = 150.00);
	CreateDynamicObject(1727, 1172.37781, -994.52814, -56.63100, 0.00000, 0.00000, -127.00000, .streamdistance = 150.00);
	CreateDynamicObject(1727, 1169.24316, -992.14856, -56.63100, 0.00000, 0.00000, 11.00000, .streamdistance = 150.00);
	CreateDynamicObject(1823, 1169.94690, -994.27429, -56.63100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19462, 1166.40002, -999.71399, -56.69000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.84924, -990.07800, -53.32430, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1171.84924, -999.71179, -53.32430, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1181.94849, -985.08868, -60.70000, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1181.23413, -984.29553, -60.70000, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1180.46411, -983.49426, -60.70000, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1179.70801, -982.74274, -60.70000, 0.00000, 0.00000, -47.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1176.64966, -985.32397, -60.70000, 0.00000, 0.00000, 133.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1177.46045, -986.17902, -60.70000, 0.00000, 0.00000, 133.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1178.24866, -987.05402, -60.70000, 0.00000, 0.00000, 133.00000, .streamdistance = 150.00);
	CreateDynamicObject(1715, 1178.99951, -987.81555, -60.70000, 0.00000, 0.00000, 133.00000, .streamdistance = 150.00);
	CreateDynamicObject(1472, 1186.00671, -983.51752, -60.40000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(19362, 1185.82458, -985.11981, -59.99000, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1472, 1185.98669, -986.72589, -60.40000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2230, 1184.96985, -985.12939, -60.00000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2230, 1184.96985, -985.68939, -60.00000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1174.97595, -987.37921, -56.63400, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1174.97595, -985.31598, -54.57200, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1178.29761, -987.37921, -53.32000, 90.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1169.92004, -990.08020, -56.79000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1162.92004, -990.08130, -56.79000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1173.18420, -994.20178, -56.79100, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1176.54932, -994.20282, -56.79000, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1176.52551, -992.85498, -61.60000, 90.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19391, 1174.86304, -994.37231, -59.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19404, 1173.24634, -985.46198, -59.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19358, 1171.52661, -994.45569, -59.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19358, 1172.39575, -991.55688, -59.00000, 0.00000, 0.00000, -33.00000, .streamdistance = 150.00);
	CreateDynamicObject(19388, 1173.24634, -988.67340, -59.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1491, 1173.24597, -987.89001, -60.75000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19450, 1173.24634, -979.03949, -59.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1651, 1173.24072, -985.47937, -58.97200, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1955, 1184.78247, -985.10260, -58.54700, 40.00000, -18.00000, -58.00000, .streamdistance = 150.00);
	CreateDynamicObject(1724, 1160.79858, -989.20587, -56.63100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1798, 1161.27246, -993.58575, -56.63100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2527, 1165.00854, -993.44342, -56.63100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2523, 1165.96228, -992.04779, -56.61000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2528, 1163.73120, -993.58557, -56.61000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19435, 1163.03589, -993.76611, -56.61000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19435, 1163.75317, -993.05078, -56.62000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2425, 1163.53003, -987.80353, -55.69100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2426, 1162.49487, -987.94983, -55.68000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2453, 1163.91064, -987.96582, -55.30000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2141, 1166.03210, -989.78778, -56.73000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2133, 1163.46960, -988.13800, -56.73000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2132, 1164.48206, -988.13800, -56.73000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2133, 1162.46960, -988.13800, -56.73000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2112, 1163.29126, -990.27942, -56.23000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2200, 1162.36133, -993.90161, -56.61000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(2233, 1157.59766, -990.79968, -56.60100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2233, 1157.57178, -987.86023, -56.60100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2123, 1164.00476, -990.26428, -56.00000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(11707, 1164.75452, -994.04071, -55.61000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(11715, 1163.70935, -990.49939, -55.81900, 2.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(11716, 1163.70447, -990.06232, -55.81900, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(11706, 1166.19739, -988.93060, -56.62000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1163.50110, -989.97693, -55.75000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2811, 1161.63245, -987.95898, -56.60000, 0.00000, 0.00000, 178.00000, .streamdistance = 150.00);
	CreateDynamicObject(2847, 1161.18311, -992.14331, -56.61000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(11744, 1163.72485, -990.28107, -55.82010, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2315, 1158.26282, -990.45587, -56.60100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19805, 1157.97314, -989.70227, -55.46100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(3498, 1184.57935, -983.79358, -64.50000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(3498, 1184.57935, -986.43359, -64.50000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2309, 1187.18433, -984.57562, -59.95000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2309, 1187.18433, -985.15558, -59.95000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2309, 1187.18433, -985.73560, -59.95000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(3498, 1177.73010, -990.02441, -61.40000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1727, 1171.75208, -992.23022, -56.63100, 0.00000, 0.00000, -55.00000, .streamdistance = 150.00);
	CreateDynamicObject(2239, 1167.14917, -995.44159, -56.61100, 0.00000, 0.00000, -236.00000, .streamdistance = 150.00);
	CreateDynamicObject(2251, 1171.40710, -985.68951, -55.76100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(2257, 1174.87500, -995.90778, -54.70000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(2283, 1169.27979, -985.37921, -54.71100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2288, 1170.52490, -995.46283, -55.11100, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(2684, 1166.65967, -986.68683, -54.91100, 0.00000, 0.00000, -274.00000, .streamdistance = 150.00);
	CreateDynamicObject(2518, 1176.28723, -993.45721, -60.49100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2525, 1177.62256, -995.07062, -60.71100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(11707, 1175.80554, -993.01331, -59.39100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1491, 1174.85388, -993.59198, -60.75000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2745, 1177.59875, -991.05090, -55.42100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2741, 1177.34326, -993.01410, -59.25100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2742, 1177.96765, -993.90161, -59.25100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2818, 1169.80859, -991.06750, -56.61100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2869, 1166.81506, -988.75061, -55.23100, 0.00000, 0.00000, 53.00000, .streamdistance = 150.00);
	CreateDynamicObject(2870, 1166.71619, -987.93597, -55.24100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(3462, 1174.54785, -978.17700, -59.30000, 0.00000, 0.00000, 142.00000, .streamdistance = 150.00);
	CreateDynamicObject(11726, 1175.94946, -979.91687, -54.51100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(11726, 1183.43738, -980.58484, -54.51100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(11726, 1184.96667, -990.01843, -54.51100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(19806, 1171.11597, -990.21283, -53.81100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(2069, 1167.12744, -985.77112, -56.56100, 0.00000, 0.00000, -280.00000, .streamdistance = 150.00);
	CreateDynamicObject(1744, 1166.47729, -988.86578, -55.56100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(2231, 1184.99695, -984.64819, -58.66000, 90.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1726, 1170.44531, -978.20703, -60.71100, 0.00000, 0.00000, -11.00000, .streamdistance = 150.00);
	CreateDynamicObject(1727, 1172.39612, -980.00763, -60.71100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1173.00037, -981.44080, -58.61100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1817, 1169.29309, -981.37238, -60.70000, 0.00000, 0.00000, -69.00000, .streamdistance = 150.00);
	CreateDynamicObject(1828, 1169.95398, -981.62634, -60.71000, 0.00000, 0.00000, -62.00000, .streamdistance = 150.00);
	CreateDynamicObject(2069, 1166.98169, -977.37164, -60.66000, 0.00000, 0.00000, -11.00000, .streamdistance = 150.00);
	CreateDynamicObject(1726, 1167.80920, -978.97845, -60.71100, 0.00000, 0.00000, 21.00000, .streamdistance = 150.00);
	CreateDynamicObject(1726, 1172.37695, -981.86780, -60.71100, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1726, 1167.29700, -981.87732, -60.71100, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1173.00037, -977.44080, -58.61100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1173.00037, -986.74078, -58.61100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19454, 1166.61560, -996.63623, -56.79100, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1727, 1170.38879, -984.29156, -60.71100, 0.00000, 0.00000, 176.00000, .streamdistance = 150.00);
	CreateDynamicObject(2232, 1170.06042, -996.03271, -59.03100, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(2232, 1168.10034, -996.03271, -59.03100, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(2227, 1168.78259, -996.13928, -60.69100, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(19887, 1209.64722, -957.80298, -60.72000, 0.00000, 0.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(3660, 1189.46875, -977.32349, -58.32100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2847, 1177.19739, -978.12250, -60.70000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2196, 1169.53479, -988.16687, -55.67500, 0.00000, 0.00000, -178.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1177.49634, -995.81171, -54.49500, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1182.56006, -995.81171, -56.49500, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1731, 1185.78821, -995.80560, -58.49500, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1510, 1170.65149, -993.89520, -56.12000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19625, 1170.65967, -993.82159, -56.06620, 33.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1170.12158, -993.98389, -56.06000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1170.12158, -993.86389, -56.06000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1170.12158, -993.74390, -56.06000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1170.12158, -993.62390, -56.06000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19818, 1170.12158, -993.50391, -56.06000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19822, 1170.31995, -993.87683, -56.15000, 0.00000, 0.00000, 55.00000, .streamdistance = 150.00);
	CreateDynamicObject(19824, 1170.31262, -993.71600, -56.14000, 0.00000, 0.00000, 55.00000, .streamdistance = 150.00);
	CreateDynamicObject(1544, 1170.41785, -993.61804, -56.15000, 0.00000, 0.00000, 55.00000, .streamdistance = 150.00);
	CreateDynamicObject(1544, 1170.31226, -993.57379, -56.15000, 0.00000, 0.00000, 55.00000, .streamdistance = 150.00);
	CreateDynamicObject(1510, 1180.35168, -986.35138, -59.91160, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1510, 1179.32898, -985.27966, -59.91160, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1510, 1178.34021, -984.22302, -59.91160, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1510, 1169.99048, -981.65839, -60.18000, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(16151, 1167.69336, -986.64722, -60.38000, 0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1169.85706, -979.03302, -57.25300, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1169.85706, -983.15948, -57.25300, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19325, 1169.85706, -987.28589, -57.25300, 0.00000, 90.00000, 90.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1173.01941, -994.14722, -57.16300, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19377, 1162.51794, -994.14722, -57.16300, 0.00000, 90.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(2332, 1169.29102, -985.77380, -56.14100, 0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(19786, 1187.36304, -985.13251, -57.51000, 0.00000, 0.00000, -90.00000, .streamdistance = 150.00);

	// condemned few
	// exterior - welcome pump
	CreateDynamicObject(19868, 708.92737, -475.36374, 14.96000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19868, 697.83490, -475.44727, 14.96000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19868, 692.66449, -475.44662, 14.96000,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19868, 690.09528, -472.78571, 14.96000,   0.00000, 0.00000, -91.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19868, 677.6180, -445.7639, 14.9600,   0.00000, 0.00000, -91.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19868, 677.7162, -440.5707, 14.9600,   0.00000, 0.00000, -91.00000, .streamdistance = 180.00);
   	CreateDynamicObject(3524, 700.16815, -475.02216, 16.78785,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(3524, 706.56824, -475.02814, 16.78785,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(1362, 659.27527, -500.81583, 15.93662,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(19632, 659.25562, -500.80469, 15.86463,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);
   	CreateDynamicObject(14791, 705.70361, -443.06735, 17.16899,   0.00000, 0.00000, 0.00000, .streamdistance = 180.00);

   	// 18th street cycos
   	//exterior
   	/*CreateDynamicObject(3582, 2030.93884, -1686.98901, 14.93902,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1362, 2040.66895, -1685.00073, 13.20970,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(18689, 2040.72095, -1685.32751, 11.94539,   0.00000, 0.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(1712, 2037.75415, -1684.66528, 12.51489,   0.00000, 0.00000, 82.74000, .streamdistance = 150.00);
	CreateDynamicObject(1712, 2038.69165, -1687.36121, 12.51489,   0.00000, 0.00000, 115.37998, .streamdistance = 150.00);
	CreateDynamicObject(1712, 2025.19885, -1683.32397, 12.51489,   0.00000, 0.00000, 180.06006, .streamdistance = 150.00);
	CreateDynamicObject(3617, 2096.44067, -1632.28882, 15.09399,   0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(3497, 2099.30469, -1641.68555, 14.95750,   0.00000, 0.00000, 180.00000, .streamdistance = 150.00);
	CreateDynamicObject(1368, 2091.91406, -1648.14417, 13.29690,   0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1368, 2091.91406, -1651.50000, 13.29690,   0.00000, 0.00000, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1344, 2101.68530, -1650.79456, 13.24740,   0.00000, -2.24980, -90.00000, .streamdistance = 150.00);
	CreateDynamicObject(1712, 2100.47241, -1652.32898, 12.57730,   0.00000, -2.89260, -116.94003, .streamdistance = 150.00);
	CreateDynamicObject(3120, 2099.46826, -1646.54065, 12.47210,   -113.00000, 20.00000, 0.00000, .streamdistance = 150.00);
	CreateDynamicObject(3594, 2105.94385, -1629.18591, 13.09090,   0.00000, 0.00000, -55.56001, .streamdistance = 150.00);
	CreateDynamicObject(926, 2102.43213, -1628.59290, 12.79827,   0.00000, 0.00000, 33.54000, .streamdistance = 150.00);
	CreateDynamicObject(928, 2105.54541, -1631.67810, 12.75360,   0.00000, 0.00000, 129.06000, .streamdistance = 150.00);
	CreateDynamicObject(1230, 2106.91333, -1626.11133, 12.97019,   0.00000, 0.00000, 18.12000, .streamdistance = 150.00);
	CreateDynamicObject(1764, 2098.42383, -1654.14490, 12.76910,   0.00000, 0.00000, 162.06003, .streamdistance = 150.00);
	CreateDynamicObject(1763, 2100.47803, -1649.53491, 12.52490,   0.00000, 0.00000, 270.95990, .streamdistance = 150.00);
	CreateDynamicObject(1711, 2095.73608, -1652.36292, 12.65178,   0.00000, 0.00000, 107.22000, .streamdistance = 150.00);*/


	for(new i, Float: fPlayerPos[3]; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0)
		{
			GetPlayerPos(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
			CallRemoteFunction("Player_StreamPrep", "ifffi", i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2], 2500);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) TogglePlayerControllable(i, false);
	}
}
