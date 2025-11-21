# Testing Guide

## Pre-Deployment Testing

### Local Testing (Before Jamf Deployment)

1. **Download Script:**
```bash
   curl -o microphone_check.sh https://raw.githubusercontent.com/YOUR_USERNAME/jamf-microphone-detection/main/microphone_check.sh
```

2. **Make Executable:**
```bash
   chmod +x microphone_check.sh
```

3. **Run Test:**
```bash
   sudo ./microphone_check.sh
```

4. **Expected Output:**
```xml
   <result>Available and Working</result>
```

### Test Suite

Run the comprehensive test suite:
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/jamf-microphone-detection.git
cd jamf-microphone-detection

# Make executable
chmod +x examples/test_suite.sh

# Run test suite
sudo ./examples/test_suite.sh
```

**Expected Results:**
- ✅ Baseline test: "Available and Working"
- ✅ Crash test: "Available but Restricted"
- ✅ Final verification: "Available and Working"

---

## Test Scenarios

### Scenario 1: Normal Operation
**Setup:** Standard MacBook with working microphone  
**Expected:** `Available and Working`
```bash
sudo ./microphone_check.sh
```

### Scenario 2: CoreAudio Crash Simulation
**Setup:** Kill CoreAudio daemon  
**Expected:** `Available but Restricted`
```bash
# Kill daemon
sudo killall coreaudiod

# Run check immediately
sudo ./microphone_check.sh

# Verify (daemon auto-restarts)
sleep 3 && sudo ./microphone_check.sh
# Should return to "Available and Working"
```

### Scenario 3: External Microphone
**Setup:** Connect USB/Bluetooth microphone  
**Expected:** Depends on whether built-in is disabled
```bash
# Connect external mic
# In System Settings: Sound → Input → Select external device

sudo ./microphone_check.sh
```

---

## Jamf Pro Testing

### Phase 1: Single Device Test

1. Create test Extension Attribute (copy script)
2. Scope to single test device
3. Run `sudo jamf recon` on device
4. Verify result in Jamf Pro inventory
5. Check execution time in policy logs

### Phase 2: Pilot Group Test

1. Create Smart Group: "EA Testing - Microphone Detection"
2. Add 5-10 diverse devices:
   - Intel Mac
   - Apple Silicon Mac
   - Different macOS versions (11-15)
   - Mix of MacBook models
3. Force inventory update
4. Review all results for consistency

### Phase 3: Production Rollout

1. Enable EA for all computers
2. Monitor first 24 hours for anomalies
3. Create reporting Smart Groups
4. Set up monitoring for unexpected results

---

## Validation Checklist

- [ ] Script executes without errors
- [ ] Returns expected result for test device
- [ ] Execution completes in <10 seconds
- [ ] No impact on system performance
- [ ] Results consistent across multiple runs
- [ ] Works on Intel Macs
- [ ] Works on Apple Silicon Macs
- [ ] Handles edge cases (external mics, crashes)
- [ ] Shellcheck passes with no warnings
- [ ] Documentation is clear and accurate

---

## Automated Testing

The repository includes automated ShellCheck validation via GitHub Actions. Every push and pull request automatically runs ShellCheck to ensure code quality.

---

## Performance Benchmarking

Test execution time across different systems:
```bash
# Run 10 times and average
for i in {1..10}; do
  time sudo ./microphone_check.sh
done
```

**Acceptable Range:** 2-5 seconds  
**Concerning:** >10 seconds

---

## Reporting Issues

When reporting test failures, include:

1. **System Information:**
```bash
   system_profiler SPHardwareDataType
   sw_vers
```

2. **Audio Configuration:**
```bash
   system_profiler SPAudioDataType
```

3. **Script Output:**
```bash
   sudo ./microphone_check.sh
```

4. **Expected vs Actual Result**

5. **Any Error Messages**

## Support

For testing assistance:
- [GitHub Issues](https://github.com/YOUR_USERNAME/jamf-microphone-detection/issues)
- [Documentation](https://github.com/YOUR_USERNAME/jamf-microphone-detection)
