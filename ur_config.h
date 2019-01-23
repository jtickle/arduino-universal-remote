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
