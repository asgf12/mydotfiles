# Skrypt s┼éu┼╝─ůcy do archiwizacji programem 7zip bez kompresji (.tar) celem przerzucenia na serwer przed reinstalacj─ů oprogramowania, lub na nowy komp.
# Wymagania wst─Öpne: zainstalowany 7zip w domy┼Ťlnej lokalizacji, powershell, sie─ç firmowa na komputerze.
# Po wywo┼éaniu skrypt pobiera wymagane zmienne, zak┼éadam wywwo┼éywanie jedynie z komputera, kt├│rego dotyczy migracja.
# Autor: Adrian Lulka 9.08.2024
# Modif v0.9rc 27.01.2025


Write-Host "Wywo┼éany skrypt spakuje folder Usera do archiwum TAR i pozwoli na jego przegranie."
Write-Host "UWAGA, JE┼ÜLI ARCHIWUM FOLDERU USERA ISTNIEJE W LOKALIZACJI C:\BACKUPY ZOSTANIE NADPISANE"
Write-Host "Przed spakowaniem nale┼╝y upewni─ç si─Ö, ┼╝e posiadamy uprawnienia do folderu Usera."
Write-Host "Po automatycznym otworzeniu okna eksploratora, pro┼Ťba o dwuklik w folder, kt├│ry ma zosta─ç za chwil─Ö spakowany."

Set-Location c:/Users
& explorer . # Otwiera eksplorator w gui, nie chce mi si─Ö skryptowa─ç nadawania uprawnie┼ä do folderu Usera, dwuklik jest wystarczaj─ůcy.

get-psdrive -name c

# Wymagane zmienne:
$Y = Read-Host "Podaj sam login U┼╝ytkownika do zarchiwizowania"
$Source = "C:\Users\$Y"
$Hostname = $env:COMPUTERNAME 
$BackupDir = "C:\BACKUPY\$Hostname"
$TAR = "$BackupDir\$Y.tar"
$ZBackupDir = "Z:\BACKUPY\$Hostname"

$freeSpaceBytes = (Get-PSDrive -Name C).Free
$freeSpaceGB = [math]::Round($freeSpaceBytes / 1GB, 2)
$folderSizeBytes = (Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum
$folderSizeGB = [math]::Round($folderSizeBytes / 1GB, 2)
Write-Output "Wolne miejsce : $freeSpaceGB GB, $Source : $folderSizeGB GB"
Write-Output "Kontynuacja za 10 sekund, 'Ctrl+C' przerywa skrypt"

If (-Not (Test-Path -path "C:\BACKUPY")) {
    New-Item -ItemType directory "C:\BACKUPY"
}
Start-Sleep 10 # Propagowanie uprawnie┼ä

# Wykonanie archiwum odbywa si─Ö przez 7z.exe, wi─Öcej info przy wykonaniu komendy "7z.exe /?"" ze wskazanej ni┼╝ej lokalizacji.
New-Item -ItemType directory $BackupDir -Force
Set-Location "C:\Program Files\7-Zip"
& .\7z.exe a -mx1 $TAR $Source # a=tworzy archiwum, mx1=najni┼╝sza kompresja.
& explorer $BackupDir

Write-Host "Przed kontynuacj─ů nale┼╝y przejrze─ç LOG i sprawdzi─ç wielko┼Ť─ç archiwum, nie ma mo┼╝liwo┼Ťci zapisania go do pliku."
Write-Host " "
Write-Host "W razie dziwnych b┼é─Öd├│w konieczne b─Ödzie przerwanie procesu przez wci┼Ťni─Öcie ENTER"
Write-Host " "
    Get-ChildItem $BackupDir\$Y.tar | Select-Object Name, @{Name="GigaBytes";Expression={$_.Length / 1GB}}
While ($True) {
$RemoteHost = Read-Host "Podaj Hostname komputera do przegrania pliku tar (bez slashy i c$, Ctrl+C przerywa skrypt)"
Test-Connection $RemoteHost -count 2 | select IPV4Address,ResponseTime,statuscode
$Continue = Read-Host "Kontunuowa─ç kopiowanie na serwer ($RemoteHost) (y/N)"

If ($Continue -eq "Y" -or $Continue -eq "y") {
    # Po wybraniu czegokolwiek innego kopiowanie na serwer jest pomijane
    # Usuni─Öcie lokalizacji sieciowej i dodanie serwera celem przegrania
    net use z: /d
    net use z: \\$RemoteHost\c$ # Tu zwr├│ci─ç uwag─Ö czy hostname jest prawid┼éowy

    New-Item -ItemType directory $ZBackupDir -Force

    Set-Location $BackupDir
    # Zgodnie z rekomendacj─ů Security dobrze jest u┼╝y─ç programu Robocopy i tak jest to kopiowane w tym skrypcie
    # Simple Usage :: ROBOCOPY source destination [file] /MIR
    # wi─Öcej info = robocopy /?
    Robocopy . $ZBackupDir "$Y.tar" 
    # Wy┼Ťwietlenie lokalizacji sieciowej, wyci─ůgni─Öcie Nazwy i Rozmiaru po zmianie na GB (human readable)
    Get-ChildItem $ZBackupDir\$Y.tar | Select-Object Name, @{Name="GigaBytes";Expression={$_.Length / 1GB}}
    net use z: /d
} 
}
# exit 0
