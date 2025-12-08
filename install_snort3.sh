#!/bin/bash

# Stop script execution immediately if any command fails
set -e

# =======================================================
# 1. System Update and Essential Dependencies Installation
# =======================================================

echo "### 1. Starting system update and essential dependency package installation..."

# Cleaned-up and consolidated list of packages for Snort 3
sudo apt update
sudo apt install -y \
    build-essential cmake autoconf libtool \
    libpcap-dev libnet1-dev libpcre3-dev libpcre2-dev \
    zlib1g-dev libssl-dev pkg-config \
    luajit libluajit-5.1-dev hwloc libhwloc-dev \
    libdumbnet-dev bison flex liblzma-dev 

echo "### 1. Package installation complete."
echo "-------------------------------------------------------"


# =======================================================
# 2. Build and Install LibDAQ (Snort Dependency)
# =======================================================

echo "### 2. Starting LibDAQ build and installation..."

# Create and move into the directory for source files
mkdir -p snort-source-files
cd snort-source-files/

# Download LibDAQ
git clone https://github.com/snort3/libdaq.git
cd libdaq/

# Build and install LibDAQ
./bootstrap
./configure
make -j$(nproc)  # Use multiple cores for faster compilation
sudo make install

# Move back to the parent directory
cd ..

echo "### 2. LibDAQ installation complete."
echo "-------------------------------------------------------"


# =======================================================
# 3. Build and Install Snort 3.0
# =======================================================

echo "### 3. Starting Snort 3.0 build and installation..."

# Download Snort 3
git clone https://github.com/snortadmin/snort3.git
cd snort3/

# Create and move into the build directory for CMake
mkdir build
cd build

# CMake configuration (Snort 3 settings)
cmake ..

# Build and install Snort 3
make -j$(nproc)  # Use multiple cores for faster compilation
sudo make install

echo "### 3. Snort 3.0 installation complete."
echo "-------------------------------------------------------"


# =======================================================
# 4. Finalization and Verification
# =======================================================

echo "### 4. Updating library paths and checking version..."

# Update newly installed library paths
sudo ldconfig

# Check Snort version (verify successful installation)
echo "✅ Snort 3.0 installation is complete."
snort -V


echo "### All installation steps completed successfully."

