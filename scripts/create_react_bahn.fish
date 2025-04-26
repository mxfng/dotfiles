#!/usr/bin/env fish

echo "Enter project name"
read project_name
curl -s https://raw.githubusercontent.com/mxfng/react-bahn/main/setup.sh | bash -s $project_name
