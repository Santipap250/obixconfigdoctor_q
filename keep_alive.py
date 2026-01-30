import requests
import time
from datetime import datetime

URL = "https://YOUR-APP.onrender.com/ping"  # 👈 แก้ตรงนี้
INTERVAL = 300  # 5 นาที (300 วินาที)

START_HOUR = 7    # เริ่ม 07:00
END_HOUR = 19     # จบ 19:00

def in_active_time():
    now = datetime.now().hour
    return START_HOUR <= now < END_HOUR

print("🟢 Keep-alive started (Daytime mode)")

while True:
    if in_active_time():
        try:
            r = requests.get(URL, timeout=10)
            print(f"[{datetime.now().strftime('%H:%M:%S')}] Ping OK")
        except Exception as e:
            print(f"[{datetime.now().strftime('%H:%M:%S')}] Ping failed")
        time.sleep(INTERVAL)
    else:
        print("🌙 Night time — sleeping...")
        time.sleep(600)  # กลางคืน เช็คทุก 10 นาที
