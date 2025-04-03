# Extract table data from Bethesda Creation Kit
#
# This script uses Windows UI Automation to access and export the content of the
# object window table, which normally only allows copying single row keys, and
# saves the extracted data as a CSV file with semicolon `;` separation.
#
# Requirements, are roughly the following:
# * Windows 11 & PowerShell *(in doubt a recent version)*
# * The Windows Software Development Kit (SDK)
#   * Download: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
# * Specifically `inspect.exe` to find automation IDs.
#   * For the Inspect tool: https://learn.microsoft.com/en-us/windows/win32/winauto/inspect-objects
#   * After installation it can be found in (depending on the version):
#     `C:\Program Files (x86)\Windows Kits\{major-version}\bin\{version}\x64\inspect.exe`
# * A running Creation Kit with an open Object Window ... for obvious reasons :)
#
# Compatibility at least with the following Creation Kits
# * Fallout New Vegas / Fallout 3 GECK (Garden of Eden Creation Kit)
# * Fallout 4 Creation Kit (Next-Gen 64bit)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName UIAutomationClient

function Escape-CsvValue {
    param (
        [string]$value
    )
    if ($value -contains '"') {
        $value = $value -replace '"', '""'
    }
    if ($value -contains ';' -or $value -contains '"') {
        $value = '"' + $value + '"'
    }
    return $value
}

function Get-TableData {
    param (
        [int]$processId,
        [string]$listAutomationId
    )

    # Get the root element
    $rootElement = [System.Windows.Automation.AutomationElement]::RootElement

    # Get the main application window by process ID
    $conditionProcessId = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ProcessIdProperty, $processId)
    $appWindow = $rootElement.FindFirst([System.Windows.Automation.TreeScope]::Children, $conditionProcessId)

    if ($appWindow -eq $null) {
        Write-Host "Application window not found."
        return
    }

    # Get the list (table) element using the AutomationId
    $conditionList = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::AutomationIdProperty, $listAutomationId)
    $list = $appWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $conditionList)

    if ($list -eq $null) {
        Write-Host "List (table) element not found."
        return
    }

    # # Extract column headers
    # $headers = $list.FindFirst([System.Windows.Automation.TreeScope]::Children, [New-Object System.Windows.Automation.PropertyCondition]([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Header))
    # $headerColumns = $headers.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
    # $headerNames = @()
    # foreach ($headerColumn in $headerColumns) {
    #     $headerNames += $headerColumn.Current.Name -replace ' ', ''
    # }

    # Extract data from the list
    $conditionTrue = [System.Windows.Automation.Condition]::TrueCondition
    $listItems = $list.FindAll([System.Windows.Automation.TreeScope]::Children, $conditionTrue)
    $data = @()
    #$data += [PSCustomObject]@{ Row = $headerNames -join ";" }
    $data += ($headerNames -join ";")

    foreach ($item in $listItems) {
        $columns = $item.FindAll([System.Windows.Automation.TreeScope]::Children, $conditionTrue)
        $rowData = @()

        foreach ($column in $columns) {
            $text = ""
            if ($column.TryGetCurrentPattern([System.Windows.Automation.TextPattern]::Pattern, [ref]$null)) {
                $textPattern = $column.GetCurrentPattern([System.Windows.Automation.TextPattern]::Pattern)
                $text = $textPattern.DocumentRange.GetText(-1)
            } else {
                $text = $column.Current.Name
            }
            $rowData += (Escape-CsvValue -value $text)
        }

        # $data += [PSCustomObject]@{
        #     Row = $rowData -join ";"
        # }
        $data += ($rowData -join ";")
    }

    return $data
}

# 1. Open the "Inspect" tool (Part of Windows 11 SDK, e.g. install via VS)
# 2a. Set the process ID below. Select app in Inpector and look for
#     "ProcessId: ...", or check the Task Manager.
#     inspector, or e.g. via Task Manager.
#$processId = 64784  # Replace with the actual process ID
# 2b. Lookup ProcessId dynamically by window title (change title pattern if
#     necessary)
$processId = (Get-Process | Where-Object { $_.MainWindowTitle -like "*Creation Kit*" }).Id
# 3. Set the AutomationId to the list (table) element. Select list in
#    Inspector (here under App > Window > List) and look for "AutomationId:".
$listAutomationId = "1041"  # Replace with the actual AutomationId

# fail in case of missing processId
if ($processId -eq $null) {
    Write-Host "Process ID not found or set."
    return
}
Write-Host "Process ID: $processId, List AutomationId: $listAutomationId"
Write-Host "Processing data..."

# Call the function and get the table data
$tableData = Get-TableData -processId $processId -listAutomationId $listAutomationId
Write-Host "Data extracted."

$outFile = "get-text-from-table_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + ".csv"
Write-Host "Writing data to file: $outFile"

# Output the data to a CSV file
#$tableData | Export-Csv -Path "get-text-from-table.csv" -NoTypeInformation
$tableData | Out-File -FilePath $outFile -Encoding utf8

Write-Host "Data written to file: $outFile"
