
using System;

namespace RoboMagellan {

class LatLon {
	
	// GRS-80
	const double SEMIMAJOR_AXIS = 20925646.3; // feet
	const double SEMIMINOR_AXIS = 20855486.6; // feet
	const double FLATTENING     = 0.003352810681225; // unitless
	
	// For conversion in Vincenty's formula
	const double TOL            = 1e-10;
	
	/*
	 * Get just the rectangular coordinates from
	 * LatLonToLocal()
	 *
	 */
	public static void LatLonToRect(
		double lat1, // degrees
		double lon1, // degrees
		double lat2, // degrees
		double lon2, // degrees
		
		out double x, // feet, + is east
		out double y  // feet, + is north
	)
	{
		double dist;
		double angle;
		
		LatLonToLocal(lat1, lon1, lat2, lon2,
			out dist, out angle, out x, out y);
	}
	
	/*
	 * Get just the polar coordinates from
	 * LatLonToLocal()
	 *
	 */
	public static void LatLonToPolar(
		double lat1, // degrees
		double lon1, // degrees
		double lat2, // degrees
		double lon2, // degrees
		
		out double dist, // feet
		out double angle // radians, 0 = east
	)
	{
		double x;
		double y;
		
		LatLonToLocal(lat1, lon1, lat2, lon2,
			out dist, out angle, out x, out y);
	}
	
	/*
	 * Convert two latitude and longitude coordinates
	 * into local euclidean coordinates.
	 *
	 * Based on Vincenty's formula,
	 * from http://www.movable-type.co.uk/scripts/latlong-vincenty.html
	 *
	 */
	public static void LatLonToLocal(
		
		double lat1, // degrees
		double lon1, // degrees
		double lat2, // degrees
		double lon2, // degrees
		
		out double distance, // feet
		out double heading,  // radians, 0 is east
		out double xdist,    // feet, + is east
		out double ydist     // feet, + is north
	)
	{
		// convert degrees to radians
		lat1 = lat1 * Math.PI / 180;
		lon1 = lon1 * Math.PI / 180;
		lat2 = lat2 * Math.PI / 180;
		lon2 = lon2 * Math.PI / 180;
		
		double a = SEMIMAJOR_AXIS;
		double b = SEMIMINOR_AXIS;
		double f = FLATTENING;
		
		double L = lon2 - lon1;
		
		double u1 = Math.Atan( (1 - FLATTENING) * Math.Tan(lat1) );
		double u2 = Math.Atan( (1 - FLATTENING) * Math.Tan(lat2) );
		
		// This will converge (i hope)
		double est = L;
		
		// To be set in the loop
		double cosqal = 0.0;
		double cos2m  = 0.0;
		double sinsig = 0.0;
		double cossig = 0.0;
		double sig    = 0.0;
		
		// Loop until `est` converges
		//
		for (int iter=0; ; iter++) {
			
			double t1 = Math.Cos(u2) * Math.Sin(est);
			double t2 = Math.Cos(u1)*Math.Sin(u2)
				- Math.Sin(u1)*Math.Cos(u2)*Math.Cos(est);
			
			sinsig = Math.Sqrt( t1*t1 + t2*t2 );
			cossig = Math.Sin(u1)*Math.Sin(u2)
				+ Math.Cos(u1)*Math.Cos(u2)*Math.Cos(est);
			
			sig = Math.Atan2(sinsig, cossig);
			
			double sinal = Math.Cos(u1)*Math.Cos(u2) * Math.Sin(est) / sinsig;
			cosqal = 1 - sinal*sinal;
			
			cos2m = cossig - 2*Math.Sin(u1)*Math.Sin(u2)/cosqal;
			
			double C = f/16 * cosqal * (4 + f*(4 - 3*cosqal));
			double newEst = L + (1 - C)*f*sinal
				* ( sig + C*sinsig*(cos2m + C*cossig*(-1 + 2*cos2m*cos2m)) );
			
			double delta = newEst - est;
			est = newEst;
			
			if (Math.Abs(delta/est) < TOL) {
				break;
			}
			
			if (iter > 1000) {
				System.Console.WriteLine(
					"1000 iters exceeded in LatLonToLocal"
				);
				
				break;
			}
		}
		
		// Now that the loop is finally done, get the numbers
		
		double uu = cosqal * (a*a - b*b) /b/ b; // hehe /b/
		double A = 1 + uu/16384 * ( 4096 + uu*( -768 + uu*(320 - 175*uu) ) );
		double B = uu/1024 * (256 + uu*( -128 + uu*(74 - 47*uu) ) );
		
		// OMFUG
		double deltasig = B * sinsig * (cos2m + B/4*(
			cossig*(-1 + 2*cos2m*cos2m)
				- B/6*cos2m*(-3+4*sinsig*sinsig)*(-3+4*cos2m*cos2m) ));
		
		double s = b*A*(sig - deltasig);
		double h = Math.Atan2(
			Math.Cos(u2)*Math.Sin(est),
			Math.Cos(u1)*Math.Sin(u2)
				- Math.Sin(u1)*Math.Cos(u2)*Math.Cos(est) );
		
		h = Math.PI/2 - h;
		
		double x = s*Math.Cos(h);
		double y = s*Math.Sin(h);
		
		// Outputs
		distance = s;
		heading  = h;
		xdist    = x;
		ydist    = y;
	}
}

}
