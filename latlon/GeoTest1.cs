
using System;

namespace RoboMagellan {

class GeoTest1 {
	
	public static void Main() {
		
		// This is the test case provided at 
		// http://en.wikipedia.org/wiki/Vincenty%27s_formulae
		
		// 37°57′03.72030″S
		double lat1 =  -37.9510334167;
		
		// 144°25′29.52440″E
		double lon1 = -144.4248678889;
		
		// 37°39′10.15610″S
		double lat2 =  -37.6528211389;
		
		// 143°55′35.38390″E
		double lon2 = -143.9264955278;
		
		double dist;
		double heading;
		double x;
		double y;
		
		LatLon.LatLonToLocal(
			lat1, lon1,
			lat2, lon2,
			out dist,
			out heading,
			out x,
			out y );
		
		// The distance should be
		// 180355.22 feet = 54972.271 meters
		System.Console.WriteLine(dist);
		
		// The heading should be 
		// 5.3558597324 radians = 306°52′05.37″
		System.Console.WriteLine(heading);
	}
}

}
