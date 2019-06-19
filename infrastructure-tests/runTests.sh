#!/bin/bash -e

# Sanity check
if [ -z "$CX_INFRA_IT_CF_USERNAME" ]; then
    echo "Failure: Variable CX_INFRA_IT_CF_USERNAME is unset"
    exit 1
fi

if [ -z "$CX_INFRA_IT_CF_PASSWORD" ]; then
    echo "Failure: Variable CX_INFRA_IT_CF_PASSWORD is unset"
    exit 1
fi

set -x

# Start a local registry, to which we push the images built in this test, and from which they will be consumed in the test
docker run -d -p 5000:5000 --restart always --name registry registry:2 || true
find ../cx-server-companion -type f -exec sed -i -e 's/ppiper\/mta-archive-builder/localhost:5000\/ppiper\/mta-archive-builder/g' {} \;

# Copy over life cycle script for testing
cp ../cx-server-companion/life-cycle-scripts/{cx-server,server.cfg} .
mkdir -p jenkins-configuration
cp testing-jenkins.yml jenkins-configuration

docker build -t localhost:5000/ppiper/mta-archive-builder ../mta-archive-builder

docker tag localhost:5000/ppiper/mta-archive-builder ppiper/mta-archive-builder:latest

docker push localhost:5000/ppiper/mta-archive-builder:latest

# Boot our unit-under-test Jenkins master instance using the `cx-server` script
TEST_ENVIRONMENT=(CX_INFRA_IT_CF_USERNAME CX_INFRA_IT_CF_PASSWORD)
for var in "${TEST_ENVIRONMENT[@]}"
do
   export $var
   echo $var >> custom-environment.list
done
chmod +x cx-server
./cx-server start

# Use Jenkinsfile runner to orchastrate the example project build.
# See `Jenkinsfile` in this directory for details on what is happening.
docker run -v //var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workspace \
 -e CASC_JENKINS_CONFIG=/workspace/jenkins.yml -e HOST=$(hostname) \
 ppiper/jenkinsfile-runner

# cleanup
if [ ! "$TRAVIS" = true ] ; then
    rm -f cx-server server.cfg custom-environment.list
    echo "Modified your git repo, you might want to do a git checkout before re-running."
fi
