module types;

def Int8 = ichar;
def UInt8 = char;
def Int16 = short;
def UInt16 = ushort;
def Int32 = int;
def UInt32 = uint;
def UInt64 = ulong;

const UInt16 WIDTH = 1024;
const UInt16 HEIGHT = 1024;

struct Table {
    UInt32 width;
    UInt32 height;
    UInt8* data;
    UInt32 startx;
    UInt32 starty;
}

fn UInt8 Table.read(&table, UInt32 x, UInt32 y) {
    return table.data[((y + table.starty) * table.width) + (x + table.startx)];
}

fn void Table.write(&table, UInt32 x, UInt32 y, UInt8 value) {
    table.data[((y + table.starty) * table.width) + (x + table.startx)] = value;
}