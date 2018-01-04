#ifndef _UR_CONFIG_H_
#define _UR_CONFIG_H_

#define SD_CS 6

#define DATA_MAX_ACTIVE_PAGES 8
#define DATA_MAX_FILENAME 12
#define DATA_MAX_HITBOXES 32
#define DATA_MAX_COMMANDS 4

#define TFT_CS 10
#define TFT_DC 9

#define TS_YP A2
#define TS_XM A3
#define TS_YM 7
#define TS_XP 8
#define TS_RES 400  // determine by ohmmeter across XP and XM

// This is calibration data for the raw touch data to the screen coordinates
#define TS_MINX  220
#define TS_MINY  140
#define TS_MAXX  839
#define TS_MAXY  893
#define TS_MINZ   10
#define TS_MAXZ 1000

#endif // _UR_CONFIG_H_

