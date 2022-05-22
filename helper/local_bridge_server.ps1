$scriptName = "local_bridge_server"
$prefix = "http://+:80/Temporary_Listen_Addresses/"

try {
    $listener = New-Object Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()
    Write-Host "local_bridge_server started"
    while ($true) {
        $context = $listener.GetContext()
        $current_date = Get-Date
        $request = $context.Request
        Write-Host ("[" + $current_date + "] " + $request.HttpMethod + " " + $request.RawUrl)
        $response = $context.Response
        $response.StatusCode = 200

        if($request.RawUrl.StartsWith("/Temporary_Listen_Addresses/command?")) {
            $operation = $request.RawUrl.Replace("/Temporary_Listen_Addresses/command?", "")
            if ($operation.StartsWith("open_chrome")) {
                start chrome $operation.Replace("open_chrome=", "")
                $content = [Text.Encoding]::UTF8.GetBytes('OK')
            } else {
                $content = [Text.Encoding]::UTF8.GetBytes('Invalid Operation')
            }
        } else {
            $content = [Text.Encoding]::UTF8.GetBytes('Invalid Address')
        }

        $response.ContentType = "text/plain"
        $response.OutputStream.Write($content, 0, $content.Length)
        $response.Close()
    }
    Write-Host "local_bridge_server finished"
}
catch {
    Write-Error $_.Exception
}
