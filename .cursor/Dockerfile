FROM cimg/android:2025.10

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv git \
  && rm -rf /var/lib/apt/lists/*

# Create venv and make it usable by 'circleci'
RUN python3 -m venv /opt/venv && chown -R circleci:circleci /opt/venv
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Use the venv's pip to preinstall deps
RUN /opt/venv/bin/pip install --upgrade pip \
 && /opt/venv/bin/pip install perplexityai git+https://github.com/Lukafin/mony.git

USER circleci
WORKDIR /home/circleci/project