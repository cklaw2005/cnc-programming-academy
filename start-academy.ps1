$ErrorActionPreference = 'Stop'
$root = (Resolve-Path $PSScriptRoot).Path
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 8765)
$listener.Start()
$url = 'http://127.0.0.1:8765/'
Write-Host "CNC Programming Academy is available at $url"
Write-Host 'Keep this window open while training. Press Ctrl+C to stop the local server.'
Start-Process 'msedge' $url

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $stream = $client.GetStream()
            $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
            $requestLine = $reader.ReadLine()
            while (($header = $reader.ReadLine()) -and $header -ne '') { }
            $requestPath = '/'
            if ($requestLine -match '^GET\s+(\S+)\s+HTTP/') { $requestPath = $Matches[1].Split('?')[0] }
            $relative = [Uri]::UnescapeDataString($requestPath.TrimStart('/').Replace('/', [IO.Path]::DirectorySeparatorChar))
            if ([string]::IsNullOrWhiteSpace($relative)) { $relative = 'index.html' }
            $file = [IO.Path]::GetFullPath((Join-Path $root $relative))
            $allowedPrefix = $root.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
            if (-not $file.StartsWith($allowedPrefix, [StringComparison]::OrdinalIgnoreCase) -and $file -ne (Join-Path $root 'index.html')) {
                $status = '403 Forbidden'; $bytes = [Text.Encoding]::UTF8.GetBytes('Forbidden'); $type = 'text/plain; charset=utf-8'
            } elseif (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
                $status = '404 Not Found'; $bytes = [Text.Encoding]::UTF8.GetBytes('Not found'); $type = 'text/plain; charset=utf-8'
            } else {
                $status = '200 OK'; $bytes = [IO.File]::ReadAllBytes($file)
                $type = switch ([IO.Path]::GetExtension($file).ToLowerInvariant()) { '.html' {'text/html; charset=utf-8'} '.js' {'text/javascript; charset=utf-8'} '.css' {'text/css; charset=utf-8'} '.nc' {'text/plain; charset=utf-8'} default {'application/octet-stream'} }
            }
            $head = "HTTP/1.1 $status`r`nContent-Type: $type`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
            $headBytes = [Text.Encoding]::ASCII.GetBytes($head)
            $stream.Write($headBytes, 0, $headBytes.Length)
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Flush()
        } catch {
            Write-Verbose $_
        } finally {
            $client.Dispose()
        }
    }
} finally {
    $listener.Stop()
}
