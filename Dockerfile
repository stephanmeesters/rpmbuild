# Using almalinux:latest as base image for this container
FROM almalinux:latest

# Copy source files
COPY . .

# Enable PowerTools (AlmaLinux 8) or CRB (AlmaLinux 9) and install EPEL
RUN dnf install -y dnf-plugins-core && \
    (dnf config-manager --set-enabled crb || dnf config-manager --set-enabled powertools) && \
    dnf install -y epel-release

# Install core tools and development libraries
RUN dnf install -y \
    rpm-build rpmdevtools gcc make python3 git nodejs yum-utils curl \
    hidapi-devel systemd-devel && \
    dnf clean all

# Install the latest stable Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path && \
    ln -s $HOME/.cargo/bin/rustc /usr/local/bin/rustc && \
    ln -s $HOME/.cargo/bin/cargo /usr/local/bin/cargo

# Show installed Rust version (for confirmation/logs)
RUN rustc --version && cargo --version

# Install Node.js dependencies and build project
RUN npm install --production && \
    npm run-script build

# Set default entrypoint
ENTRYPOINT ["node", "/lib/main.js"]
