package jxy3d_test;

import java.awt.BorderLayout;
import java.awt.Canvas;
import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JPanel;

import org.jzy3d.chart.Chart;
import org.jzy3d.chart.controllers.mouse.camera.AWTCameraMouseController;
import org.jzy3d.chart.factories.AWTChartComponentFactory;
import org.jzy3d.colors.Color;
import org.jzy3d.colors.ColorMapper;
import org.jzy3d.colors.colormaps.ColorMapRainbow;
import org.jzy3d.maths.Coord3d;
import org.jzy3d.maths.Range;
import org.jzy3d.plot3d.builder.Builder;
import org.jzy3d.plot3d.builder.Mapper;
import org.jzy3d.plot3d.builder.concrete.OrthonormalGrid;
import org.jzy3d.plot3d.primitives.Shape;
import org.jzy3d.plot3d.rendering.canvas.Quality;

public class SwingFrame {

	public static void main(String[] args) {
		JFrame frame = new JFrame("3D Surface Plot | Swing JFrame");
		frame.setBounds(100, 100, 640, 640);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
		
	 	Mapper mapper = new Mapper() {
            @Override
            public double f(double x, double y) {
                // return x * y;
            	return x * Math.sin(x * y);
            	// return Math.sin(Math.sin(y))*(Math.cos((Math.PI/2)*Math.cos(x)*Math.cos(y)))/(Math.sqrt(1-Math.pow(Math.cos(x),2)*Math.pow(Math.cos(y),2)));
            	// return Math.exp(-0.5*Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)))*Math.cos(5*Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
            	
            	/*
            	double l_lamda1=1/100; // length of antenna in terms of wavelengths
            	double I0=1; // max current in antenna structure
            	double n=120*Math.PI; //eta
            	return ( n*( Math.pow(I0,2) )
            			*(Math.pow(( ( Math.cos(l_lamda1*Math.cos(x-(Math.PI/2))/2) - Math.cos(l_lamda1/2) )/ Math.sin(x-(Math.PI/2)) ), 2)  )
            			/(8*Math.pow(Math.PI,2)));*/

            }
        };

        // Define range and precision for the function to plot
        Range range = new Range(-5, 5);
        int steps = 80;

        // Create the object to represent the function over the given range.
        final Shape surface = Builder.buildOrthonormal(new OrthonormalGrid(range, steps, range, steps), mapper);
        surface.setColorMapper(new ColorMapper(new ColorMapRainbow(), surface.getBounds().getZmin(), surface.getBounds().getZmax(), new Color(1, 1, 1, 1.0f)));
        surface.setFaceDisplayed(true);
        surface.setWireframeDisplayed(false);

        // Create a chart
        Chart chart = AWTChartComponentFactory.chart(Quality.Advanced);
        chart.getScene().getGraph().add(surface);

        // make mouse move the chart
        chart.addController(new AWTCameraMouseController());

        // customize colors
        //chart.getAxeLayout().setMainColor(Color.WHITE);
        //chart.getView().setBackgroundColor(Color.BLACK);
       
        // create jPanel and add chart onto it
        JPanel panel = new JPanel();
        panel.setLayout(new BorderLayout());
        panel.setOpaque(false);
        panel.setPreferredSize(new Dimension(300,300));
        panel.add((Canvas)chart.getCanvas());

        // add jPanel to jFrame
        frame.add(panel);
        frame.setVisible(true);
	}
}
