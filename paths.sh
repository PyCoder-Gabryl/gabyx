python3 -c '
import os

count = 0
for root, dirs, files in os.walk("src"):
    for file in sorted(files):
        if file.endswith((".ads", ".adb")):
            full_path = os.path.join(root, file)
            with open(full_path, "r", encoding="utf-8") as f:
                lines = f.readlines()

            modified = False
            new_lines = []
            for line in lines:
                if line.startswith("--  PATH:"):
                    # Formatowanie z idealnym odstępem
                    new_lines.append(f"--  PATH:            {full_path}\n")
                    modified = True
                else:
                    new_lines.append(line)

            if modified:
                with open(full_path, "w", encoding="utf-8") as f:
                    f.writelines(new_lines)
                count += 1

print(f"✅ Sukces! Zaktualizowano nagłówki PATH w {count} plikach źródłowych.")
'
