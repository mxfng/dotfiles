#!/usr/bin/env fish

function log -a message
    set_color blue
    echo -n "==> "
    set_color normal
    echo "$message"
end

set -l docker_config $HOME/.config/docker
set -l legacy_docker $HOME/.docker

log "aligning docker config at $docker_config"

# Ensure XDG docker path exists
mkdir -p $docker_config/cli-plugins

# Make compose plugin visible when Docker Desktop installs it under ~/.docker
if test -x $legacy_docker/cli-plugins/docker-compose
    and not test -e $docker_config/cli-plugins/docker-compose
    ln -sf $legacy_docker/cli-plugins/docker-compose $docker_config/cli-plugins/docker-compose
end

# Preserve existing contexts from legacy location
if test -d $legacy_docker/contexts
    and not test -e $docker_config/contexts
    mkdir -p $docker_config/contexts
    rsync -a $legacy_docker/contexts/ $docker_config/contexts/
end
