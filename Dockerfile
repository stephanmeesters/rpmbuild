# Using almalinux:latest as base image for this container
FROM almalinux:latest

# Copying all contents of rpmbuild repo inside container
COPY . .

# Enable PowerTools/CRB for -devel packages (needed for hidapi-devel, systemd-devel)
RUN dnf install -y dnf-plugins-core && \
    (dnf config-manager --set-enabled crb || dnf config-manager --set-enabled powertools) && \
    dnf install -y epel-release

# Install tools needed for rpmbuild, based on BuildRequires in .spec
RUN dnf install -y \
    rpm-build rpmdevtools gcc make python3 git nodejs yum-utils \
    hidapi-devel systemd-devel && \
    dnf clean all

# Install Node.js dependencies and build the project
RUN npm install --production && \
    npm run-script build

# Set the default entrypoint
ENTRYPOINT ["node", "/lib/main.js"]
