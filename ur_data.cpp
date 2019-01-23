#include "ur_data.h"

URData::URData() {
}

bool URData::init(int8_t sd_pin) {
    if(!SD.begin(sd_pin)) {
      #ifdef DEBUG
      Serial.println(F("Init Failure: SD Card"));
      #endif //DEBUG
      
      return false;
    }
    
    return true;
}

void URData::load_initcmds() {
  load_commands(command_start, command_count);
}

void URData::load_commands(uint8_t start, uint8_t count) {
  
  #ifdef DEBUG
  Serial.print("Loading Commands ");
  Serial.print(start);
  Serial.print(" ");
  Serial.println(count);
  #endif //DEBUG
  
  _cur_cmd = start;
  _max_cmd = start + count;
}

bool URData::has_next_command() {
  return !(_cur_cmd >= _max_cmd);
}

bool URData::next_command(Command *command) {
  if(!has_next_command()) {
    return false;
  }

  memcpy_P(command, &commands[_cur_cmd], sizeof(Command));

  _cur_cmd += 1;

  return true;
}

bool URData::get_page(Page *page, uint8_t idx) {
  memcpy_P(page, &pages[idx], sizeof(Page));

  return true;
}

bool URData::get_hitbox(HitBox *hitbox, Page *page, int16_t x, int16_t y) {
  for(int i = page->hitbox_start; i < page->hitbox_count; i++) {
    memcpy_P(hitbox, &hitboxes[i], sizeof(HitBox));

    if(x >= hitbox->extents.ax && y >= hitbox->extents.ay &&
       x <  hitbox->extents.bx && y <  hitbox->extents.by) {
      return true;
    }
  }
  return false;
}
