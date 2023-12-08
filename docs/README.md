# Links

A re-creation of the schematic by Mokona can be found on
[Triceraprog](https://www.triceraprog.fr/vg5000m-schemas-de-principe-mis-a-jour-en-v15.html).

Partial software implementation of the EF9345 in Mame :
[ef9345.cpp](https://github.com/mamedev/mame/blob/master/src/devices/video/ef9345.cpp)

# Mappings

Memory map:
- 0-16K: internal ROM (vg5k11.bin)
- 16k-32k: internal RAM

I/O decoding:
| R/W | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | demux(7807) | func          |
| --- | -- | -- | -- | -- | -- | -- | -- | -- | ----------- | ------------- |
| W   | 1  | 0  | 0  | x  | x  | x  | x  | x  | y0          | EF9345/addr   |
| W   | 1  | 0  | 1  | x  | x  | x  | x  | x  | y1          | WK7/cassette  |
| W   | 1  | 1  | 0  | x  | x  | x  | x  | x  | y2          | EF9345/data   |
| W   | 1  | 1  | 1  | x  | x  | x  | x  | x  | y3          | NMI/i18n      |
| R   | 1  | 0  | 0  | x  | 0  | C  | B  | A  | y4          | RKY/keyb.read |
| R   | 1  | 0  | 1  | x  | x  | x  | x  | x  | y5          | RK7/cassette  |
| R   | 1  | 1  | 0  | x  | x  | x  | x  | x  | y6          | EF9345/data   |
| R   | 1  | 1  | 1  | x  | x  | x  | x  | x  | y7          |               |
