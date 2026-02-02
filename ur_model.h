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
