# Dockerfile
FROM fedora:latest

# Copy source files
COPY . .

# Install required tools and development dependencies
RUN dnf -y update && \
    dnf -y install \
        dnf-plugins-core \
        rpm-build \
        rpmdevtools \
        gcc \
        make \
        git \
        curl \
        hidapi-devel \
        systemd-devel \
        pkgconf-pkg-config \
        python3 \
        which \
        npm \
        && dnf clean all

# Install latest stable Rust using rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Create RPM build environment
RUN rpmdev-setuptree

# Install Node.js dependencies and build project
RUN npm install --production && \
    npm run-script build

# Set default entrypoint
ENTRYPOINT ["node", "/lib/main.js"]
