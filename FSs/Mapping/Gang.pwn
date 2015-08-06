#include <streamer>

public OnFilterScriptInit()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) TogglePlayerControllable(i, false);
	}
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

	//Hilltop Exterior Updated 9-22-2012
	CreateDynamicObject(987, 1005.81, -285.14, 72.99,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1005.84, -369.05, 72.55,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1039.13, -369.18, 72.73,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1051.19, -369.08, 72.99,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 1033.76, -287.58, 72.99,   0.00, 0.00, 267.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 1115.42, -266.89, 72.09,   0.00, 0.00, 205.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1063.30, -369.28, 72.99,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1075.20, -369.34, 72.99,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1087.12, -369.49, 72.96,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1099.17, -369.50, 72.89,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1110.88, -369.55, 72.92,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.03, -369.67, 72.54,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.07, -357.92, 72.96,   0.00, 0.00, 89.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1122.95, -345.81, 72.99,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.23, -334.09, 73.11,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.50, -322.26, 73.10,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.92, -310.28, 73.09,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8614, 1043.54, -284.77, 75.22,   0.00, 0.00, 181.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.90, -356.95, 72.87,   0.00, 0.00, 266.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.85, -344.97, 72.89,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.46, -333.08, 72.83,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.16, -321.12, 72.85,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.04, -309.13, 72.92,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1005.82, -297.12, 72.98,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1015.86, -278.51, 72.55,   0.00, 0.00, 213.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1027.75, -278.26, 72.43,   0.00, 0.00, 182.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1039.70, -279.17, 72.37,   0.00, 0.00, 176.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1050.90, -279.75, 72.98,   0.00, 0.00, 177.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1057.40, -269.70, 72.60,   0.00, 0.00, 237.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1060.30, -258.10, 72.50,   0.00, 0.00, 256.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1082.10, -253.10, 73.00,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1116.90, -256.80, 71.49,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.90, -266.50, 71.10,   0.00, 0.00, 126.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1121.50, -286.90, 72.80,   0.00, 0.00, 81.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1124.21, -298.33, 73.01,   0.00, 0.00, 104.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1027.07, -369.18, 72.74,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 1012.30, -358.50, 73.00,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3648, 1115.17, -356.06, 75.74,   0.02, 0.02, 358.05, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8572, 1021.05, -284.39, 75.21,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11503, 1095.96, -299.80, 73.11,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3355, 1035.76, -353.37, 72.99,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3356, 1116.49, -337.47, 77.39,   0.00, 0.00, 267.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3802, 1109.84, -353.50, 75.68,   0.00, 0.00, 172.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1105.70, -331.20, 73.62,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1035.76, -346.90, 77.52,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1069.72, -348.83, 75.29,   0.00, 0.00, 181.68, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1736, 1033.72, -346.54, 76.77,   0.00, 0.00, 177.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1255, 1107.86, -333.15, 73.60,   0.00, 0.00, -150.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1095.96, -302.80, 76.25,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1106.49, -303.31, 75.15,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1109.81, -356.86, 75.46,   0.00, 0.00, 268.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1031.28, -314.01, 76.25,   0.00, 0.00, 357.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1101.92, -333.00, 73.60,   0.00, 0.00, 271.21, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1102.80, -332.90, 73.70,   0.00, 0.00, 357.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1080.44, -326.45, 74.70,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1736, 1037.87, -346.60, 76.79,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1016.69, -342.22, 75.18,   0.00, 0.00, 88.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3525, 1082.80, -292.70, 73.50,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1099.86, -298.65, 72.99,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1045.49, -315.50, 78.30,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2725, 1089.23, -298.85, 73.43,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2922, 1013.70, -386.10, 71.90,   0.00, 10.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1009.46, -337.60, 73.50,   0.00, 0.00, 179.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1013.00, -321.00, 73.00,   0.00, 0.00, 91.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1009.05, -321.10, 73.60,   0.00, 0.00, 181.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1019.90, -329.10, 75.20,   0.00, 0.00, 92.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1016.32, -369.27, 76.01,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1028.60, -369.40, 76.01,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3398, 1008.70, -366.90, 75.10,   0.00, 0.00, 150.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3398, 1008.52, -286.26, 75.12,   0.00, 0.00, 48.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3398, 1122.20, -269.10, 75.10,   0.00, 0.00, 297.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3398, 1122.60, -368.97, 75.12,   0.00, 0.00, 225.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(5837, 1015.00, -386.10, 72.30,   0.00, 349.99, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(16326, 1082.96, -324.86, 72.99,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1084.46, -331.03, 72.76,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1118.63, -346.91, 73.43,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1506, 1079.31, -322.16, 72.86,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2063, 1087.97, -316.82, 76.55,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1736, 1079.00, -322.89, 75.87,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3461, 1076.45, -324.66, 73.03,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3461, 1076.44, -321.20, 73.03,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 157.54, 59.16, 468.31,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1086.49, -314.07, 72.76,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1090.41, -314.09, 73.39,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17063, 1035.75, -354.56, 81.80,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2235, 1035.26, -357.05, 81.81,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2063, 1039.78, -350.29, 82.62,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1520, 1035.98, -356.60, 82.32,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1665, 1035.36, -356.56, 82.31,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1846, 1035.96, -359.16, 83.76,   90.00, 90.00, 268.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2229, 1033.99, -360.42, 83.08,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2229, 1037.30, -360.34, 83.08,   0.00, 0.00, 185.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1099.76, -294.77, 73.48,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(6865, 1089.51, -349.05, 82.38,   0.00, 0.00, 226.64, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1045.51, -285.71, 78.35,   0.00, 0.00, 89.97, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1019.36, -285.31, 78.35,   0.00, 0.00, 89.97, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1508, 1045.71, -315.70, 74.20,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3249, 1089.53, -355.86, 72.98,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3525, 1090.55, -346.90, 74.12,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3525, 1088.50, -346.91, 74.12,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1106.85, -312.02, 73.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1087.55, -345.17, 73.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1091.77, -345.33, 73.08,   0.00, 0.00, 2.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1037.76, -344.67, 73.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1034.62, -343.34, 73.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1508, 1031.28, -356.18, 83.53,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2714, 1074.13, -348.79, 75.34,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1089.47, -348.52, 79.18,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11497, 1013.90, -344.00, 73.00,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1087.50, -299.67, 73.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11496, 1035.79, -354.70, 81.67,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11496, 1035.75, -354.70, 81.67,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8615, 1030.83, -361.40, 74.54,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(12950, 1044.59, -354.88, 78.36,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11496, 1034.49, -306.05, 81.42,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11496, 1030.49, -306.02, 81.42,   0.00, 0.00, 179.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8614, 1032.40, -354.23, 83.84,   0.00, 0.00, 87.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 1089.20, -324.71, 76.24,   90.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 1086.40, -324.79, 76.24,   90.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2064, 1087.77, -323.22, 76.23,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2290, 1034.77, -354.20, 81.87,   0.00, 0.00, 358.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1754, 1033.92, -355.79, 81.87,   0.00, 0.00, 44.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2566, 1034.54, -351.35, 82.45,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2004, 1038.19, -348.88, 83.67,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11445, 1032.35, -308.95, 81.62,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3066, 1032.21, -299.80, 82.50,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8613, 1021.84, -304.56, 78.04,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8614, 1027.62, -294.60, 74.47,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1083.71, -299.53, 73.10,   0.00, 0.00, 37.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1109.40, -341.20, 73.64,   0.00, 0.00, 357.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(13360, 1087.84, -295.21, 74.93,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(12937, 1090.31, -292.09, 75.91,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(16285, 1032.79, -310.43, 72.99,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3525, 1091.30, -295.60, 73.60,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3403, 1065.52, -355.40, 80.00,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1025.70, -360.60, 73.10,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1020.40, -361.10, 73.10,   0.00, 0.00, 348.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1045.53, -315.58, 78.00,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(16285, 1114.00, -318.50, 73.00,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1106.42, -343.03, 73.58,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1028.80, -368.00, 73.80,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 1022.80, -315.18, 73.50,   90.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(964, 1016.00, -315.22, 73.50,   90.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11501, 1014.22, -327.20, 73.00,   0.00, 0.00, 91.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1016.90, -359.10, 73.80,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1027.90, -360.30, 73.80,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1033.70, -364.60, 77.20,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3415, 1096.27, -332.81, 73.00,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1764, 1098.60, -331.50, 73.00,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2207, 1094.90, -333.60, 73.00,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1765, 1095.70, -331.40, 73.00,   0.00, 0.00, 308.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1765, 1096.30, -333.20, 73.00,   0.00, 0.00, 240.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1765, 1092.80, -333.05, 73.00,   0.00, 0.00, 88.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1093.90, -334.90, 75.10,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1015.91, -367.10, 73.84,   0.00, 0.30, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1010.40, -367.10, 73.87,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1017.41, -341.10, 75.20,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1037.40, -364.50, 77.30,   0.00, 0.00, 360.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1108.70, -331.20, 73.70,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1107.20, -360.18, 73.60,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3532, 1106.92, -349.69, 73.60,   0.00, 0.00, 91.26, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1255, 1107.41, -357.57, 73.60,   0.00, 0.00, 179.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1114.74, -346.77, 72.90,   0.00, 0.00, 89.16, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1107.28, -315.76, 75.18,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1550, 1038.80, -349.30, 82.30,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2345, 1110.80, -337.50, 76.37,   0.00, 0.00, 266.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2345, 1110.80, -335.80, 76.37,   0.00, 0.00, 268.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2345, 1111.00, -333.60, 76.32,   0.00, 0.00, 268.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2345, 1110.90, -331.40, 76.35,   0.00, 0.00, 268.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3785, 1114.07, -335.60, 75.40,   0.00, 0.00, 198.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(16011, 1072.30, -353.90, 73.50,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1070.40, -251.80, 72.70,   0.00, 0.00, 211.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1094.00, -254.30, 73.30,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1105.10, -255.50, 72.60,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1122.40, -278.30, 71.60,   0.00, 0.00, 81.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 1068.80, -260.50, 72.80,   0.00, 0.00, 317.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3283, 1061.00, -274.50, 72.80,   0.00, 0.00, 152.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3285, 1114.10, -278.10, 74.60,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3362, 1104.14, -259.68, 72.40,   0.00, 0.00, 242.47, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3171, 1087.40, -263.00, 74.00,   0.00, 0.00, 66.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3167, 1077.80, -260.80, 73.50,   0.00, 0.00, 204.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3168, 1090.40, -274.80, 73.50,   4.00, 0.00, 16.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3175, 1081.40, -280.30, 72.80,   0.00, 0.00, 266.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3174, 1097.05, -265.65, 73.70,   0.00, 0.00, 65.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3173, 1102.80, -287.30, 73.00,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1116.90, -256.80, 76.30,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1105.10, -255.50, 77.50,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1094.00, -254.30, 78.10,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1082.10, -253.10, 77.80,   0.00, 0.00, 174.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1070.40, -251.80, 77.70,   0.00, 0.00, 211.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1060.30, -258.10, 77.30,   0.00, 0.00, 255.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1057.40, -269.70, 77.40,   0.00, 0.00, 237.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1050.90, -279.70, 77.70,   0.00, 0.00, 177.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1039.70, -279.20, 77.30,   0.00, 0.00, 176.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1027.80, -278.30, 77.20,   0.00, 0.00, 182.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1015.90, -278.50, 77.10,   0.00, 0.00, 213.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1005.80, -285.10, 77.70,   0.00, 0.00, 269.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1005.80, -297.10, 78.00,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.00, -309.10, 77.70,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.20, -321.10, 77.60,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.50, -333.10, 77.60,   0.00, 0.00, 272.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.90, -345.00, 77.40,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1006.90, -357.00, 77.60,   0.00, 0.00, 266.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1005.84, -369.05, 77.50,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1027.10, -369.20, 77.60,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1039.10, -369.20, 77.70,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1063.30, -369.30, 77.70,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1051.20, -369.10, 77.70,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1075.20, -369.30, 77.70,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1099.20, -369.50, 77.60,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1087.10, -369.50, 77.70,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1110.90, -369.50, 77.40,   0.00, 0.00, 359.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.10, -357.90, 77.70,   0.00, 0.00, 89.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.00, -369.70, 77.40,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.00, -345.80, 77.70,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.90, -266.50, 75.90,   0.00, 0.00, 126.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1122.40, -278.30, 76.40,   0.00, 0.00, 81.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1121.50, -286.90, 77.60,   0.00, 0.00, 81.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1124.20, -298.30, 77.80,   0.00, 0.00, 104.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.90, -310.30, 77.90,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.50, -322.30, 77.90,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(987, 1123.20, -334.10, 77.90,   0.00, 0.00, 87.98, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1100.88, -262.34, 73.34,   0.00, 0.00, 347.47, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1084.70, -264.80, 74.08,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1100.00, -272.20, 73.78,   0.00, 0.00, 348.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11503, 1096.50, -320.50, 73.10,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1052.54, -346.43, 73.10,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1055.49, -346.66, 73.10,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8615, 1043.21, -348.21, 74.30,   0.00, 0.00, 178.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(12957, 1106.40, -269.10, 73.70,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3594, 1085.30, -256.90, 74.70,   0.00, 0.00, 82.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10832, 1060.70, -311.30, 71.60,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3934, 1060.54, -311.40, 73.30,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10832, 1060.60, -301.60, 71.60,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10832, 1060.40, -291.40, 71.60,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3934, 1060.40, -301.70, 73.30,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3934, 1060.40, -291.50, 73.30,   0.00, 0.00, 179.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11455, 1019.40, -315.20, 77.57,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1018.17, -315.25, 78.20,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1017.34, -315.23, 71.80,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1021.05, -315.23, 71.79,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1017.90, -315.25, 78.20,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3279, 1099.01, -362.14, 73.00,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1358, 1097.93, -257.54, 74.50,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1369, 1018.73, -323.99, 74.10,   0.00, 0.00, 65.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(14638, 1090.58, -363.26, 73.00,   0.00, 4.44, 91.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1033.80, -367.90, 73.72,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1049.36, -367.30, 73.80,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(8615, 1059.44, -352.57, 75.50,   0.00, 0.00, 270.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1062.99, -366.85, 73.86,   0.00, 0.00, 360.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1075.53, -358.11, 78.00,   0.00, 0.00, 360.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3403, 1032.10, -309.00, 84.66,   0.00, 0.00, 3.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3403, 1078.42, -354.55, 79.99,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(944, 1080.13, -357.99, 78.00,   0.00, 0.00, 360.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11445, 1066.28, -357.72, 77.01,   0.00, 0.00, 162.88, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1107.40, -348.79, 73.51,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3250, 1105.01, -321.34, 72.94,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3250, 1108.51, -297.73, 73.04,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19315, 1104.76, -359.21, 73.47,   0.00, 0.00, 55.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19315, 1104.05, -332.52, 73.47,   0.00, 0.00, -145.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1736, 1086.85, -295.49, 75.67,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1090.08, -295.36, 75.55,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1052.88, -350.94, 78.01,   0.00, 0.00, 181.68, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(11503, 1119.71, -297.50, 73.11,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1079.90, -272.30, 73.64,   0.00, 0.00, 348.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19317, 1102.18, -261.22, 73.79,   0.00, 0.00, -25.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19173, 1036.11, -348.92, 84.25,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19170, 1032.93, -360.20, 83.99,   270.00, 90.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19171, 1039.07, -360.20, 83.78,   270.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1508, 1094.16, -355.16, 74.20,   0.00, 0.00, 0.77, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2672, 1103.38, -266.68, 73.55,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1765, 1090.25, -298.15, 72.99,   0.00, 0.00, 310.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1767, 1105.13, -264.45, 72.80,   0.00, 0.00, -65.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1137.14, -197.37, 40.79,   0.00, 0.00, 14.42, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1136.11, -193.56, 41.34,   0.00, 0.00, 104.41, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1493, 1034.99, -361.75, 73.40,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1017.34, -315.23, 74.50,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2395, 1021.05, -315.23, 74.50,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2878, 1018.73, -315.17, 74.12,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(18368, 1128.53, -215.83, 50.72,   0.00, 0.00, 100.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19314, 1019.55, -343.36, 75.87,   90.00, 90.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1506, 1114.26, -335.23, 73.57,   0.00, 0.00, 89.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(13360, 1045.46, -285.66, 77.52,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(13360, 1019.26, -285.25, 77.52,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1052.98, -309.31, 70.46,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1045.68, -285.72, 70.95,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1018.16, -285.40, 70.57,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1038.19, -291.51, 70.42,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1011.99, -291.90, 70.43,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2415, 1118.04, -344.00, 77.10,   0.00, 0.00, 0.47, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19375, 1026.81, -308.67, 70.42,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1106.49, -330.02, 73.51,   3.14, 0.00, 0.02, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1110.40, -351.51, 73.60,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1104.84, -330.01, 73.51,   0.00, 0.00, 178.21, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1104.31, -358.75, 73.60,   0.00, 0.00, 269.57, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1104.36, -351.30, 73.60,   0.00, 0.00, 269.57, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1107.18, -361.38, 73.60,   0.00, 0.00, 359.30, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1109.98, -343.63, 73.60,   0.00, 0.00, 0.94, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1408, 1104.56, -343.70, 73.60,   0.00, 0.00, 0.94, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1110.48, -341.40, 78.35,   0.00, 0.00, 268.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3802, 1113.59, -331.63, 75.38,   0.00, 0.00, 172.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1369, 1024.20, -316.00, 73.60,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2833, 1114.17, -334.94, 73.58,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1759, 1113.33, -336.75, 73.54,   0.00, 0.00, 267.43, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(17036, 1013.40, -337.63, 72.90,   0.00, 0.00, 89.99, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(10150, 1088.37, -331.08, 73.39,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2100, 1104.77, -262.69, 72.87,   0.00, 0.00, -25.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19314, 1035.75, -346.85, 76.18,   90.00, 90.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1481, 1144.81, -211.40, 55.86,   0.00, 0.00, 304.91, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1810, 1142.29, -214.97, 55.18,   0.00, 0.00, -180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1810, 1144.20, -213.72, 55.18,   0.00, 0.00, -100.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1810, 1140.68, -213.62, 55.18,   0.00, 0.00, 126.07, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(933, 1142.41, -213.16, 55.13,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3927, 1038.92, -443.56, 52.57,   0.00, 0.00, 15.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1038.74, -443.67, 53.38,   0.00, 0.00, 15.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3927, 1146.27, -219.78, 57.30,   0.00, 0.00, 40.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1146.08, -219.86, 58.15,   0.00, 0.12, -140.03, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3927, 1013.04, -453.61, 52.57,   0.00, 0.00, 15.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1012.84, -453.72, 53.38,   0.00, 0.00, 15.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2146, 1013.60, -315.86, 73.47,   0.00, 0.00, 92.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1800, 1032.73, -365.87, 73.28,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3525, 1017.70, -327.18, 74.21,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2673, 1139.88, -210.56, 55.26,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2670, 1146.72, -215.81, 55.29,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(1736, 1017.93, -325.19, 74.87,   0.00, 0.00, 91.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(19315, 1021.08, -327.75, 73.52,   0.00, 0.00, 33.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 999.49, -128.95, 0.35,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 1009.75, -129.39, 0.35,   0.00, 0.00, 85.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 989.31, -128.94, 2.57,   25.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 979.71, -128.94, 4.70,   0.00, 0.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 977.70, -136.17, 4.66,   0.00, 0.00, 180.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3927, 979.81, -130.85, 7.49,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 979.60, -130.93, 8.34,   0.00, 0.00, 0.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(994, 1018.28, -372.37, 73.03,   0.00, -5.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(994, 1018.28, -378.61, 72.43,   0.00, -7.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(994, 1027.58, -372.54, 73.03,   0.00, -7.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(994, 1027.55, -378.76, 72.27,   0.00, -8.20, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(994, 1027.56, -384.97, 71.15,   0.00, -13.00, 90.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3927, 1136.31, -193.50, 44.80,   0.00, 0.00, 14.42, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(2048, 1136.10, -193.48, 45.63,   0.00, 0.00, 194.42, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3886, 1020.18, -130.31, 0.35,   0.00, 0.00, 85.00, .worldid = 0, .streamdistance = 150);
	CreateDynamicObject(3174, 1116.68, -287.56, 72.90,   -4.00, 0.00, -25.00, .worldid = 0, .streamdistance = 150);

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
	
	//Grove Street Families
		// exterior
	CreateDynamicObject(1670, 2433.73096, -1646.81104, 13.33680,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1737, 2433.73608, -1646.62830, 12.52370,   0.00000, 0.00000, 229.00000);
	CreateDynamicObject(1950, 2433.67749, -1646.34351, 13.50790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2358, 2433.66040, -1646.79028, 12.58987,   0.00000, 0.00000, -40.19996);
	CreateDynamicObject(2062, 2436.02319, -1647.97937, 12.74186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(336, 2435.30298, -1647.94202, 12.74060,   -0.78000, 24.60000, 0.00000);
	CreateDynamicObject(1481, 2432.52173, -1643.02271, 12.97917,   0.00000, 0.00000, 45.17990);
	CreateDynamicObject(19897, 2434.01245, -1646.41528, 13.33510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1810, 2435.10547, -1647.20496, 12.48860,   0.00000, 0.00000, -109.62000);
	CreateDynamicObject(1810, 2432.49390, -1645.86255, 12.48859,   0.00000, 0.00000, 75.66000);
	CreateDynamicObject(1810, 2433.26782, -1645.17114, 12.48860,   0.00000, 0.00000, 24.84000);
	CreateDynamicObject(1810, 2434.18701, -1645.10400, 12.48860,   0.00000, 0.00000, -6.54000);
	CreateDynamicObject(1810, 2434.75586, -1645.39124, 12.48860,   0.00000, 0.00000, -20.28000);
	CreateDynamicObject(1810, 2435.17920, -1646.24841, 12.48860,   0.00000, 0.00000, -75.12001);
	CreateDynamicObject(2059, 2433.71094, -1646.61816, 13.33750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19823, 2433.15894, -1647.40137, 13.32030,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1712, 2433.76074, -1642.35046, 12.47352,   0.00000, 0.00000, 11.03999);
	CreateDynamicObject(1462, 2436.00684, -1639.77380, 12.42949,   114.54007, 186.47990, -179.64000);
	CreateDynamicObject(3027, 2432.85645, -1647.64856, 13.33650,   -87.50000, -15.18000, 0.00000);
		

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
	
	//Il Riccitelli Cerberus
		//Exterior
	CreateDynamicObject(3515, 489.56006, -1792.78357, 5.06412, 0.00000, 0.00000, -4.86000);
	CreateDynamicObject(11319, 378.96191, -1879.23267, 3.39850, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3462, 489.60229, -1792.77954, 7.41748, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(17068, 417.66168, -1905.56396, 0.13101, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 415.90399, -1778.57458, 5.75414, 0.00000, 0.00000, -89.10002);
	CreateDynamicObject(1256, 409.76971, -1778.49402, 5.13447, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(984, 384.60928, -1780.63184, 5.24046, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 397.39999, -1780.63184, 5.24050, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(984, 410.20001, -1780.63184, 5.24050, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 419.78729, -1780.61597, 5.28377, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(966, 431.20361, -1780.95715, 4.47468, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(967, 433.30981, -1781.65979, 4.52884, 0.00000, 0.00000, -271.31985);
	CreateDynamicObject(1256, 403.76971, -1778.49402, 5.17475, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1280, 491.19962, -1789.73572, 5.43750, 3.14159, 0.00000, -31.55456);
	CreateDynamicObject(1280, 487.95212, -1789.61792, 5.43750, 3.14159, 0.00000, -138.29454); 
		//Interior
	CreateDynamicObject(14592, 2205.22192, 1597.22156, 2000.88489, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2000, 12163.09668, 2453.80811, 2311.48145, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19817, 2206.77588, 1614.50000, 1993.59998, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(4012, 2226.99463, 1623.46704, 1994.08984, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19817, 2206.79297, 1610.89001, 1993.59998, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19815, 2208.63892, 1607.02197, 1996.02612, 0.00000, 0.00000, -180.00000);
	CreateDynamicObject(19815, 2208.63892, 1618.19861, 1995.63550, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19810, 2195.01636, 1616.31116, 1995.97339, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19898, 2206.13281, 1613.24451, 1993.99902, 0.00000, 0.00000, 33.17999);
	CreateDynamicObject(19899, 2205.52881, 1617.66052, 1993.99036, 0.00000, 0.00000, -90.06000);
	CreateDynamicObject(19899, 2205.52881, 1607.51501, 1993.99438, 0.00000, 0.00000, 90.06000);
	CreateDynamicObject(1516, 2196.25732, 1607.92859, 1994.18640, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19835, 2196.70288, 1608.20068, 1994.80762, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1810, 2196.24585, 1609.05005, 1993.98022, 0.00000, 0.00000, 102.60007);
	CreateDynamicObject(1810, 2196.99219, 1608.06311, 1993.98975, 0.00000, 0.00000, 178.56000);
	CreateDynamicObject(19898, 2208.86157, 1617.03235, 1994.03857, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19898, 2208.37134, 1614.81042, 1994.03857, 0.00000, 0.00000, -30.30002);
	CreateDynamicObject(19898, 2210.27588, 1615.35254, 1994.03857, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19898, 2209.64868, 1609.88831, 1994.03857, 0.00000, 0.00000, 211.91997);
	CreateDynamicObject(19898, 2208.84692, 1611.48364, 1994.03857, 0.00000, 0.00000, 211.91997);
	CreateDynamicObject(19898, 2209.05396, 1613.26306, 1994.03857, 0.00000, 0.00000, 326.75998);
	CreateDynamicObject(19898, 2206.29810, 1611.29919, 1994.03857, 0.00000, 0.00000, 139.19998);
	CreateDynamicObject(19898, 2207.83472, 1609.26123, 1994.03857, 0.00000, 0.00000, 295.07999);
	CreateDynamicObject(19898, 2210.28467, 1607.56555, 1994.03857, 0.00000, 0.00000, 394.62000);
	CreateDynamicObject(19631, 2204.09180, 1607.47644, 1994.06091, -4.00000, 11.00000, 4.00000);
	CreateDynamicObject(1617, 2183.28125, 1624.81421, 1997.76477, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1362, 2213.66895, 1607.62231, 1994.56030, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11390, 2204.78931, 1612.56702, 1998.57361, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2714, 2194.97388, 1608.97144, 1997.54456, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1808, 2194.79272, 1609.13977, 1993.95837, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(16780, 2201.37988, 1614.48840, 1998.92334, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16780, 2201.37988, 1610.52942, 1998.92334, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8957, 2214.13696, 1612.65942, 1995.46729, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2010, 2187.12573, 1599.74268, 1993.95386, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2010, 2184.31055, 1599.72607, 1993.95386, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2103, 2204.87256, 1607.54651, 1995.23059, 0.00000, 0.00000, 154.19998);
	CreateDynamicObject(1368, 2194.43164, 1607.12280, 1994.63257, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3017, 2205.93213, 1617.40820, 1995.24695, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1270, 2149.56714, 1603.47998, 1994.73267, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19621, 206.40089, 1617.84204, 1995.40259, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19835, 2196.51733, 1608.11841, 1994.80762, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19835, 2196.66895, 1607.95056, 1994.80762, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2663, 2196.01294, 1607.54419, 1994.91467, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2839, 2196.37280, 1608.05615, 1994.72119, 0.00000, 0.00000, -225.47995);
	CreateDynamicObject(2894, 2204.71436, 1617.50574, 1995.23523, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1616, 2194.68359, 1616.65649, 1998.56897, 0.00000, 0.00000, 30.78003);
	CreateDynamicObject(1616, 2194.68359, 1616.65649, 1998.56897, 0.00000, 0.00000, 30.78003);
	CreateDynamicObject(4697, 2173.65674, 1627.15540, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4697, 217.59641, 1626.73706, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4697, 2173.65674, 1623.15540, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4697, 2173.65674, 1619.15540, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4697, 2173.65674, 1615.15540, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4697, 2173.65674, 1611.15540, 1993.95313, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19897, 2205.29883, 1617.25623, 1995.29321, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19900, 2203.80127, 1617.76672, 1993.99438, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2040, 2204.92383, 1617.57520, 1995.71033, 0.00000, 0.00000, 61.62000);
	CreateDynamicObject(2040, 2204.52539, 1617.61377, 1995.73755, 0.00000, 0.00000, 157.55998);
	CreateDynamicObject(2855, 2203.74487, 1617.73059, 1994.83252, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1216, 2194.73511, 1604.55872, 1994.58362, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1216, 2194.73511, 1603.55872, 1994.58362, 0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1428, 2202.92871, 1617.82935, 1995.38550, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(910, 2196.52563, 1617.68567, 1995.22974, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19815, 2208.63892, 1607.06006, 1995.63550, 0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1327, 2213.78613, 1617.10449, 1994.63110, 0.00000, 18.00000, 0.00000);
	CreateDynamicObject(11393, 2200.18896, 1607.26477, 1995.26355, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19579, 2196.17676, 1617.65894, 1994.21484, 0.00000, 0.00000, 35.45999);
	CreateDynamicObject(10281, 2176.91089, 1611.67786, 1996.19531, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2964, 2201.72290, 190.84790, 1993.92493, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1663, 2185.77368, 1592.83777, 1994.39063, 0.00000, 0.00000, -180.00000);
	CreateDynamicObject(19624, 2186.87134, 1593.97241, 1994.36438, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1616, 2187.55347, 1593.09900, 1998.58740, 0.00000, 0.00000, -15.60000);
	CreateDynamicObject(2597, 2183.90649, 1598.49146, 1994.81433, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2894, 2186.09863, 1593.74756, 1994.77991, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1892, 2185.16748, 1598.78064, 1993.95825, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7021, 2194.62671, 1588.38110, 1993.96033, 90.00000, 0.00000, 180.00000);
	CreateDynamicObject(2185, 2186.53418, 1593.90784, 1993.96802, 0.00000, 0.00000, -180.00000);
	CreateDynamicObject(2689, 2184.16650, 1598.52698, 1995.19751, 0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1721, 2186.40845, 1595.51282, 1993.96851, 0.00000, 0.00000, -180.00000);
	CreateDynamicObject(1721, 2184.98828, 1595.48511, 1993.96851, 0.00000, 0.00000, -180.00000);
	CreateDynamicObject(638, 2187.61133, 1597.63440, 1994.60938, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3810, 2183.83179, 1597.49243, 1997.59863, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2205.63232, 1607.81421, 1995.54663, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2057, 2206.43921, 1607.68420, 1996.24268, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1008, 2205.86182, 1617.70862, 1996.07825, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(335, 2206.43335, 1607.79993, 1995.22314, 90.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2206.16113, 1607.64185, 1995.24609, 0.00000, 0.00000, -43.73998);
	CreateDynamicObject(365, 2206.60791, 1607.57629, 1995.77307, 0.00000, -6.00000, -273.41989);
	CreateDynamicObject(365, 2206.60791, 1607.57629, 1995.77307, 0.00000, -6.00000, -273.41989);
	CreateDynamicObject(365, 2206.47900, 1607.57629, 1995.77307, 0.00000, -6.00000, -273.41989);
	CreateDynamicObject(365, 2206.36792, 1607.57629, 1995.77307, 0.00000, -6.00000, -273.41989);
	CreateDynamicObject(371, 2205.48853, 1607.58813, 1996.13586, -90.00000, 0.00000, 108.90000);

	// sons of saints
		// exterior
	CreateDynamicObject(9833, 1777.09998, -1353.90002, 17.50000,   0.00000, 0.00000, 354.25000);
	CreateDynamicObject(638, 1778.90002, -1354.00000, 15.50000,   0.00000, 0.00000, 0.25000);
	CreateDynamicObject(638, 1777.09998, -1352.30005, 15.50000,   0.00000, 0.00000, 90.24700);
	CreateDynamicObject(638, 1775.40002, -1354.00000, 15.50000,   0.00000, 0.00000, 180.24001);
	CreateDynamicObject(638, 1777.19995, -1355.69995, 15.50000,   0.00000, 0.00000, 90.24700);
	CreateDynamicObject(1532, 1791.59998, -1342.00000, 14.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3115, 1751.20020, -1329.29980, 28.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3934, 1804.50000, -1330.59998, 29.20000,   0.00000, 0.00000, 0.25000);
	CreateDynamicObject(3934, 1751.59998, -1328.90002, 29.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16096, 1785.00000, -1320.90002, 30.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4100, 1806.09998, -1338.19995, 16.00000,   0.00000, 0.00000, 50.00000);
	CreateDynamicObject(4100, 1806.09998, -1356.80005, 16.00000,   0.00000, 0.00000, 49.99800);
	CreateDynamicObject(2412, 1805.59998, -1349.80005, 14.20000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2412, 1805.40002, -1347.50000, 14.20000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2412, 1805.59998, -1345.19995, 14.30000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2921, 1765.40002, -1358.80005, 19.60000,   0.00000, 10.00000, 236.00000);
	CreateDynamicObject(3115, 1803.90002, -1331.09998, 28.90000,   0.00000, 0.00000, 0.00000);

		// interior

	

	
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