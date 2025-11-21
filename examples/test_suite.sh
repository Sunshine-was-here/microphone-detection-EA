<?xml version="1.0" encoding="UTF-8"?>
<!--
  Smart Group Criteria Examples for Jamf Pro
  Use as reference when creating Smart Groups in Jamf Pro
-->
<smart_groups>
  
  <!-- Disabled Built-in Microphones -->
  <smart_group>
    <name>Macs - Built-in Microphone Disabled</name>
    <description>Computers with physically disabled built-in microphones (hardware kill switch)</description>
    <criteria>
      <criterion>
        <name>Built-in Microphone Status</name>
        <priority>0</priority>
        <and_or>and</and_or>
        <search_type>is</search_type>
        <value>Unavailable or Disabled</value>
      </criterion>
    </criteria>
  </smart_group>
  
  <!-- Working Microphones -->
  <smart_group>
    <name>Macs - Built-in Microphone Working</name>
    <description>Computers with functional built-in microphones</description>
    <criteria>
      <criterion>
        <name>Built-in Microphone Status</name>
        <priority>0</priority>
        <and_or>and</and_or>
        <search_type>is</search_type>
        <value>Available and Working</value>
      </criterion>
    </criteria>
  </smart_group>
  
  <!-- Software Restricted -->
  <smart_group>
    <name>Macs - Microphone Software Restricted</name>
    <description>Computers with microphone hardware present but software restricted</description>
    <criteria>
      <criterion>
        <name>Built-in Microphone Status</name>
        <priority>0</priority>
        <and_or>and</and_or>
        <search_type>is</search_type>
        <value>Available but Restricted</value>
      </criterion>
    </criteria>
  </smart_group>
  
  <!-- External Microphones -->
  <smart_group>
    <name>Macs - Using External Microphone</name>
    <description>Computers using external microphones (built-in disabled)</description>
    <criteria>
      <criterion>
        <name>Built-in Microphone Status</name>
        <priority>0</priority>
        <and_or>and</and_or>
        <search_type>is</search_type>
        <value>External Microphone Detected</value>
      </criterion>
    </criteria>
  </smart_group>

</smart_groups>
