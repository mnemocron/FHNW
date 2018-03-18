package pro2e.teamX.matlabfunctions;

public class MyMath {
	
	public static double abs(double real, double imag) {
		return Math.sqrt(Math.pow(real, 2) + Math.pow(imag, 2));
	}
	
	public static double[] abs(double[] real, double[] imag) {
		double result[] = new double[real.length]; 		// todo: oder imag.length
		int endofa=real.length;
		if(imag.length < endofa)
			endofa = imag.length;
		for(int ii=0; ii<endofa; ii++) {
			result[ii] = abs(real[ii], imag[ii]);
		}
		return result;
	}
	
	public static double sum(double[] a) {
		double sum = 0.0;
		for(int ii=0; ii<a.length; ii++) {
			sum += a[ii];
		}
		return sum;
	}
	
	public static double max(double[] a) {
		double max = 0.0;
		for(int ii=0; ii<a.length; ii++) {
			if(a[ii] > max) {
				max=a[ii];
			}
		}
		return max;
	}
	
	public static double[] normiert(double[] a) {
		double max = max(a);
		for(int ii=0; ii<a.length; ii++) {
			a[ii] /= max;
		}
		return a;
	}
	
	public static double[] db20(double[] a) {
		for(int ii=0; ii<a.length; ii++) {
			a[ii] = 20*Math.log10(a[ii]);
		}
		return a;
	}
	
	public static double[] antennaTest(double[] phideg, int nant, double d_L) {
		double[] intensity 	= new double[phideg.length];
		double[] real 		= new double[phideg.length];
		double[] imag 		= new double[phideg.length];
		
		for(int ii=0; ii<phideg.length; ii++) {
			for(int kk=0; kk<nant; kk++) {
				double phase = d_L*2*Math.PI*Math.cos(Math.toRadians((phideg[ii])))*(kk);
				real[kk]=Math.cos(phase);
		        imag[kk]=Math.sin(phase);
			}
			double zeigerReal = sum(real);
			double zeigerImag = sum(imag);
			intensity[ii] = abs(zeigerReal, zeigerImag);
		}
		intensity=db20(normiert(intensity));
		
		return intensity;
	}
}
