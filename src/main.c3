import std::io;

import raylib;

import types;
import lcd;

macro access(current, x, y) {
  if (x < 0 || x >= 160) return 0;
  if (y < 0 || y >= 160) return 0;
  return current[y][x];
}

fn UInt8 count_live(UInt8[160][160] current, UInt8 x, UInt8 y) {
  UInt8 live = 0;
  for (Int16 ty = y - 1; ty <= y + 1; ++ty) {
    for (Int16 tx = x - 1; tx <= x + 1; ++tx) {
      if (tx == x && ty == y) continue;
      if (access(current, tx, ty) != 0) live++;
    }  
  }
  return live;
}

fn void main(String[] args) {
  Lcd lcd;
  lcd.init();

  UInt8[160][160] current;
  UInt8[160][160] next;

  for (UInt8 y = 0; y < 160; ++y) {
    for (UInt8 x = 0; x < 160; ++x) {
      if (x == y) current[y][x] = 3;
      if (159 - x == y) current[y][x] = 3;
    }
  }

  while (true) {
    lcd.update(current);

    for (UInt8 y = 0; y < 160; ++y) {
      for (UInt8 x = 0; x < 160; ++x) {
        UInt8 count = count_live(current, x, y);
        if (current[y][x] == 0) {
          if(count == 3) {
            next[y][x] = 3;
          }
        }
        else {
          if (count < 2) {
            next[y][x] = 0;
          }
          else if (count > 3) {
            next[y][x] = 0;
          }
          else {
            next[y][x] = 3;
          }
        }
      }
    }

    for (UInt8 y = 0; y < 160; ++y) {
      for (UInt8 x = 0; x < 160; ++x) {
        current[y][x] = next[y][x];
        next[y][x] = 0;
      }
    }

    lcd.redraw();
  }

  //lcd.close();
}