#ifndef _UR_MODEL_H_
#define _UR_MODEL_H_

#include "ur_config.h"

typedef struct _CmdIRSend {
  uint8_t protocol;
  uint32_t data;
  uint16_t data2;
  uint8_t khz;
} CmdIRSend;

typedef struct _CmdShowPage {
  uint8_t slot;
  uint8_t page;
} CmdShowPage;

typedef struct _Command {
  uint8_t command_id;
  union {
    CmdIRSend irsend;
    CmdShowPage showpage;
  };
} Command;

typedef struct _Extents {
  int16_t ax;
  int16_t ay;
  int16_t bx;
  int16_t by;
} Extents;

typedef struct _HitBox {
  Extents extents;
  uint8_t command_start;
  uint8_t command_count;
} HitBox;

typedef struct _Page {
  int8_t disabled_img[DATA_MAX_FILENAME];
  int8_t enabled_img[DATA_MAX_FILENAME];
  Extents extents;
  uint8_t hitbox_start;
  uint8_t hitbox_count;
} Page;

#endif // _UR_MODEL_H_
