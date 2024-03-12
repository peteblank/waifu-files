/*************************************************
 Parametric two-part mold generator
 Author: Jason Webb
 Website: http://jason-webb.info

 A parametric two-part mold generator that constructs two-
 part molds with registration marks based on STL files.

*************************************************/
// Model parameters
model_filename = "Sample inputs/sample-input.stl";
model_rotate = [0,0,0];
model_translate = [0,0,-10];
model_scale = 1;

// Mold parameters
mold_width = 60;			// Measured along X axis
mold_height = 60;			// Measured along Y axis
mold_depth = 35;			// Measured along Z axis
mold_spacing = 10;			// Space between mold halves
rounded_corners = true;		// Rounded the corners to lessen warping
edge_radius = 8;			// Radius of rounded corners

// Key parameters (registration marks)
key_size = 3;		// Radius of spherical keys
key_fettle = 0.4;		// Size difference between keys and corresponding holes
key_margin = 7;	// Distance from outside edge of mold

// Pour hole parameters
pour_hole_r1 = 10;			// First radius of cylindrical pour hole
pour_hole_r2 = 3;			// Second radius (make r2 < r1 to make a funnel)
pour_hole_height = 16;		// Height of the pour hole
pour_hole_translate = [0, 0, -mold_depth/2];
pour_hole_rotate = [0, 0, ];

side_by_side();

/****************************************
 Rotate and place both halves side by side 
 along the X axis for easy single-plate printing
*****************************************/
module side_by_side() {
	// Scoot the left half over a bit
	translate([mold_width/2 + mold_spacing/2, 0, mold_depth/2])
		bottom_half();
		
	// Rotate the top half, then scoot it over a bit
	translate([-mold_width/2 - mold_spacing/2, 0, mold_depth*3/2])
		rotate([0, 180, 0])
			top_half();	
}

/*******************************************
 Bottom half of the mold
********************************************/
module bottom_half() {
	// Create the mold form with negative keys
	difference() {

		// Create the basic mold form by subtracting the STL from a cube half it's size
		difference() {
			if(rounded_corners) 
				roundedBox([mold_width, mold_height, mold_depth], edge_radius, true);
			else
				cube(size = [mold_width, mold_height, mold_depth], center = true);

			scale(model_scale)
				translate(model_translate)
					rotate(model_rotate)
						import(model_filename);
		}

		// Negative key 1
		translate([-mold_width/2 + key_margin, -mold_height/2 + key_margin, mold_depth/2])
			sphere(key_size + key_fettle, $fn = 30);

		// Negative key 2
		translate([mold_width/2 - key_margin, mold_height/2 - key_margin, mold_depth/2])
			sphere(key_size + key_fettle, $fn = 30);

		// Pour hole
		translate(pour_hole_translate)
			rotate(pour_hole_rotate)
				cylinder(pour_hole_height, pour_hole_r1, pour_hole_r2);
	}

	// Positive key 1
	translate(v = [-mold_width/2 + key_margin, mold_height/2 - key_margin, mold_depth/2])
		sphere(r = key_size, $fn = 30);

	// Positive master key
	translate(v = [mold_width/2 - key_margin, -mold_height/2 + key_margin, mold_depth/2])
		sphere(r = key_size, $fn = 30);
}

/*******************************************
 Top half of the mold
********************************************/
module top_half() {
	// Create the mold form with negative keys
	difference() {

		// Create the mold form by subtracting the STL from a cube half it's size
		difference() {
			translate([0, 0, mold_depth])
				if(rounded_corners) 
					roundedBox([mold_width, mold_height, mold_depth], edge_radius, true);
				else
					cube(size = [mold_width, mold_height, mold_depth], center = true);

				scale(model_scale)
					translate(v = model_translate)
						rotate(model_rotate)
								import(model_filename);
		}

		// Negative master key
		translate(v = [mold_width/2 - key_margin, -mold_height/2 + key_margin, mold_depth/2])
			sphere(key_size + key_fettle, $fn = 30);

		// Negative key 2
		translate(v = [-mold_width/2 + key_margin, mold_height/2 - key_margin, mold_depth/2])
			sphere(key_size + key_fettle, $fn = 30);

		// Pour hole
		translate(pour_hole_translate)
			rotate(pour_hole_rotate)
				cylinder(pour_hole_height, pour_hole_r1, pour_hole_r2);
	}

	// Positive key 1
	translate(v = [mold_width/2 - key_margin, mold_height/2 - key_margin, mold_depth/2])
		sphere(key_size, $fn = 30);

	// Positive key 2
	translate(v = [-mold_width/2 + key_margin, -mold_height/2 + key_margin, mold_depth/2])
		sphere(key_size, $fn = 30);


}

/******************************************
 roundedBox module from example022.scad
******************************************/
// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
	if (sidesonly) {
		cube(size - [2*radius,0,0], true);
		cube(size - [0,2*radius,0], true);
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				 y = [radius-size[1]/2, -radius+size[1]/2]) {
			translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
		}
	}
	else {
		cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
		cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

		for (axis = [0:2]) {
			for (x = [radius-size[axis]/2, -radius+size[axis]/2],
					y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
				rotate(rot[axis]) 
					translate([x,y,0]) 
					cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
			}
		}
		for (x = [radius-size[0]/2, -radius+size[0]/2],
				y = [radius-size[1]/2, -radius+size[1]/2],
				z = [radius-size[2]/2, -radius+size[2]/2]) {
			translate([x,y,z]) sphere(radius);
		}
	}
}
