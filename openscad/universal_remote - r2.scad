/*
 *  Ardunio Universal Remote
 *  Copyright (C) 2019 Jeff Tickle
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

DISPLAY_BOARD_WIDTH_OUTER = 62.3;
DISPLAY_BOARD_WIDTH_INNER = 50.8;
DISPLAY_BOARD_HEIGHT = 81.6;
DISPLAY_BOARD_DEPTH = 1.54;
DISPLAY_DEPTH = 3.7;
DISPLAY_WIDTH = 50.2;
DISPLAY_HEIGHT = 69.3;

HOLE_DIAMETER = 3.15;
DISPLAY_MOUNT_RECT_LENGTH = 3.25;
DISPLAY_MOUNT_RECT_WIDTH = 5.00;

BETWEEN_ARDUINO_AND_DISPLAY = 10.0;
BETWEEN_ARDUINO_AND_BOTTOM  = 07.0;

ARDUINO_LENGTH = 33.7;
ARDUINO_WIDTH = 18.6;
ARDUINO_DEPTH = 01.0;
ARDUINO_MAX_DEPTH = 2.1;
ARDUINO_CORNER_WIDTH = 1.5;
ARDUINO_CORNER_LENGTH = 3.0;
ARDUINO_RESET = 3.20;
ARDUINO_CUTOUT = 3.00;

CASE_BORDER = 3.0;
CASE_LIP = 1.00;

DISPLAY_BORDER = 8.00;
BEZEL_TOP_OUT  = DISPLAY_BORDER + CASE_BORDER;
BEZEL_TOP_IN   = 2.40;
BEZEL_TOP_TOT  = BEZEL_TOP_OUT + BEZEL_TOP_IN;
BEZEL_SIDE_OUT = DISPLAY_BORDER + CASE_BORDER;
BEZEL_SIDE_IN  = 2.40;
BEZEL_SIDE_TOT = BEZEL_SIDE_OUT + BEZEL_SIDE_IN;
BEZEL_BOT_OUT  = BETWEEN_ARDUINO_AND_BOTTOM + ARDUINO_LENGTH
               + BETWEEN_ARDUINO_AND_DISPLAY + DISPLAY_BORDER;
BEZEL_BOT_IN   = 8.00;
BEZEL_BOT_TOT  = BEZEL_BOT_OUT + BEZEL_BOT_IN;

SCREEN_WIDTH = DISPLAY_WIDTH - (BEZEL_SIDE_IN * 2);
SCREEN_HEIGHT = DISPLAY_HEIGHT - (BEZEL_TOP_IN + BEZEL_BOT_IN);

POWER_HEIGHT = 63.2;
POWER_WIDTH  = 37.0;
POWER_DEPTH  = 15.8;

TOTAL_DEPTH = DISPLAY_DEPTH + DISPLAY_BOARD_DEPTH + 0.5;

CASE_WIDTH = CASE_BORDER*2 + BEZEL_SIDE_TOT*2 + SCREEN_WIDTH;
CASE_HEIGHT = CASE_BORDER*2 + BEZEL_TOP_TOT + BEZEL_BOT_TOT + SCREEN_HEIGHT;

PIN_BELOW = 3.00;
PIN_BASE = 2.50;
PIN_DIM = 2.00;
PIN_ANGLE_HEIGHT = 2.00;
PIN_ANGLE_LEN = 9.00;
PIN_STRAIGHT_HEIGHT = 6.00;

SCREEN_CENTER = [
    CASE_WIDTH / 2,
    CASE_HEIGHT - CASE_BORDER - BEZEL_TOP_TOT - (SCREEN_HEIGHT / 2)
];

module drawStraightPin() {
    dim = (PIN_BASE - PIN_DIM) / 2;
    translate([-PIN_BASE/2, -PIN_BASE/2, 0]) {
        
        // Pin
        translate([dim, dim, -PIN_BELOW]) {
            cube([PIN_DIM, PIN_DIM, PIN_BELOW + PIN_BASE + PIN_STRAIGHT_HEIGHT]);
        }
        
        // Plastic Guide
        cube([PIN_BASE, PIN_BASE, PIN_BASE]);
    }
}

module drawAnglePin() {
    dim = (PIN_BASE - PIN_DIM) / 2;
    translate([-PIN_BASE/2, -PIN_BASE/2, 0]) {
        
        // Straight Part
        translate([dim, dim, -PIN_BELOW]) {
            cube([PIN_DIM, PIN_DIM, PIN_BELOW + PIN_BASE + PIN_ANGLE_HEIGHT]);
        }
        
        // Bent Over Part
        translate([dim, dim, PIN_BASE + PIN_ANGLE_HEIGHT]) {
            cube([PIN_DIM, PIN_ANGLE_LEN, PIN_DIM]);
        }
        
        // Plastic Guide
        cube([PIN_BASE, PIN_BASE, PIN_BASE]);
    }
}

module drawManyPins(count) {
    for(pin = [0 : count - 1]) {
        translate([PIN_BASE * pin, 0, 0]) {
            rotate([180, 0, 0]) {
                children();
            }
        }
    }
}

// Draw Side Cross-Section
module drawSideXSec(out, mid, in, top, up, down, bot, cutout=false) {
    width = out + mid + in;
    height = top + up + down + bot;
    
    first = [[0.00, -6.00],
             [0.00, bot],
             [height - bot, height],
             [width - top, height],
             [width, height - top],
             [width - in, height - top],
             [width - in, bot + down]];
    
    // If there is a solder cutout, cut it out...
    second = [[width - in - 1.00, bot + down],
              [width - in - 1.00, bot + down + up],
              [width - in - 6.00, bot + down + up],
              [width - in - 6.00, bot + down]];
    
    third = [[out, bot + down],
             [out, bot],
             [bot, bot],
             [bot, -6.00]];
    
    if(cutout) {
        polygon(concat(first, second, third));
    } else {
        polygon(concat(first, third));
    }
}

module extrudeSide(out, mid, in, top, up, down, bot, length, cutout=false) {
    width = out + mid + in;
    height = top + up + down + bot;
    
    angle_part = height - bot;
    
    intersection() {
        
        // Extrude a side
        rotate([90, 0, 0]) {
            linear_extrude(
                height = length) {
                    drawSideXSec(out, mid, in, top, up, down, bot, cutout);
            }
        }
        
        // Cut to match up with other sides
        linear_extrude(height = height * 3, center = true) {
            polygon([[0, 0],
                     [angle_part, -angle_part],
                     [width, -angle_part],
                     [width, -(length - angle_part)],
                     [angle_part, -(length - angle_part)],
                     [0, -length]]);
        }
    }
}

module drawDisplayMount() {
    circle_tx = [DISPLAY_MOUNT_RECT_WIDTH / 2, 0, 0];
    difference() {
        
        // Draw the general shape
        union() {
            square([DISPLAY_MOUNT_RECT_WIDTH,
                    DISPLAY_MOUNT_RECT_LENGTH]);
            translate(circle_tx) {
                    circle(d = DISPLAY_MOUNT_RECT_WIDTH, $fn = 25);
                }
        }
        
        // Subtract the screw hole
        translate(circle_tx) {
            circle(d = HOLE_DIAMETER, $fn = 25);
        }
    }
}

module drawDisplayMountSide() {
    drawDisplayMount();
    translate([DISPLAY_BOARD_HEIGHT - DISPLAY_MOUNT_RECT_WIDTH, 0, 0]) {
        drawDisplayMount();
    }
}

module drawDisplayModule(pins = true) {
    translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2), 0, 0]) {
        union() {
            linear_extrude(height = DISPLAY_BOARD_DEPTH) {
                    union() {
                        
                        // Display Board inner portion
                        square([DISPLAY_BOARD_WIDTH_INNER,
                               DISPLAY_BOARD_HEIGHT]);
                        
                        // Display Board Mounts - right side
                        translate([DISPLAY_BOARD_WIDTH_INNER + DISPLAY_MOUNT_RECT_LENGTH, 0, 0]) {
                            rotate([0, 0, 90]) {
                                drawDisplayMountSide();
                            }
                        }
                        
                        // Display Board Mounts - left side
                        translate([0 - DISPLAY_MOUNT_RECT_LENGTH, DISPLAY_BOARD_HEIGHT, 0]) {
                            rotate([0, 0, 270]) {
                                drawDisplayMountSide();
                            }
                        }
                    }
            }
            translate([0,(DISPLAY_BOARD_HEIGHT - DISPLAY_HEIGHT) / 2,DISPLAY_BOARD_DEPTH]) {
                difference() {
                    
                    // Display Module
                    cube([DISPLAY_WIDTH,
                          DISPLAY_HEIGHT,
                          DISPLAY_DEPTH]);
                    
                    // Subtract to show Screen borders
                    translate([BEZEL_SIDE_IN, BEZEL_BOT_IN,
                               DISPLAY_DEPTH - 0.1]) {
                        cube([SCREEN_WIDTH,
                              SCREEN_HEIGHT,
                              10]);
                    }
                }
            }
        }
    }
    
    // Draw Pins
    if(pins) {
        translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2) + PIN_BASE/2,
                   DISPLAY_MOUNT_RECT_WIDTH/2, 0]) {
            drawManyPins(20) {
                drawAnglePin();
            }
        }
    }
}

module translateForDisplayModule() {
    translate([BEZEL_SIDE_OUT - CASE_BORDER, BEZEL_BOT_OUT - CASE_BORDER, 1.00]) {
        children();
    }
}

module absoluteDrawDisplayModule(pins = true) {
    translateForDisplayModule() {
        drawDisplayModule(pins);
    }
}

module drawScreenCenter() {
    translate([SCREEN_CENTER[0], SCREEN_CENTER[1], 0]) {
        cylinder(10, r=1);
    }
}

module drawPowerModule() {
    translate([0, 0, -1]) {
        
        // Power Module plus a bonus mm to cut clean through
        cube([POWER_WIDTH, POWER_HEIGHT, POWER_DEPTH + 1]);
        
        // Space for Power Module Wiring (for cutout)
        translate([2, -10, 6]) {
            cube([POWER_WIDTH - 4, POWER_HEIGHT - 2, POWER_DEPTH - 5]);
        }
        
        // Space for Power Module Switch (for cutout)
        translate([0, 0, 0.1]) {
            cube([POWER_WIDTH, 10, POWER_DEPTH + 3]);
        }
    }
}

module translateForPowerModule() {
    translate([CASE_WIDTH/2 - POWER_WIDTH/2, CASE_HEIGHT - POWER_HEIGHT - 15, -POWER_DEPTH - 4]) {
        children();
    }
}

module absoluteDrawPowerModule() {
    translateForPowerModule() {
        drawPowerModule();
    }
}

module drawArduino(pins=true) {
    cube([ARDUINO_WIDTH, ARDUINO_LENGTH, ARDUINO_DEPTH]);
    
    if(pins) {
        // Programming Pins
        translate([PIN_BASE/2 + (ARDUINO_WIDTH/2 - PIN_BASE*3), PIN_BASE / 2, 0]) {
            drawManyPins(6) {
                drawAnglePin();
            }
        }
        
        // Side Pins
        translate([PIN_BASE/2, ARDUINO_LENGTH - PIN_BASE/2, 0]) {
            for(i = [0 : 1]) {
                translate([i * (ARDUINO_WIDTH - PIN_BASE), 0, 0]) {
                    rotate([0, 0, 270]) {
                        drawManyPins(4) {
                            drawStraightPin();
                        }
                        translate([PIN_BASE * 6, 0, 0]) {
                            drawManyPins(3) {
                                drawStraightPin();
                            }
                        }
                    }
                }
            }
        }
    }
}

module drawArduinoCutout(pins=false) {
    
    lower_pins = 18.5;
    mid_length = 3.5;
    upper_base = lower_pins + mid_length;
    upper_size = ARDUINO_LENGTH - upper_base;
    
    // Main Board
    drawArduino(pins);
    
    // Lower Supports
    translate([ARDUINO_CORNER_WIDTH, -4, -(8 - ARDUINO_DEPTH*2)]) {
        cube([ARDUINO_WIDTH - ARDUINO_CORNER_WIDTH*2,
              ARDUINO_CORNER_LENGTH + 4, 8.0]); 
    }
    translate([ARDUINO_CORNER_WIDTH, -10, -(10 - ARDUINO_DEPTH*2)]) {
        cube([ARDUINO_WIDTH - ARDUINO_CORNER_WIDTH*2,
              ARDUINO_CORNER_LENGTH + 10, 4.5]);
    }
    translate([ARDUINO_CORNER_WIDTH, 0, ARDUINO_DEPTH]) {
        cube([ARDUINO_WIDTH - ARDUINO_CORNER_WIDTH*2,
              ARDUINO_CORNER_LENGTH*3, 3.0]);
    }
    translate([0, ARDUINO_CORNER_LENGTH*3, ARDUINO_DEPTH]) {
        cube([ARDUINO_WIDTH, lower_pins - ARDUINO_CORNER_LENGTH*3, 3.0]);
    }
    translate([0, ARDUINO_CORNER_LENGTH*3, -7]) {
        cube([ARDUINO_CORNER_LENGTH, lower_pins - ARDUINO_CORNER_LENGTH*3, 7.0]);
    }
    translate([ARDUINO_WIDTH - ARDUINO_CORNER_LENGTH, ARDUINO_CORNER_LENGTH*3, -7]) {
        cube([ARDUINO_CORNER_LENGTH, lower_pins - ARDUINO_CORNER_LENGTH*3, 7.0]);
    }
    
    // Central Support
    translate([ARDUINO_CORNER_LENGTH, lower_pins, ARDUINO_DEPTH]) {
        cube([ARDUINO_WIDTH - ARDUINO_CORNER_LENGTH*2,
              mid_length, ARDUINO_MAX_DEPTH]);
    }
    
    // Upper Cutout
    translate([0, upper_base, ARDUINO_DEPTH]) {
        cube([ARDUINO_WIDTH, upper_size, 3.0]);
    }
    translate([0, upper_base, -7]) {
        cube([ARDUINO_CORNER_LENGTH, upper_size, 7.0]);
    }
    translate([ARDUINO_WIDTH - ARDUINO_CORNER_LENGTH, upper_base, -7]) {
        cube([ARDUINO_CORNER_LENGTH, upper_size, 7.0]);
    }
    
    // Reset Hole
    translate([ARDUINO_WIDTH / 2, ARDUINO_LENGTH - ARDUINO_RESET, 0]) {
        cylinder(25, d=1.25, $fn=8);
    }
}

module translateForArduino() {
    translate([(CASE_WIDTH / 2) - (ARDUINO_WIDTH / 2),
               BETWEEN_ARDUINO_AND_BOTTOM,
               1.00 + DISPLAY_BOARD_DEPTH - ARDUINO_DEPTH]) {
        children();
    }
}

module absoluteDrawArduino(pins = true) {
    translateForArduino() {
        drawArduino(pins);
    }
}

module absoluteDrawArduinoCutout(pins = false) {
    translateForArduino() {
        drawArduinoCutout(pins);
    }
}

module drawTopHalf() {
    
    cover = 0.50;

    // Draw Top Side
    translate([CASE_BORDER*2 + BEZEL_SIDE_TOT*2 + SCREEN_WIDTH,
               CASE_BORDER*2 + BEZEL_BOT_TOT + SCREEN_HEIGHT + BEZEL_TOP_TOT]) {
        rotate([0, 0, 270]) {
            extrudeSide(CASE_BORDER, BEZEL_TOP_OUT, BEZEL_TOP_IN,
                        cover, DISPLAY_DEPTH, DISPLAY_BOARD_DEPTH, CASE_LIP,
                        CASE_WIDTH);
        }
    }

    // Draw Bottom Side
    rotate([0, 0, 90]) {
        extrudeSide(CASE_BORDER, BEZEL_BOT_OUT, BEZEL_BOT_IN,
                    cover, DISPLAY_DEPTH, DISPLAY_BOARD_DEPTH, CASE_LIP,
                    CASE_WIDTH,
                    cutout=true);
    }

    // Draw Left Side
    translate([0, CASE_BORDER*2 + BEZEL_TOP_TOT + BEZEL_BOT_TOT + SCREEN_HEIGHT]) {
        extrudeSide(CASE_BORDER, BEZEL_SIDE_OUT, BEZEL_SIDE_IN,
                    cover, DISPLAY_DEPTH, DISPLAY_BOARD_DEPTH, CASE_LIP,
                    CASE_HEIGHT);
    }

    // Draw Right Side
    translate([CASE_BORDER*2 + BEZEL_SIDE_TOT*2 + SCREEN_WIDTH, 0]) {
        rotate([0, 0, 180]) {
            extrudeSide(CASE_BORDER, BEZEL_SIDE_OUT, BEZEL_SIDE_IN,
                        cover, DISPLAY_DEPTH, DISPLAY_BOARD_DEPTH, CASE_LIP,
                        CASE_HEIGHT);
        }
    }
}

module drawLED() {
    rotate([270, 0, 0]) {
        
        // Main LED Cylinder
        cylinder(8.5, d=5.0, $fn=30);
        
        // LED Transmit Opening (for cutout)
        translate([0, 0, 6.0]) {
            cylinder(10, d1=5, d2=50);
        }
        
        // Space for LED Leads (for cutout)
        cube([4, 2, 10], center=true);
        
        // Notched LED Base Cylinder for mounting
        difference() {
            cylinder(1, d=6.0, $fn=30);
            translate([2.5, -3, 0]) {
                cube([3, 6, 3]);
            }
        }
    }
}

module translateForLED() {
    translate([CASE_WIDTH/2, CASE_HEIGHT - 7.5, -4]) {
        children();
    }
}

module absoluteDrawLED() {
    translateForLED() {
        drawLED();
    }
}

module drawScrew() {
    translate([0, 0, -7]) {
        rotate([0, 0, 90]) {
            // Threaded Portion
            cylinder(10, d=4, $fn=12);
            
            // Head Portion
            translate([0, 0, -1]) {
                cylinder(4, d1=10, d2=4, $fn=12);
            }
            
            // Screw Channel (for cutout)
            translate([0, 0, -21]) {
                cylinder(20, d=10, $fn=12);
                
                // Extend head portion outward
                //translate([-4, 0, 0]) {
                //    cube([8, 10, 20]);
                //}
            }
            
            // Extend Screw Channel outward
            /*translate([0, 5, 0]) {
                rotate([90, 0, 0]) {
                    linear_extrude(10, center=true) {
                        polygon([[-2, 3],
                                 [ 2, 3],
                                 [ 4, 0],
                                 [-4, 0]]);
                                 
                    }
                }
            }*/
        }
    }
}

module drawScrewSide() {
    drawScrew();
    translate([0, 70, 0]) {
        drawScrew();
    }
}

module drawScrews() {
    translate([9, 30, 1.5]) {
        drawScrewSide();
        translate([DISPLAY_BOARD_WIDTH_OUTER - 2, 0, 0]) {
            mirror([-1, 0, 0]) {
                drawScrewSide();
            }
        }
    }
}

module drawMiddleUpper() {
    width = CASE_WIDTH - CASE_LIP*2;
    height = CASE_HEIGHT - CASE_LIP*2;
    union() {
        translate([CASE_WIDTH/2 - width/2, CASE_HEIGHT/2 - height/2, -2]) {

            // Extrude the plate
            linear_extrude(height=3.00) {
                difference() {
                    
                    // Draw the entire plate
                    square([width, height]);
                    
                    // Subtract a hole for the display electronics
                    translate([width/2 - DISPLAY_BOARD_WIDTH_INNER/2, height - DISPLAY_BOARD_HEIGHT - BEZEL_TOP_TOT]){
                        square([DISPLAY_BOARD_WIDTH_INNER, DISPLAY_BOARD_HEIGHT]);
                    }
                }
            }
        }
        
        // Contact plate for Arduino mounting
        translate([CASE_BORDER, CASE_BORDER, 0]) {
            cube([CASE_WIDTH - CASE_BORDER*2, ARDUINO_LENGTH + CASE_BORDER*2, DISPLAY_BOARD_DEPTH + CASE_LIP]);
        }
        
        // Contact plates for Display mounting, either side
        for(i = [0:1]) {
            translate([CASE_BORDER + (i * (width - BEZEL_SIDE_OUT - CASE_BORDER - CASE_LIP + 1)),
                       height - BEZEL_TOP_OUT - DISPLAY_MOUNT_RECT_LENGTH - SCREEN_HEIGHT,
                       0]) {
                cube([BEZEL_SIDE_OUT - 1,
                      SCREEN_HEIGHT,
                      DISPLAY_BOARD_DEPTH + CASE_LIP]);
            }
        }
    }
}

module drawMiddleLower() {
    width = CASE_WIDTH - CASE_LIP*2;
    height = CASE_HEIGHT - CASE_LIP*2;
    difference() {
        
        // Draw the entire plate and subtract the rest
        translate([CASE_WIDTH/2 - width/2, CASE_HEIGHT/2 - height/2, -4]) {
            cube([width, height, 2]);
        }
        
        // Subtract hole for Display Wiring
        translate([CASE_WIDTH/2 - DISPLAY_BOARD_WIDTH_INNER/2,
                   CASE_HEIGHT - DISPLAY_BOARD_HEIGHT - BEZEL_TOP_TOT - 8,
                   -4]) {
            cube([DISPLAY_BOARD_WIDTH_INNER, 20, 2]);
        }
    }
}

module drawBottom() {
    
    difference() {
        
        // Two big blocks are the general shape plus lip to match
        // with first layer
        translate([0, 0, -POWER_DEPTH - 4]) {
            translate([CASE_LIP, CASE_LIP, 0]) {
                cube([CASE_WIDTH - CASE_LIP*2, CASE_HEIGHT - CASE_LIP*2, POWER_DEPTH]);
            }
            cube([CASE_WIDTH, CASE_HEIGHT, POWER_DEPTH - 2]);
        }
        
        // Subtract the rest of the features
        union() {
            translate([CASE_WIDTH/2 - DISPLAY_WIDTH/2, 0, -(POWER_DEPTH - 5) - 5]) {
                
                // Area for Arduino and Display Wiring
                translate([0, CASE_BORDER, 0]) {
                    cube([DISPLAY_WIDTH, ARDUINO_LENGTH + 25, POWER_DEPTH - 4]);
                }
                
                // Area for LED Wiring
                translate([0, CASE_HEIGHT - BEZEL_TOP_TOT, 0]) {
                    cube([DISPLAY_WIDTH, BEZEL_TOP_TOT - 7, POWER_DEPTH - 4]);
                    cube([DISPLAY_WIDTH/2 - 4.5, BEZEL_TOP_TOT - 3, POWER_DEPTH - 4]);
                    translate([DISPLAY_WIDTH/2 + 4.5, 0, 0]) {
                        cube([DISPLAY_WIDTH/2 - 4.5, BEZEL_TOP_TOT - 3, POWER_DEPTH - 4]);
                    }
                }
                
                // Side Channels
                translate([0, CASE_BORDER + ARDUINO_LENGTH + 20, 0]) {
                    cube([5, DISPLAY_BOARD_HEIGHT, POWER_DEPTH - 4]);
                    translate([DISPLAY_BOARD_WIDTH_INNER - 5.6, 0, 0]) {
                        cube([5, DISPLAY_BOARD_HEIGHT, POWER_DEPTH - 4]);
                    }
                }
            }
        }
    }
}

module select(which) {
    children(which);
}

module drawParts(which = [0, 1, 2, 3, 4]) {
    select(which) {
        absoluteDrawDisplayModule();
        absoluteDrawArduino();
        absoluteDrawLED();
        absoluteDrawPowerModule();
        drawScrews();
    }
}

module drawCutouts(which = [0, 1, 2, 3]) {
    select(which) {
        absoluteDrawArduinoCutout();
        absoluteDrawLED();
        absoluteDrawPowerModule();
        drawScrews();
    }
}

module drawWholeUnit(whichUnit = [0, 1, 2, 3], whichCutout = [0, 1, 2, 3]) {
    difference() {
        intersection() {
            
            // Draw Units
            select(whichUnit) {
                drawTopHalf();
                drawMiddleUpper();
                drawMiddleLower();
                drawBottom();
            }
            
            // Round the bottom
            translate([CASE_WIDTH / 2, 0, 0]) {
                rotate([270, 0, 0]) {
                    cylinder(CASE_HEIGHT, d = CASE_WIDTH, $fn=120);
                }
            }
        }
        
        // Remove parts
        drawCutouts(whichCutout);
    }
}

module showUnitIntersections(which = [0, 1, 2]) {
    select(which) {
        intersection() {
            drawTopHalf();
            drawMiddleUpper();
        }
        interserction() {
            drawMiddleUpper();
            drawMiddleLower();
        }
        intersection() {
            drawMiddleLower();
            drawBottom();
        }
    }
}

module showPartIntersections(whichUnit = [0, 1, 2, 3], whichPart = [0, 1, 2, 3]) {
    intersection() {
        drawWholeUnit(whichUnit);
        drawParts(whichPart);
    }
}

// Disable for printing
*drawScreenCenter();

// Ensure individual sections are not intersecting
// Disable for printing
*showUnitIntersections();

// Ensure parts are not intersecting with the model
// Disable for printing
*showPartIntersections();

// Draw the parts
// Disable for printing
*drawParts();

// THIS IS THE ONLY THING TO ENABLE WHEN PRINTING
// Select one or more layers below.
// They are arranged for easy commenting-out.
drawWholeUnit(whichUnit = [
0,   // Top Bezel
1,   // Upper Middle
2,   // Lower Middle
3    // Bottom Case
]);
