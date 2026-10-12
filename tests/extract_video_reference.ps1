param([string]$VideoPath, [string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase
function Pump([int]$Milliseconds) {
    $timer = New-Object Windows.Threading.DispatcherTimer
    $frame = New-Object Windows.Threading.DispatcherFrame
    $timer.Interval = [TimeSpan]::FromMilliseconds($Milliseconds)
    $timer.Tag = $frame
    $timer.Add_Tick({ param($sender, $args) $sender.Stop(); $sender.Tag.Continue = $false })
    $timer.Start()
    [Windows.Threading.Dispatcher]::PushFrame($frame)
}
$player = New-Object Windows.Media.MediaPlayer
$player.Volume = 0
$player.Open([Uri]::new((Resolve-Path -LiteralPath $VideoPath).Path))
$player.Play()
try {
    for ($attempt = 0; $attempt -lt 20 -and -not $player.NaturalDuration.HasTimeSpan; $attempt++) { Pump 200 }
    if (-not $player.NaturalDuration.HasTimeSpan -or $player.NaturalVideoWidth -eq 0) { throw 'Windows media decoder could not open reference video.' }
    $duration = $player.NaturalDuration.TimeSpan.TotalSeconds
    $width = $player.NaturalVideoWidth
    $height = $player.NaturalVideoHeight
    Write-Host "Reference: $width x $height, $duration seconds"
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    for ($sample = 0; $sample -lt 16; $sample++) {
        $seconds = $sample * ($duration - 0.1) / 15
        $player.Position = [TimeSpan]::FromSeconds($seconds)
        Pump 180
        $visual = New-Object Windows.Media.DrawingVisual
        $drawing = $visual.RenderOpen()
        $drawing.DrawVideo($player, [Windows.Rect]::new(0,0,$width,$height))
        $drawing.Close()
        Pump 80
        $bitmap = [Windows.Media.Imaging.RenderTargetBitmap]::new($width,$height,96,96,[Windows.Media.PixelFormats]::Pbgra32)
        $bitmap.Render($visual)
        $encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
        $stream = [IO.File]::Create((Join-Path $OutputDirectory ('frame-{0:D2}.png' -f $sample)))
        try { $encoder.Save($stream) } finally { $stream.Dispose() }
        Write-Host "Frame $sample at approx $seconds seconds"
    }
} finally { $player.Close() }
