#ifndef _UR_DATA_H_
#define _UR_DATA_H_

#include <SPI.h>
#include <SD.h>
#include <stdint.h>
#include <avr/pgmspace.h>

#include "ur_config.h"
#include "ur_model.h"

const Command commands[] PROGMEM = {
  {2, {0, 0}},
  {2, {1, 1}},
  {1, {1, 0x20DF40BF, 32, 0}},
  {1, {1, 0x20DFC03F, 32, 0}},
  {1, {1, 0x20DF10EF, 32, 0}},
  {1, {1, 0x20DFD02F, 32, 0}}
};

const HitBox hitboxes[] PROGMEM = {
  { { 80,  0, 160,  64}, 4, 1 },
  { {160,  0, 240,  64}, 2, 1 },
  { {  0, 64,  80, 128}, 0, 0 },
  { { 80, 64, 160, 128}, 5, 1 },
  { {160, 64, 240, 128}, 3, 1 }
};

const Page pages[] PROGMEM = {
  { "main_o.bmp", "main_i.bmp",
    {  0,  0, 240, 128}, 0, 5 },
  { "bottom.bmp", "bottom.bmp",
    { 0, 128, 240, 320}, 0, 0 }
};

class URData {
  public:
    URData();
    bool init(int8_t sd_pin);
    void load_initcmds();
    bool has_next_command();
    bool next_command(Command *command);
    bool get_page(Page *page, uint8_t idx);
    bool get_hitbox(HitBox *hitbox, Page *page, int16_t x, int16_t y);
    void load_commands(uint8_t start, uint8_t count);
    uint8_t active_pages[DATA_MAX_ACTIVE_PAGES];
    Extents extents[DATA_MAX_ACTIVE_PAGES];
    const uint8_t command_start = 0;
    const uint8_t command_count = 2;

  protected:
    uint8_t _cur_cmd;
    uint8_t _max_cmd;
};

#endif // _UR_DATA_H_
