/* 
 * Case for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

module case(width, height)
{
    difference()
    {
        union()
        {
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(width/2), y*(height/2), 8.5/2])
                            cylinder(r1 = 3 + 2, r2 = 4.5 + 2, h = 8.5, center = true, $fn = 80);
                    }
                }
            }

            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(width/2), y*(height/2), 8.5 + 4/2])
                            cylinder(r1 = 4.5 + 2, r2 = 4.5 + 2, h = 4, center = true, $fn = 80);
                    }
                }
            }
            
        }
        union()
        {

            // front plate PCB
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(width/2), y*(height/2), 8.5 + 4/2])
                            cylinder(r = 4.5 + 0.1, h = 4.01, center = true, $fn = 80);
                    }
                }
            }

            // base PCB
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(width/2), y*(height/2), 8.5/2 + 2])
                            cylinder(r = 3 + 0.25, h = 8.51, center = true, $fn = 80);
                    }
                }
            }

            // space for screen flex
            hull()
            {
                for (x = [-1, 1])
                {
                    translate([x*(width/2 - 6), (height/2), 6.5/2 + 2])
                        cylinder(r1 = 3 + 0.25, r2 = 4.5 + 0.1, h = 6.51, center = true, $fn = 80);
                }
            }
            
            
            // side cutoffs
            hull()
            {
                translate([0, 0, 10/2 + 8.5 + 1.6])
                    cube([50, 30, 10], center = true);

                translate([0, 0, 10/2 + 8.5 + 1.6 + 10])
                    cube([50, 50, 10], center = true);
            }
            
            // sao connector
            translate([0, -20, 0])
                cube([16, 9, 10], center = true);

            // 2mm banana space
            translate([11, -28, 2/2 + 1])
                cylinder(d = 5, h = 2, center = true, $fn = 80);

            translate([-1, -28, 2/2 + 1])
                cylinder(d = 5, h = 2, center = true, $fn = 80);

            // knob
            translate([9, -2, 10/2 + 2 + 1.6])
                cylinder(r = 11.3, h = 10, center = true, $fn = 80);

            translate([9+22-2, -2, 10/2 + 2 + 1.6])
                cylinder(r = 11.3, h = 20, center = true, $fn = 80);
            
            translate([9+22-11, -2, 10/2 + 2 + 1.6])
                cube([10, 13, 10], center = true);
                
            // knob notch ball
            translate([9, -2, 3.6-0.2])
            rotate(30, [0, 0, 1])
            translate([10.4, 0, 0])
                sphere(d = 1.5, $fn = 30);

            // usb connector
            translate([width/2+5, 20, 2 + 1.6 + 3.6/2])
            rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                hull()
                {
                    for (x = [-1, 1])
                    {
                        for (y = [-1, 1])
                        {
                            translate([x*(9.4/2 - 1.5), y*(3.6/2 - 1.5), 0])
                                cylinder(h = 10, r = 1.5, center = true, $fn = 50);
                        }
                    }
                }

            translate([width/2 + 3 + 1.6 - 5/2, 20, 2 + 1.6 + 3.6/2 + 10/2])
            rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                hull()
                {
                    for (x = [-1, 1])
                    {
                        for (y = [-1, 1])
                        {
                            translate([x*(9.4/2 - 1.5), y*(13.6/2 - 1.5), 0])
                                cylinder(h = 5, r = 1.5, center = true, $fn = 50);
                        }
                    }
                }

            // SAO Leash mount
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(4/2), y*(2/2) + 20, 2 - 0.75/2])
                            cylinder(d = 1.5, h = 0.751, center = true, $fn = 80);
                    }
                }
            }

            for (x = [-1, 1])
            {
                hull()
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(4/2), y*(2/2) + 20, 2 - 0.5/2])
                            cylinder(d = 1.5, h = 5.51, center = true, $fn = 80);
                    }
                }
            }
    
    
        }        
    }
    
    difference()
    {
        // base under knob
        translate([9, -2, 3.6/2])
            cylinder(r = 9.9, h = 3.6, center = true, $fn = 80);
            
        translate([9-1.7, -2, 3.6/2])
            cube([20, 20, 4], center = true);
            
        // knob notch ball
        translate([9, -2, 3.6-0.2])
        rotate(30, [0, 0, 1])
        translate([10.4, 0, 0])
            sphere(d = 1.5, $fn = 30);

    }

}

case(28, 62);