FROM fedora:rawhide

ENV APP_ROOT="/opt/astuto"
USER 0
COPY . ${APP_ROOT}

# Install all dependencies
# Replace regular configs with configs for CI
RUN set -x && cd ${APP_ROOT} && \
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    sudo dnf update -y && \
    \
    ./setup.sh \
    \
    dnf autoremove -y && \
    dnf clean all

RUN set -x && cd ${APP_ROOT} && \
    rm *.lock ; \
    sed -i 's/~> />= /g' Gemfile && \
    bundle install --local && \
    yarn install --check-files

# Add a script to be executed every time the container starts.
ENTRYPOINT ["./docker-entrypoint.sh"]

WORKDIR ${APP_ROOT}

EXPOSE 3000
