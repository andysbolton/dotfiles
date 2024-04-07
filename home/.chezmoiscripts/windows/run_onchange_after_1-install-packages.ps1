$items = ConvertFrom-Json "$(Get-Content ~/scoop.json)"

$buckets = $items | Select-Object -ExpandProperty Source | Sort-Object | Get-Unique 
$apps = $items | Select-Object -ExpandProperty Name 

foreach ($bucket in $buckets) {
    scoop bucket add $bucket
}

foreach ($app in $apps) {
    scoop install $app
}
