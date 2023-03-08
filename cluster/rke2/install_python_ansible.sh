# Use the following command to install prerequisites for Python before installing it.
sudo yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel -y

# Download Python using following command from python official site
cd /opt
sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz

# Now extract the downloaded package.
sudo tar xzf Python-3.8.12.tgz

# Use below set of commands to compile python source code on your system using altinstall.
cd Python-3.8.12
sudo ./configure --enable-optimizations
sudo make altinstall

# 
export PATH=/usr/local/bin:$PATH

# Get python version
python3.8 -V

# Try to update pip version
python3.8 -m pip install --upgrade pip

# Get pip version
pip3 -V

# Now remove downloaded source archive file from your system
sudo rm /opt/Python-3.8.12.tgz

# Install ansible by using pip3
python3.8 -m pip install ansible

# Get ansiible version
ansible --version
