import os, time, random, math

def clear():
    os.system("clear")

EYES = {
    "open": "◉",
    "half": "•",
    "closed": "─"
}

breath = 0.0
blink_l = random.randint(10, 28)
blink_r = random.randint(14, 34)
eye_l = EYES["open"]
eye_r = EYES["open"]

def face(el, er, b):
    s = " " * int(b)
    return f"""
{s}        .:-=++==-:.
{s}    .:=+*########*+=:.
{s}  .:=+*####****####*+=:.
{s} :=+*###***    ***###*+=:
{s}=+*###**     {el}  {er}     **###*+=
{s}=+*###**        ▄         **###*+=
{s} :=+*###***     ▀▀▀      ***###*+=:
{s}  .:=+*####****####*+=:.
{s}      .:-=++==-:.
"""

def neural_wave():
    return "".join(random.choice([" ", ".", "0", "1", ":", "-"]) for _ in range(36))

while True:
    clear()

    # breathing (very subtle)
    breath += 0.1
    b = abs(math.sin(breath)) * 1.8

    # blinking logic (independent eyes)
    blink_l -= 1
    blink_r -= 1

    if blink_l <= 0:
        eye_l = random.choice([EYES["closed"], EYES["half"]])
        blink_l = random.randint(15, 40)
    else:
        eye_l = EYES["open"]

    if blink_r <= 0:
        eye_r = random.choice([EYES["closed"], EYES["half"]])
        blink_r = random.randint(18, 45)
    else:
        eye_r = EYES["open"]

    print("\033[37m" + face(eye_l, eye_r, b) + "\033[0m")
    print("\033[32mneural:\033[0m", neural_wave())

    time.sleep(random.uniform(0.28, 0.42))
