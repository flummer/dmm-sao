/* 
 * Screen support for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */
 
 module screen_support(pcb_spacing)
{
    difference()
    {
        union()
        {
            translate([17, -(7 + (13/2)), (pcb_spacing-1.5-0.1)/2])
                cube([27, 15, pcb_spacing-1.5-0.1], center = true);
        }
        union()
        {
            // cutout for USB-C connector
            translate([17*2 - 6.2 + 8/2, -14, (pcb_spacing-1.5-0.1)/2])
                cube([8, 9.1, pcb_spacing], center = true);

            // cutout for USB-C support + misc
            translate([17*2 - 6.3-8 + 8/2, -14, 2.2/2])
                cube([10, 9.1, 2.21], center = true);

            // cutout flash
            translate([7/2, -(7 + (13/2)), 2.2/2])
                cube([7.4, 15.1, 2.21], center = true);
                
            // cutout oled jelly beans
            translate([17, -(10.25/2), 2.2/2])
                cube([20.1, 10.25, 2.21], center = true);

            // cutout RP2040 + support
            translate([17, -18.3, 2.2/2])
            rotate(45, [0, 0, 1])
                cube([15, 15, 2.21], center = true);
            
            // cutout crystal
            translate([17-8, -18.3-5/2, 2.2/2])
                cube([5, 5, 2.21], center = true);

                
            // remove spikes
            translate([17-10, -18.5, 2.2/2])
                cube([3, 3, 2.21], center = true);

            translate([17-1.5, -10, 2.2/2])
                cube([3, 3, 2.21], center = true);

            translate([17+7, -21, 2.2/2])
                cube([3, 3, 2.21], center = true);
        }
    }
}

/*

Screen dimensions

Thickness: 1.5 mm
Width (glass): 27 mm
Height (glass): 15 mm (the part centered around the display data

Front PCB opening

Width: 25 mm
Height: 13 mm

Position: 7 mm from top of base PCB, centered

*/ 

color("#444444")
screen_support(4.9);