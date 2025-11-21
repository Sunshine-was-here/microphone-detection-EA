# Deployment Guide

## Prerequisites

- Jamf Pro server access with permissions to create Extension Attributes
- Understanding of Jamf Pro Extension Attributes
- Basic knowledge of bash scripting (for customization)

## Step-by-Step Deployment

### 1. Create Extension Attribute

1. Log into Jamf Pro
2. Navigate to **Settings** (gear icon) → **Computer Management** → **Extension Attributes**
3. Click **+ New** button
4. Fill in the following fields:

   **Display Name:** `Built-in Microphone Status`
   
   **Description:** `Detects if the Mac's built-in microphone is physically disabled via hardware kill switch`
   
   **Data Type:** Select `String`
   
   **Inventory Display:** Select `Extension Attributes`
   
   **Input Type:** Select `Script`

5. In the **Script** field, paste the entire contents of `microphone_check.sh`

6. Click **Save**

### 2. Verify Collection

The Extension Attribute will be collected during the next inventory update. To force immediate collection on a test device:
```bash
# On the Mac, run:
sudo jamf recon
```

### 3. View Results

1. Navigate to **Computers** → Select a computer
2. Click the **Extension Attributes** tab
3. Look for `Built-in Microphone Status`

### 4. Create Smart Groups

#### Smart Group: Disabled Microphones
```
Name: Macs - Built-in Microphone Disabled
Criteria:
  Built-in Microphone Status | is | Unavailable or Disabled
```

#### Smart Group: Working Microphones
```
Name: Macs - Built-in Microphone Working  
Criteria:
  Built-in Microphone Status | is | Available and Working
```

#### Smart Group: Restricted Microphones
```
Name: Macs - Microphone Restricted (Software)
Criteria:
  Built-in Microphone Status | is | Available but Restricted
```

### 5. Create Advanced Search (Optional)

For reporting purposes, create an advanced search:
```
Name: Microphone Status Report
Display: Computers
Criteria:
  Computer Name | like | %
Display Fields:
  - Computer Name
  - Serial Number  
  - Model
  - Operating System
  - Built-in Microphone Status
  - Last Check-in
```

### 6. Set Up Monitoring (Optional)

Create a policy to alert when microphones become disabled:

1. Create Smart Group (as above) for disabled mics
2. Set up notifications for membership changes
3. Or create a report that runs weekly

## Rollback Procedure

If you need to remove or disable the Extension Attribute:

1. Navigate to the Extension Attribute in Jamf Pro
2. Either:
   - **Delete**: Removes entirely (loses historical data)
   - **Disable**: Edit script to return empty result: `echo "<result></result>"`

## Performance Considerations

- **Execution Time**: ~2-5 seconds per device
- **System Impact**: Minimal (reads only, no writes)
- **Network Impact**: None (no external API calls)
- **Inventory Impact**: Adds ~50 bytes per device

## Customization

### Changing Result Values

Edit the `echo` statements in `perform_microphone_detection()`:
```bash
# Example: Change "Available and Working" to "Enabled"
echo "Enabled"  # instead of "Available and Working"
```

### Adding Additional Checks

Add custom checks in the `check_software_functionality()` function:
```bash
# Example: Check for specific application
if pgrep -x "MySecurityApp" >/dev/null 2>&1; then
    SUPPORTIVE_PASSED=$((SUPPORTIVE_PASSED + 1))
fi
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## Support

For issues or questions:
- [GitHub Issues](https://github.com/YOUR_USERNAME/jamf-microphone-detection/issues)
- [Documentation](https://github.com/YOUR_USERNAME/jamf-microphone-detection)
