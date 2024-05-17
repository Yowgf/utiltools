param (
    [string]$startDate,
    [string]$endDate,
    [string]$title = "Out of Office",
    [bool]$allDayEvent = $true
)

# Validate input dates
try {
    $start = [datetime]::ParseExact($startDate, 'yyyy-MM-ddTHH:mm', $null)
    $end = [datetime]::ParseExact($endDate, 'yyyy-MM-ddTHH:mm', $null)
} catch {
    Write-Error "Invalid date format. Please use 'yyyy-MM-ddTHH:mm'."
    exit 1
}

# Load Outlook COM object
$outlook = New-Object -ComObject Outlook.Application
$namespace = $outlook.GetNamespace("MAPI")

# Get the calendar folder
$calendar = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)

# Create a new appointment item
$appointment = $calendar.Items.Add("IPM.Appointment")

# Set the appointment details
$appointment.Subject = $title
$appointment.Start = $start
$appointment.End = $end
$appointment.AllDayEvent = $allDayEvent
$appointment.BusyStatus = [Microsoft.Office.Interop.Outlook.OlBusyStatus]::olOutOfOffice

# Save the appointment
$appointment.Save()

# Log the event creation
Write-Output "Out-of-office event '$title' created from $($start.ToString('yyyy-MM-ddTHH:mm')) to $($end.ToString('yyyy-MM-ddTHH:mm')) with AllDayEvent set to $allDayEvent"
