$inFile = 'C:\Users\PC\Desktop\TESTE OT NOVO\baiakthunder-master\baiakthunder-master\data\items\items.xml'
$outFile = 'C:\Users\PC\Desktop\TESTE OT NOVO\baiakthunder-master\baiakthunder-master\data\items\items_fixed.xml'
$maxId = 30000

$reader = [System.IO.StreamReader]::new($inFile)
$writer = [System.IO.StreamWriter]::new($outFile)

$skipMode = $false
$keptCount = 0
$skippedCount = 0

while ($null -ne ($line = $reader.ReadLine())) {
    if ($skipMode) {
        if ($line -match '</item>') {
            $skipMode = $false
        }
        continue
    }
    
    if ($line -match 'id="3') {
        $idMatch = [regex]::Match($line, 'id="(\d+)"')
        if ($idMatch.Success) {
            $id = [int]$idMatch.Groups[1].Value
            if ($id -gt $maxId) {
                $skipMode = $true
                $skippedCount++
                continue
            }
        }
    }
    
    if ($line -match 'fromid="3') {
        $idMatch = [regex]::Match($line, 'fromid="(\d+)"')
        if ($idMatch.Success) {
            $id = [int]$idMatch.Groups[1].Value
            if ($id -gt $maxId) {
                $skipMode = $true
                $skippedCount++
                continue
            }
        }
    }
    
    $writer.WriteLine($line)
    $keptCount++
}

$reader.Close()
$writer.Close()

Write-Host "Linhas mantidas: $keptCount"
Write-Host "Itens removidos: $skippedCount"
