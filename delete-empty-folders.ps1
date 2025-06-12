$Path = "C:\Temp\EmptyFolders" # path is up to you

Get-ChildItem -Path $Path -Recurse -Directory | Where-Object { (Get-ChildItem -Path $_.FullName -Recurse -File).Count -eq 0 } | ForEach-Object {
    if ((Get-ChildItem -Path $_.FullName | Measure-Object).Count -eq 0) {
        Write-Host "Removing empty folder: $($_.FullName)" -ForegroundColor Yellow
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}
