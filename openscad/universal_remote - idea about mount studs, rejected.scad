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

SCREEN_WIDTH = 45.6;
SCREEN_HEIGHT = 58.3;
HOLE_DIAMETER = 3.15;
DISPLAY_BOARD_WIDTH_OUTER = 62.3;
DISPLAY_BOARD_WIDTH_INNER = 50.8;
DISPLAY_BOARD_HEIGHT = 81.6;
DISPLAY_BOARD_DEPTH = 0.50;
DISPLAY_DEPTH = 3.7;
DISPLAY_WIDTH = 50.2;
DISPLAY_HEIGHT = 69.3;

DISPLAY_MOUNT_RECT_LENGTH = 3.25;
DISPLAY_MOUNT_RECT_WIDTH = 5.00;

BEZEL_TOP = 10.00;
BEZEL_LEFT = 8.70;
BEZEL_BOTTOM = 13.3;
BEZEL_RIGHT = 8.70;

TOTAL_DEPTH = DISPLAY_DEPTH + DISPLAY_BOARD_DEPTH + 0.5;

SCREEN_CENTER = [
    DISPLAY_BOARD_WIDTH_OUTER / 2,
    (DISPLAY_BOARD_HEIGHT / 2) + (BEZEL_BOTTOM - BEZEL_TOP)
];

// Clipped Draw Side
module drawSide(height, width, length) {
    intersection() {
        rotate([90, 0, 0]) {
            linear_extrude(
                height = length) {
                    polygon([
                             [0.00, -1.00],
                             [0.00, 2.00],
                             [height - 2.00, height],
                             [width - 1.00, height],
                             [width, height - 0.50],
                             [height - 2.50 + sqrt(2), height - 0.50],
                             [1.00, sqrt(2)],
                             [1.00, 0.00],
                             [0.50, 0.00],
                             [0.50, -1.00]]);
            }
        }
        linear_extrude(height = height * 3, center = true) {
            polygon([[0, 0],
                     [height - 2, -(height - 2)],
                     [width, -(height - 2)],
                     [width, -(length - (height - 2))],
                     [height - 2, -(length - (height - 2))],
                     [0, -length]]);
        }
    }
}

module drawDisplayMount(rect_width, rect_length, diameter) {
    translate([rect_width, rect_length, 0]) {
        rotate([0, 0, 180]) {
            circle_tx = [rect_width / 2, 0, 0];
            difference() {
                union() {
                    square([rect_width, rect_length]);
                    translate(circle_tx) {
                            circle(d = rect_width, $fn = 25);
                        }
                }
                translate(circle_tx) {
                    circle(d = diameter, $fn = 25);
                }
            }
        }
    }
}

module drawDisplayMountBoard() {
    drawDisplayMount(DISPLAY_MOUNT_RECT_WIDTH, DISPLAY_MOUNT_RECT_LENGTH, HOLE_DIAMETER);
}

module drawDisplayMountSide(rect_width, rect_length, diameter) {
    drawDisplayMount(rect_width, rect_length, diameter);
    translate([DISPLAY_BOARD_HEIGHT - rect_width, 0, 0]) {
        drawDisplayMount(rect_width, rect_length, diameter);
    }
}

module drawDisplayBoardMountSide() {
    drawDisplayMountSide(DISPLAY_MOUNT_RECT_WIDTH, DISPLAY_MOUNT_RECT_LENGTH, HOLE_DIAMETER);
}

module drawDisplayModule() {
    translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2), 0, 0]) {
        union() {
            linear_extrude(height = DISPLAY_BOARD_DEPTH) {
                    union() {
                        square([DISPLAY_BOARD_WIDTH_INNER,
                               DISPLAY_BOARD_HEIGHT]);
                        translate([DISPLAY_BOARD_WIDTH_INNER, DISPLAY_BOARD_HEIGHT, 0]) {
                            rotate([0, 0, 270]) {
                                drawDisplayBoardMountSide();
                            }
                        }
                        translate([0, 0, 0]) {
                            rotate([0, 0, 90]) {
                                drawDisplayBoardMountSide();
                            }
                        }
                    }
            }
            translate([0,(DISPLAY_BOARD_HEIGHT - DISPLAY_HEIGHT) / 2,DISPLAY_BOARD_DEPTH]) {
                difference() {
                    cube([DISPLAY_BOARD_WIDTH_INNER,
                          DISPLAY_HEIGHT,
                          DISPLAY_DEPTH]);
                    translate([(DISPLAY_BOARD_WIDTH_INNER / 2) - (SCREEN_WIDTH / 2),
                               (DISPLAY_HEIGHT / 2) - (SCREEN_HEIGHT / 2) + BEZEL_BOTTOM - BEZEL_TOP,
                               DISPLAY_DEPTH - 0.1]) {
                        cube([SCREEN_WIDTH,
                              SCREEN_HEIGHT,
                              10]);
                    }
                }
            }
        }
    }
}

module drawScreenCenter() {
    translate([SCREEN_CENTER[0], SCREEN_CENTER[1], 0]) {
        cylinder(10, r=1);
    }
}

module drawTopHalf() {

    // Draw Top Side
    translate([2, DISPLAY_BOARD_HEIGHT - BEZEL_TOP, 0]) {
        translate([DISPLAY_BOARD_WIDTH_OUTER, BEZEL_TOP + 2, 0]) {
            rotate([0, 0, 270]) {
                drawSide(TOTAL_DEPTH, BEZEL_TOP, DISPLAY_BOARD_WIDTH_OUTER + 4);
            }
        }
    }

    // Draw Bottom Side
    translate([-2, -2, 0]) {
        translate([0, 0, 0]) {
            rotate([0, 0, 90]) {
                drawSide(TOTAL_DEPTH, BEZEL_BOTTOM + 4, DISPLAY_BOARD_WIDTH_OUTER + 4);
            }
        }
    }

    // Draw Left Side
    translate([-2, DISPLAY_BOARD_HEIGHT + 2, 0]) {
        drawSide(TOTAL_DEPTH, BEZEL_LEFT + 2, DISPLAY_BOARD_HEIGHT + 4);
    }

    // Draw Right Side
    translate([DISPLAY_BOARD_WIDTH_OUTER, 0, 0]) {
        translate([2, -2, 0]) {
            rotate([0, 0, 180]) {
                drawSide(TOTAL_DEPTH, BEZEL_RIGHT + 2, DISPLAY_BOARD_HEIGHT + 4);
            }
        }
    }

    // Draw Left Side Mounts
    translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2), 0, DISPLAY_BOARD_DEPTH]) {
        rotate([0, 0, 90]) {
            linear_extrude(height = DISPLAY_DEPTH) {
                drawDisplayMountSide(DISPLAY_MOUNT_RECT_WIDTH, DISPLAY_MOUNT_RECT_LENGTH, 2);
            }
        }
    }
}

*drawScreenCenter();

drawDisplayModule();
drawTopHalf();
