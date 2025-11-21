# Troubleshooting Guide

## Common Issues

### Issue: EA Returns "Unknown Status"

**Symptoms:**
- Extension Attribute shows "Unknown Status"
- Should never occur in normal operation

**Causes:**
- Logic error in decision matrix
- Unexpected system state

**Resolution:**
1. Run the script manually with debug output:
```bash
   sudo bash -x /path/to/microphone_check.sh
```
2. Check for error messages
3. Report as bug with full output

---

### Issue: EA Returns "Available but Restricted" on Working System

**Symptoms:**
- Microphone works in applications
- EA reports "Available but Restricted"

**Possible Causes:**

1. **TCC Permission Denial**
```bash
   # Check TCC database
   sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
     "SELECT * FROM access WHERE service='kTCCServiceMicrophone';"
```

2. **MDM Profile Restriction**
```bash
   # Check for MDM profiles
   profiles -P | grep -i microphone
```

3. **CoreAudio Errors**
```bash
   # Check recent logs
   log show --predicate 'subsystem == "com.apple.coreaudio"' --last 1h | grep -i error
```

**Resolution:**
- Review and adjust TCC permissions
- Check MDM profile settings
- Investigate CoreAudio errors

---

### Issue: EA Not Updating After Changes

**Symptoms:**
- Made changes to script in Jamf
- Results not updating on devices

**Resolution:**
1. Force inventory update on test device:
```bash
   sudo jamf recon
```
2. Check Jamf Pro logs for script execution errors
3. Verify script was saved correctly in Jamf Pro

---

### Issue: False "Unavailable or Disabled" Result

**Symptoms:**
- Microphone works fine
- EA reports disabled

**Diagnostic Steps:**

1. **Check Hardware Detection:**
```bash
   system_profiler SPAudioDataType | grep -i "built-in"
```
   Expected: Should show built-in input device

2. **Check ioreg:**
```bash
   ioreg -r -c IOAudioDevice -l | grep -i "built-in"
```
   Expected: Should show audio devices

3. **Check CoreAudio:**
```bash
   pgrep coreaudiod
```
   Expected: Should return process ID

**Resolution:**
- If all manual checks pass, report as bug
- Provide system details (model, macOS version)

---

### Issue: "External Microphone Detected" for Built-in Mic

**Symptoms:**
- Only built-in mic present
- EA reports external mic

**Causes:**
- Bluetooth device connected
- USB audio interface connected
- Built-in mic not set as default

**Resolution:**
1. Check System Settings → Sound → Input
2. Ensure built-in mic is selected as default
3. Disconnect external audio devices
4. Run `sudo jamf recon`

---

## Debug Mode

To enable detailed debugging, add to the script:
```bash
# Add at the start of perform_microphone_detection()
set -x  # Enable debug mode
```

Run manually:
```bash
sudo /path/to/microphone_check.sh 2>&1 | tee debug.log
```

---

## Performance Issues

### Script Takes Too Long

**Expected Duration:** 2-5 seconds  
**Problem Duration:** >10 seconds

**Possible Causes:**
- Slow `system_profiler` execution
- System under heavy load
- Network issues (shouldn't affect this script)

**Resolution:**
- Test on idle system
- Check for macOS updates
- Report if consistently slow

---

## Getting Help

1. **Check Logs:**
```bash
   # Jamf policy log
   tail -f /var/log/jamf.log | grep "microphone"
   
   # System log
   log show --predicate 'process == "jamf"' --last 1h
```

2. **Gather System Info:**
```bash
   # Create support bundle
   system_profiler SPAudioDataType > audio_info.txt
   system_profiler SPHardwareDataType > hardware_info.txt
   sw_vers > macos_version.txt
```

3. **Report Issue:**
   - Open GitHub issue with logs attached
   - Include system information
   - Describe expected vs actual behavior

---

## Contact

For issues not covered here, please open an issue on GitHub:
https://github.com/Sunshine-was-here/jamf-microphone-detection/issues
