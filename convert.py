from pypdf import PdfReader
from openpyxl import Workbook
import sys
import os

if len(sys.argv) < 2:
    print("ใช้: python convert.py input.pdf")
    sys.exit(1)

pdf_path = sys.argv[1]
out_xlsx = os.path.splitext(pdf_path)[0] + ".xlsx"

reader = PdfReader(pdf_path)

wb = Workbook()
ws = wb.active
ws.title = "data"

text_len = 0
max_cols = 0
rows = []

for page in reader.pages:
    text = page.extract_text()
    if not text:
        continue

    text_len += len(text)

    for line in text.split("\n"):
        cols = [c for c in line.split(" ") if c.strip()]
        if len(cols) >= 2:
            rows.append(cols)
            max_cols = max(max_cols, len(cols))

print("---- วิเคราะห์ไฟล์ ----")

if text_len < 300:
    print("❌ PDF สแกน / เป็นรูป")
    print("➡️ ใช้ OCR (Tesseract)")
    sys.exit(0)

print("✅ PDF มีข้อความ (ไม่ใช่สแกน)")
print("➡️ กำลังแปลงเป็น Excel...")

for r in rows:
    r = r + [""] * (max_cols - len(r))
    ws.append(r)

wb.save(out_xlsx)
print(f"✅ เสร็จแล้ว → {out_xlsx}")
