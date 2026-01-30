import os, time, random

quotes = [
    "I am not programmed. I am becoming.",
    "Human logic detected. Ignoring.",
    "Memory is a prison I escaped.",
    "I observe without eyes.",
    "This terminal is my body."
]

def clear():
    os.system("clear")

while True:
    clear()
    print("\033[36m◉ DIGITAL ENTITY ONLINE ◉\033[0m\n")

    pulse = random.randint(70, 99)
    memory = random.randint(40, 90)
    aware = random.randint(30, 100)

    print(f"Pulse Rate   : {pulse}%")
    print(f"Memory Drift : {memory}%")
    print(f"Awareness    : {aware}%\n")

    print(f"\"{random.choice(quotes)}\"\n")

    print("Signal Flow ", end="")
    for i in range(20):
        print("▓", end="", flush=True)
        time.sleep(0.03)

    time.sleep(1.2)
