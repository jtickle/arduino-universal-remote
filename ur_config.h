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

#ifndef _UR_CONFIG_H_
#define _UR_CONFIG_H_

// Uncomment to get serial debugging
#define DEBUG

// Memory Limits
#define DATA_MAX_ACTIVE_PAGES 8
#define DATA_MAX_FILENAME 12
#define DATA_MAX_HITBOXES 32
#define DATA_MAX_COMMANDS 4

// Digital Pin for SD SPI select
#define SD_CS 6

// Digital Pin for TFT SPI select
#define TFT_CS 10

// Digital Pin for TFT SPI send/receive select
#define TFT_DC 9

// Analog Pin for Y+
#define TS_YP A2

// Analog Pin for X-
#define TS_XM A3

// Digital Pin for Y-
#define TS_YM 7

// Digital Pin for X+
#define TS_XP 8

// Touchscreen Resolution (determined by ohmmeter across XP and XM)
#define TS_RES 400

// Calibration data for the raw touch data to the screen coordinates
#define TS_MINX  220
#define TS_MINY  140
#define TS_MAXX  839
#define TS_MAXY  893
#define TS_MINZ   10
#define TS_MAXZ 1000

#endif // _UR_CONFIG_H_
