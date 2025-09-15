# Documents\WindowsPowerShell\Profile.ps1
function prompt {"`n$(Get-Date) $(Get-Location)`n> "}
Set-PSReadlineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
#Set-PSReadlineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward,EndOfLine
Set-PSReadlineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Alt+b' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Alt+f' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+b' -Function BackwardChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -Function EndOfLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+h' -Function BackwardDeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function KillWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function KillLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+u' -Function BackwardKillLine
#Set-PSReadLineKeyHandler -Chord 'Alt+c' -Function CapitalizeWord
Set-PSReadLineKeyHandler -Chord 'Alt+u' -Function InvertCase
#Set-PSReadLineKeyHandler -Chord 'Alt+l' -Function DowncaseWord
Set-PSReadLineKeyHandler -Chord 'Alt+.' -Function YankLastArg
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Yank
Set-PSReadLineKeyHandler -Chord 'Ctrl+j' -Function AcceptLine
#Set-PSReadLineKeyHandler -Chord 'Ctrl+x,e' -Function EditLine
Set-PSReadlineKeyHandler -Chord 'escape' -Function ScrollDisplayToCursor
Set-PSReadlineKeyHandler -Chord Ctrl+p -Scriptblock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
