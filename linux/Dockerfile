# Copied mostly from
# https://github.com/conda-forge/miniforge-images/blob/a03a6b80a072c2318a315311d14a6b87582ba932/ubuntu/Dockerfile#L1
# and modified to work with centos 7.
#
# We do not want to use the original ubuntu focal because it is too new. We want to
# support older Linux distros.

FROM centos:7

ARG MINIFORGE_NAME=Mambaforge
ARG MINIFORGE_VERSION=23.1.0-1

ENV CONDA_DIR=/opt/conda
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}

# 1. Install just enough for conda to work
# 2. Keep $HOME clean (no .wget-hsts file), since HSTS isn't useful in this context
# 3. Install miniforge from GitHub releases
# 4. Apply some cleanup tips from https://jcrist.github.io/conda-docker-tips.html
#    Particularly, we remove pyc and a files. The default install has no js, we can skip that
# 5. Activate base by default when running as any *non-root* user as well
#    Good security practice requires running most workloads as non-root
#    This makes sure any non-root users created also have base activated
#    for their interactive shells.
# 6. Activate base by default when running as root as well
#    The root user is already created, so won't pick up changes to /etc/skel
RUN yum install -y wget bzip2 ca-certificates git && \
    yum clean all -y && \
    wget --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean --tarballs --index-cache --packages --yes && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean --force-pkgs-dirs --all --yes  && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc

RUN mamba create --yes --name py3.11 python=3.11 && \
    /opt/conda/envs/py3.11/bin/python -m pip install pyinstaller
ENV PATH=/opt/conda/envs/py3.11/bin:${PATH}

# Projects should be mounted at /work.
WORKDIR /work
COPY run-pyinstaller.sh /usr/local/bin/
ENTRYPOINT ["bash", "/usr/local/bin/run-pyinstaller.sh"]
