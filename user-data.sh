#!/bin/bash
# Update the package index
yum update -y

# Install dependencies
yum install -y curl jq tar
yum install -y libicu nodejs

# Create a folder for the GitHub Actions runner as ec2-user
sudo -u ec2-user mkdir -p /home/ec2-user/actions-runner
cd /home/ec2-user/actions-runner

# Download the latest runner package as ec2-user
RUNNER_VERSION="2.323.0"
#RUNNER_ARCH="arm64"
RUNNER_ARCH="x64"
RUNNER_TAR="actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TAR}"

echo "Downloading GitHub Actions runner from ${RUNNER_URL}"
sudo -u ec2-user curl -o ${RUNNER_TAR} -L ${RUNNER_URL}

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the runner package. Exiting."
    exit 1
fi

# Extract the installer as ec2-user
echo "Extracting ${RUNNER_TAR}"
sudo -u ec2-user tar xzf ./${RUNNER_TAR}

# List the contents of the directory to verify extraction
echo "Contents of the /home/ec2-user/actions-runner directory after extraction:"
sudo -u ec2-user ls -la /home/ec2-user/actions-runner

# Ensure the run.sh script is present
if [ ! -f ./run.sh ]; then
    echo "run.sh script not found after extraction. Exiting."
    exit 1
fi
GITHUB_ORG="sidharthvijayakumar"
GITHUB_REPO="Opentofu"
#GITHUB_PAT=""
#Pat to be stored in Secret Manager
GITHUB_PAT=$(aws secretsmanager get-secret-value \
  --secret-id github-pat \
  --query SecretString \
  --output text | jq -r .GITHUB_PAT)

REG_TOKEN=$(curl -s \
  -X POST \
  -H "Authorization: token ${GITHUB_PAT}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/actions/runners/registration-token | jq -r .token)

# Configure the runner as ec2-user
sudo -u ec2-user chmod +x config.sh
sudo -u ec2-user ./config.sh --url https://github.com/sidharthvijayakumar/Opentofu --token ${REG_TOKEN} --unattended --name git-hub-x86-runner

# Check if the configuration was successful
if [ $? -ne 0 ]; then
    echo "Runner configuration failed. Exiting."
    exit 1
fi

# Create a custom script to keep the runner running as ec2-user
sudo -u ec2-user bash -c 'cat <<EOF > /home/ec2-user/actions-runner/start-runner.sh
#!/bin/bash

# Navigate to the runner directory
cd /home/ec2-user/actions-runner

# Loop to keep the runner running
while true; do
    ./run.sh
    if [ $? -ne 0 ]; then
        echo "Runner exited with non-zero status. Restarting..."
    fi
    sleep 5
done
EOF'

# Make the custom script executable as ec2-user
sudo -u ec2-user chmod +x /home/ec2-user/actions-runner/start-runner.sh

# Create a systemd service file for the runner
cat <<EOF > /etc/systemd/system/github-actions-runner.service
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
ExecStart=/home/ec2-user/actions-runner/start-runner.sh
User=ec2-user
WorkingDirectory=/home/ec2-user/actions-runner
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable github-actions-runner

# Start the service
systemctl start github-actions-runner

# Check the status of the service
systemctl status github-actions-runner