#!/bin/bash

#
# This script modifies tomcat/conf/logging.properties to increase logging verbosity.
# It replaces 'org.apache.level=WARNING' with 'org.apache.level=INFO'.
#

tomcat_conf_dir="/opt/liferay/tomcat/conf"

line_org_apache="org.apache.level"
line_warning="$line_org_apache""=WARNING"
line_info="$line_org_apache""=INFO"


if [ -d "$tomcat_conf_dir" ]; then

  log_config_file="$tomcat_conf_dir/logging.properties"

  if [ -f "$log_config_file" ]; then
  
    echo "Current value: $(grep "$line_org_apache" "$log_config_file")"

    if grep -q "$line_warning" "$log_config_file"; then
  
      sed -i "s/$line_warning/$line_info/g" "$log_config_file"

      echo "Tomcat log level (org.apache) set to INFO in $log_config_file"
    fi
  else
    echo "File $log_config_file not found"
  fi
else
  echo "Dir $tomcat_conf_dir not found"
fi