# generates the asm blob for the key map from this table

# from d0 to d7, port A... then d0 to d3, port B
# 0 = don't output anything
# all ascii values
KEY_KANA = 0
KEY_HOME_CLR = 0
KEY_INS_DEL = 0x08 # backspace
KEY_PI = 0
KEY_UP = 0
KEY_DOWN = 0
KEY_LEFT = 0
KEY_RIGHT = 0
KEY_RETURN = 0x0d # carriage return
KEY_YEN = 0
KEY_FUNC = 0
KEY_BREAK = 0
KEY_GRAPH = 0
KEY_CTRL = 0
KEY_SHIFT = 0

# TODO: Finish this keymap off (especially numbers/symbols.)
KEYMAP = [
    [ '!', 'q', 'a', 'z', KEY_KANA, ',', 'k', 'i', '8', 0, 0, 0 ],
    [ '"', 'w', 's', 'x', ' ', '.', 'l', 'O', '9', 0, 0, 0 ],
    [ '3', 'e', 'd', 'c', KEY_HOME_CLR, '/', ';', 'p', '0', 0, 0, 0 ],
    [ '4', 'r', 'f', 'v', KEY_INS_DEL, KEY_PI, ':', '@', '-', 0, 0, 0 ],
    [ '5', 't', 'g', 'b', 0, KEY_DOWN, ']', '[', '^', 0, 0, 0 ],
    [ '6', 'y', 'h', 'n', 0, KEY_LEFT, KEY_RETURN, 0, KEY_YEN, 0, 0, KEY_FUNC ],
    [ '7', 'u', 'j', 'm', 0, KEY_RIGHT, KEY_UP, 0, KEY_BREAK, KEY_GRAPH, KEY_CTRL, KEY_SHIFT ]
]

for row in KEYMAP:
    assert(len(row) == 12)

    keys = [ hex(k) if isinstance(k, int) else hex(ord(k)) for k in row ]
    key_string = ', '.join(keys)

    comment_string = ', '.join([str(k) for k in row])

    print('\t;', comment_string)
    print('.db', key_string)


# TODO: shifted key map
# TODO: kana key map