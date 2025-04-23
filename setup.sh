#!/bin/bash
# Gerrit & GitWeb Installation Script
# Author: [Your Name]
# Version: 1.0

set -e  # Exit on error

# Define Gerrit site directory
GERRIT_SITE=~/gerrit_testsite

echo "Updating package list..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y openjdk-11-jre git gitweb apache2

# Download Gerrit
echo "Downloading Gerrit..."
wget https://gerrit-releases.storage.googleapis.com/gerrit-3.9.4.war -O gerrit.war

# Initialize Gerrit
echo "Initializing Gerrit..."
java -jar gerrit.war init --batch --dev -d $GERRIT_SITE

# Configure GitWeb in Gerrit
echo "Configuring GitWeb..."
git config -f $GERRIT_SITE/etc/gerrit.config gitweb.type gitweb
git config -f $GERRIT_SITE/etc/gerrit.config gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi
git config -f $GERRIT_SITE/etc/gerrit.config gitweb.url http://localhost/gitweb.cgi

# Enable Apache CGI Module
echo "Enabling CGI for Apache..."
sudo a2enmod cgi
sudo systemctl restart apache2

# Restart Gerrit
echo "Restarting Gerrit..."
$GERRIT_SITE/bin/gerrit.sh restart

echo "Installation complete! Access Gerrit at: http://localhost:8080"
echo "Access GitWeb at: http://localhost/gitweb"

echo "You can now start using Gerrit and GitWeb."
echo "For more information, visit the official documentation."
echo "Gerrit: https://gerrit-review.googlesource.com/Documentation/linux-quickstart.html"
