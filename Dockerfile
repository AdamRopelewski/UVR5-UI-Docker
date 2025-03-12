FROM python:3.10.12-slim

WORKDIR /UVR5-UI-Docker

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ffmpeg \
        wget \
        curl \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install CUDA 12.1 and cuDNN 9
RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb \
    && dpkg -i cuda-keyring_1.0-1_all.deb \
    && rm cuda-keyring_1.0-1_all.deb \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        cuda-toolkit-12-1 \
        libcudnn9-cuda-12 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN python -m pip install --upgrade pip \
    && pip install -U -r requirements.txt

COPY . .

ENV PATH="/UVR5-UI-Docker/env/bin:$PATH"
ENV PYTHONUNBUFFERED=1

VOLUME [ "/UVR5-UI-Docker/models", "/UVR5-UI-Docker/inputs", "/UVR5-UI-Docker/outputs" ]

CMD ["python", "app.py"]
