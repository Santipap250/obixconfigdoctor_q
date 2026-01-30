import os, time, random, math, shutil, sys, select

W, H = shutil.get_terminal_size((80, 24))
chars = "01アイウエオカキクケコサシスセソ"
signature = "OBIXHACKLAB"

def clear():
    os.system("clear")

face_mask = [
"      ██████████      ",
"   ████████████████   ",
" ████████████████████ ",
" ███████      ███████ ",
" ███████  ██  ███████ ",
" ███████      ███████ ",
" ████████████████████ ",
"   ████████████████   ",
"      ██████████      "
]

FACE_H = len(face_mask)
FACE_W = len(face_mask[0])
drops = [random.randint(0, H) for _ in range(W)]

eye_open = "◉"
eye_closed = "─"
blink = random.randint(20, 45)
breath = 0.0

# non-blocking input
def enter_pressed():
    return select.select([sys.stdin], [], [], 0)[0]

while True:
    if enter_pressed():
        break

    clear()
    screen = [[" " for _ in range(W)] for _ in range(H)]

    # matrix rain
    for x in range(W):
        y = drops[x]
        if 0 <= y < H:
            screen[y][x] = random.choice(chars)
        drops[x] += 1
        if random.random() > 0.975:
            drops[x] = random.randint(-15, 0)

    # breathing
    breath += 0.12
    shift = int(abs(math.sin(breath)) * 1)

    # blinking
    blink -= 1
    eyes = eye_open if blink > 2 else eye_closed
    if blink <= 0:
        blink = random.randint(18, 50)

    fy = H//2 - FACE_H//2
    fx = W//2 - FACE_W//2 + shift

    for y in range(FACE_H):
        for x in range(FACE_W):
            if face_mask[y][x] == "█":
                if 0 <= fy+y < H and 0 <= fx+x < W:
                    screen[fy+y][fx+x] = random.choice("01")

    # eyes
    if 0 <= fy+4 < H:
        screen[fy+4][fx+9]  = eyes
        screen[fy+4][fx+12] = eyes

    # signature
    sig_y = fy + FACE_H + 2
    sig_x = W//2 - len(signature)//2
    if 0 <= sig_y < H:
        for i, c in enumerate(signature):
            if random.random() > 0.08:
                screen[sig_y][sig_x + i] = c

    # hint
    hint = "Press ENTER to access shell"
    hy = sig_y + 2
    hx = W//2 - len(hint)//2
    if 0 <= hy < H:
        for i, c in enumerate(hint):
            screen[hy][hx + i] = c

    for row in screen:
        print("\033[32m" + "".join(row) + "\033[0m")

    time.sleep(0.08)

clear()
print("\033[32m[ ACCESS GRANTED – OBIXHACKLAB ]\033[0m")
