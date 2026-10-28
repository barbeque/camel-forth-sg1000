# Pop sprites out of an aseprite PNG sprite sheet,
# and convert them into the 16x16 "metatile" format
# for the TMS9918

from PIL import Image
import sys

def to_hex(s):
    return f"${s:0{2}x}"

assert(to_hex(0x00) == '$00')
assert(to_hex(0xff) == '$ff')

if len(sys.argv) < 2:
    print(f'Usage: {sys.argv[0]} [png sprite sheet]')
    sys.exit(1)

sheet = Image.open(sys.argv[1])

# get dimensions
(width, height) = sheet.size
assert(height == 16)

number_of_sprites = width // 16

def fold_byte(values : list[int]):
    assert(len(values) == 8)
       
    result = 0
    for x in range(0, 8):
        result = (result << 1) | (values[x] & 0x01)
    return result


def to_tms9918_rows(cropped : Image.Image) -> bytes:
    # Extracted, so now let's figure out what colour they are...
    # and shift them into a row

    assert(cropped.size[0] == 8)
    assert(cropped.size[1] == 8)

    # our hacky palette for the pumpkin specifically
    # I'm so glad aseprite uses indexed mode for PNG
    PALETTE = {
        0: 0,
        1: 1, # black (set this to 1 for the 'shadow' sprite)
        5: 0xff # orange
    }

    rows = []

    for row_idx in range(8):
        row = []
        for x in range(8):
            colour = cropped.getpixel((x, row_idx))
            # if it crashes here, you need to add an indexed colour to palette
            row.append(PALETTE[colour]) 
        folded = fold_byte(row)   
        rows.append(folded)

    # should return exactly 8 bytes.
    assert(len(rows) == 8)
    return bytes(rows)

buf = ''

# go from a $00, $01, $02 to dw LIT, $00, LIT, $01, LIT, $02...
# it's not the efficient way but we're on a deadline.
def forth_mapify(tms9918_rows) -> list[str]:
    assert(len(tms9918_rows) == 8)

    # Reverse it since we're going to feed it into the stack.
    tms9918_rows = list(reversed(tms9918_rows))
    out = []
    for i in range(len(tms9918_rows)):
        out.append('LIT')
        out.append(to_hex(tms9918_rows[i]))
    return out

for i in range(number_of_sprites):
    x_start = i * 16
    # Tiles go like this
    # 1 3
    # 2 4
    sprite_1 = sheet.crop((x_start, 0, x_start + 8, 8))
    sprite_2 = sheet.crop((x_start, 8, x_start + 8, 16))
    sprite_3 = sheet.crop((x_start + 8, 0, x_start + 16, 8))
    sprite_4 = sheet.crop((x_start + 8, 8, x_start + 16, 16))

    buf = buf + f'    head PUMPKIN{i}, {9 if i >= 10 else 8}, PUMPKIN{i}, docolon\n\tDW '

    out_rows = []

    out_rows += forth_mapify(to_tms9918_rows(sprite_4))
    out_rows += forth_mapify(to_tms9918_rows(sprite_3))
    out_rows += forth_mapify(to_tms9918_rows(sprite_2))
    out_rows += forth_mapify(to_tms9918_rows(sprite_1))
    
    

    assert(len(out_rows) == 64)
    
    buf = buf + ', '.join(out_rows) + ', EXIT'
    buf = buf + '\n'

print(buf)
