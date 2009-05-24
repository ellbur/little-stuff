
using System;

namespace RoboMagellan {

class GeoTest2 {
	
	public static void Main() {
		
		// This test relies on the fact that in a small region,
		// lat/lon coordinates should be approximately euclidean.
		
		// This means that if
		//
		// (x1, y1) <--> [ lat1, lon1 ]
		// (x2, y2) <--> [ lat2, lon2 ]
		// (x,  y)  <--> [ (1-t)*lat1 + t*lat2, (1-s)*lon1 + t*lon2 ]
		//
		// then x = (1-s)*x1 + s*x2
		//      y = (1-t)*y1 + t*y2
		//
		
		// If this holds down whatever precision we need, then
		// LatLonToLocal should work.
		
		// Near my house.
		double corner1lat = 40.3913361111;
		double corner1lon = 74.7611250000;
		
		// Other side of my house.
		double corner2lat = 40.3915333333;
		double corner2lon = 74.7610083333;
		
		double width;
		double height;
		
		LatLon.LatLonToRect(
			corner1lat,
			corner1lon,
			corner2lat,
			corner2lon,
			
			out width,
			out height );
		
		double xfraction = 0.35;
		double yfraction = 0.78;
		
		double pointlat = (1-yfraction)*corner1lat + yfraction*corner2lat;
		double pointlon = (1-xfraction)*corner1lon + xfraction*corner2lon;
		
		double rectx = xfraction*width;
		double recty = yfraction*height;
		
		double geox;
		double geoy;
		
		LatLon.LatLonToRect(
			corner1lat,
			corner1lon,
			pointlat,
			pointlon,
			
			out geox,
			out geoy );
		
		// rectx and geox should be very close.
		// recty and geoy should be very close.
	
		// Width and Height should be reasonable.
		
		System.Console.WriteLine("Width  = " + width);
		System.Console.WriteLine("Height = " + height);
		System.Console.WriteLine("rectx  = " + rectx);
		System.Console.WriteLine("recty  = " + recty);
		System.Console.WriteLine("geox   = " + geox);
		System.Console.WriteLine("geoy   = " + geoy);
	}
}

}
