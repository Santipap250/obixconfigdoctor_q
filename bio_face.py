import os, time, random, math

def clear():
    os.system("clear")

# eye states
EYE_OPEN = "◉"
EYE_HALF = "•"
EYE_CLOSED = "─"

# breathing cycle
breath_phase = 0.0

def face(eye_l, eye_r, breath):
    widen = " " * int(breath)
    return f"""
{widen}           .:-=+*##*+=-:.
{widen}      .:-=+*############*+=-:.
{widen}   .:-=+*####################*+=-:.
{widen} .:=+*#########****#########*+=:.
{widen}:=+*######***:::....:::***######*+=:
{widen}=+*#####**:::              :::**#####*+=
{widen}=+*#####*:::     {eye_l}      {eye_r}     :::*#####*+=
{widen}=+*#####*:::          ▄           :::*#####*+=
{widen}:=+*#####**:::        ▀▀▀         :::**#####*+=:
{widen} :=+*######***:::....:::::::....:::***######*+=:
{widen}   .:=+*#########****#########*+=:.
{widen}     .:-=+*####################*+=-:.
{widen}        .:-=+*############*+=-:.
{widen}             .:-=+*##*+=-:.
"""

def neural_noise():
    return "".join(random.choice([" ", ".", "0", "1", ":", "-"]) for _ in range(50))

# initial eye state
eye_left = EYE_OPEN
eye_right = EYE_OPEN
blink_timer = random.randint(15, 40)

while True:
    clear()

    # breathing (sinusoidal)
    breath_phase += 0.15
    breath = abs(math.sin(breath_phase)) * 2

    # blinking logic (not synchronized)
    blink_timer -= 1
    if blink_timer <= 0:
        eye_left = random.choice([EYE_CLOSED, EYE_HALF])
        eye_right = random.choice([EYE_CLOSED, EYE_HALF])
        if random.random() > 0.6:
            eye_left = EYE_OPEN
        if random.random() > 0.6:
            eye_right = EYE_OPEN
        blink_timer = random.randint(18, 45)
    else:
        eye_left = EYE_OPEN
        eye_right = EYE_OPEN

    print("\033[37m" + face(eye_left, eye_right, breath) + "\033[0m")

    # subconscious code
    print("\033[32mNEURAL ACTIVITY:\033[0m", neural_noise())

    time.sleep(random.uniform(0.18, 0.32))
