$fileserver = fileservername
$folders = @()
$kimenet = @()
$eleresiut = $null
$sum = $null

do
{
    Write-Host "Add meg az elérési utat"
    $eleresiut = Read-Host "Elérési út"
    if (!(Test-Path -Path $eleresiut))
    {
        Write-Host "Nem létező elérési utat adtál meg!" -ForegroundColor Red
    }
} while (!(Test-Path -Path $eleresiut))

$folders = Get-ChildItem $eleresiut

for ($i = 0; $i -lt $folders.Count; $i++)
{
    Write-Host "`r$($i+1). mappa méretének kiszámítása a $($folders.Count)-ból folyamatban." -NoNewline
    [int]$meret = (Get-ChildItem $folders[$i].FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1Mb
#    $kvota = Invoke-Command -ComputerName $fileserver -ScriptBlock { Get-FsrmQuota -Path $folders[$i].FullName }
#    Write-Host $kvota
    $elem = New-Object PSobject
    $elem | Add-Member -membertype NoteProperty -Name "Mappa" -Value $folders[$i].Name
    $elem | Add-Member -membertype NoteProperty -Name "Méret" -Value $meret
    $kimenet += $elem
    $sum += $meret
}
$elem = New-Object PSobject
$elem | Add-Member -membertype NoteProperty -Name "Mappa" -Value "Mindösszesen (GB):"
$elem | Add-Member -membertype NoteProperty -Name "Méret" -Value ([Math]::Round($sum/1024,2))
$kimenet += $elem

Clear-Host
$kimenet
#$kimenet | Out-GridView

<#
Tesztelésre váró parancsok:

Invoke-Command -ComputerName nameofcomputer -ScriptBlock { Get-ChildItem C:\ }
Get-FsrmQuota -Path "C:\Share01\..."
Enter-PSSession -ComputerName nameofcomputer
#>