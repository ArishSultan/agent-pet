function Generate
{
    param([String] $File, [String] $Output, [String] $Directory)

    if (Test-Path -Path "$Directory\$File" -PathType Leaf)
    {
        $parts = $File.Split('.') | Select-Object -Last 2
        $name = $parts[0]
        $extn = $parts[$parts.Length - 1]

        if ($extn -eq "otf" -or $extn -eq "ttf")
        {
            return
        }
        if (!($extn -eq "webp"))
        {
            $n = $name.Trim().Replace("-", "_").Replace(" ", "_")
            cwebp -q 70 "$Directory\$File" -o "$Directory\$n.webp"
            $d = $Directory.Replace('\', '/')
            Remove-Item "$Directory/$File"
            Out-File -FilePath $Output -InputObject "    static const $n = '$d/$n.webp';" -Append
        }
    }
    else
    {
        $items = @(Write-Output (Get-ChildItem -Path "$Directory\$File").Name)
        if ($items.Length -gt 0)
        {
            foreach ($item in $items)
            {
                Generate -File $item -Output $Output -Directory "$Directory\$File"
            }
        }
    }
}

$flag = $false
$name = "agent_pet"
$current_location = (Get-Location).Path

if ($current_location -like "*\$name\scripts")
{
    $flag = $true
    Set-Location ..
    $current_location = (Get-Location).Path
}

Write-Output $current_location
if ($current_location -like "*\$name")
{
    $file_path = "$current_location\lib\src\base\assets.dart"
    $items = @(Write-Output (Get-ChildItem -Path assets).Name)
    if ($items.Length -gt 0)
    {
        Out-File -FilePath $file_path -InputObject "abstract class Assets {"
    }
    else
    {
        end
    }

    foreach ($file in $items)
    {
        Generate -File $file -Output $file_path -Directory "assets"
    }
    Out-File -FilePath $file_path -InputObject "}" -Append
}
else
{
    Write-Output "Run this script in agent_pet project or agent_pet/scripts";
}

if ($flag)
{
    Set-Location scripts
}