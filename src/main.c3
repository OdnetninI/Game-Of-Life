import std::io;

import raylib;

import types;
import lcd;

fn UInt8 count_live(Table table, UInt32 x, UInt32 y) {
  UInt8 live = 0;

  UInt32 sx = x - 1;
  if (x == 0) sx = x;
  UInt32 sy = y - 1;
  if (y == 0) sy = y;

  UInt32 ex = x + 1;
  if (x == table.width - 1) ex = x;
  UInt32 ey = y + 1;
  if (y == table.height - 1) ey = y;

  for (UInt32 ty = sy; ty <= ey; ++ty) {
    for (UInt32 tx = sx; tx <= ex; ++tx) {
      if (tx == x && ty == y) continue;
      if (table.read(tx, ty) != 0) live++;
    }  
  }
  //io::printfn("[%d, %d -> %d] %d (%d -> %d, %d -> %d)", x, y, table.read(x, y), live, sx, ex, sy, ey);
  return live;
}

fn void main(String[] args) {
  Lcd lcd;
  lcd.init();

  Table current;
  current.width = types::WIDTH;
  current.height = types::HEIGHT;
  current.startx = 0;
  current.starty = 0;
  current.data = null;

  Table next = current;
  Table view = current;

  current.data = mem::malloc(UInt8, types::WIDTH*types::HEIGHT);
  next.data = mem::malloc(UInt8, types::WIDTH*types::HEIGHT);

  //io::printfn("Memory Allocated");

  for (UInt32 y = 0; y < current.height; ++y) {
    for (UInt32 x = 0; x < current.width; ++x) {
      if (x == y) { current.write(x, y, 3); }
      else if (current.width - 1 - x == y) { current.write(x, y, 3); }
      else { current.write(x, y, 0); }
    }
  }

  mem::copy(next.data, current.data, types::WIDTH*types::HEIGHT);

  //io::printfn("Data initialized");

  bool run = false;
  bool step = false;

  while (true) {

    //io::printfn("Input");

    if (raylib::is_key_down(raylib::keyboard::SPACE)) {
      run = true;
    }
    if (raylib::is_key_down(raylib::keyboard::P)) {
      run = false;
    }
    if (raylib::is_key_down(raylib::keyboard::S)) {
      step = true;
    }

    if (raylib::is_key_down(raylib::keyboard::KP_ADD)) {
      lcd::zoom += 0.1;
    }
    if (raylib::is_key_down(raylib::keyboard::KP_SUBTRACT)) {
      lcd::zoom -= 0.1;
    }

    if (raylib::is_key_down(raylib::keyboard::RIGHT)) {
      lcd::sx += lcd::zoom * 10;
    }
    if (raylib::is_key_down(raylib::keyboard::LEFT)) {
      lcd::sx -= lcd::zoom * 10;
    }
    if (raylib::is_key_down(raylib::keyboard::UP)) {
      lcd::sy -= lcd::zoom * 10;
    }
    if (raylib::is_key_down(raylib::keyboard::DOWN)) {
      lcd::sy += lcd::zoom * 10;
    }

    //io::printfn("Current displacement: %d %d", sx, sy);

    //io::printfn("Update next");

    if (run || step) {
      for (UInt32 y = 0; y < current.height; ++y) {
        for (UInt32 x = 0; x < current.width; ++x) {
          UInt8 count = count_live(current, x, y);
          if (current.read(x, y) == 0) {
            if(count == 3) {
              next.write(x, y, 3);
            }
            else {
              next.write(x, y, 0);
            }
          }
          else {
            if (count < 2) {
              next.write(x, y, 0);
            }
            else if (count > 3) {
              next.write(x, y, 0);
            }
            else {
              next.write(x, y, 3);
            }
          }
        }
      }
      
      UInt8* tmp = current.data;
      current.data = next.data;
      next.data = tmp;

      step = false;
    }

    //io::printfn("Draw");

    view.startx = 0;
    view.starty = 0;
    view.data = next.data;    

    lcd.update(view);
    lcd.redraw();
  }

  //lcd.close();
}