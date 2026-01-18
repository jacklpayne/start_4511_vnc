param (
    [string]$username = "YOUR UF EMAIL PREFIX"
)

$gateway = "linux.ece.ufl.edu"
$target  = "ece-lnx-4511c.ad.ufl.edu"
$geometry = "1920x1080"

# Remote commands:
# 1) Try to start a VNC server (ignore output)
# 2) List existing VNC displays
$ssh_cmd = @'
vncserver -geometry 1920x1080 >/dev/null 2>&1
vncserver -list
'@

# Run SSH, capture *all* output
$ssh_output = ssh -J "$username@$gateway" "$username@$target" $ssh_cmd 2>&1

# Extract the first display like ":n"
$match = $ssh_output | Select-String ':\d+'

if (-not $match) {
    Write-Error "No VNC display found. Raw output:`n$ssh_output"
    exit 1
}

# Remove leading colon
$display = $match.Matches[0].Value.Substring(1)

# Build server string safely
$server = $target + ":" + $display

# Launch RealVNC Viewer  (change this path if necessary)
$vnc_path = "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
Start-Process $vnc_path $server
