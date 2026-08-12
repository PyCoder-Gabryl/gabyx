# Gabyx - Roguelike RPG / City-Builder


----


Tak, Commitizen działa bez problemu również na Windowsie.

Ponieważ jest to pakiet napisany w Pythonie, wystarczy mieć zainstalowane środowisko Python (z menedżerem pakietów pip) lub użyć dedykowanych menedżerów pakietów dla Windowsa.

Metody instalacji na Windowsie:
Przez PIP (najpopularniejsza metoda):
W terminalu (PowerShell lub CMD) uruchamiasz:

PowerShell
pip install --user -U commitizen
Przez Chocolatey:

PowerShell
choco install commitizen
Przez Scoop:

PowerShell
scoop install commitizen
Wewnatrz środowiska projektowego Python (np. Poetry / uv):
Jeśli projekt korzysta z Pythona, można go dodać bezpośrednio jako zależność deweloperską:

PowerShell
uv add --dev commitizen
# lub
poetry add --group dev commitizen
Po instalacji komenda cz (oraz cz commit, cz bump) działa w PowerShellu, wbudowanym terminalu VS Code / CLion, Git Bash czy Windows Terminal dokładnie tak samo jak na macOS czy Linuksie.
