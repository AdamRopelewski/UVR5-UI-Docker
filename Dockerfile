FROM python:3.10.12-slim

WORKDIR /opt/uvr-webui

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ffmpeg \
        wget \
        curl \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install CUDA 12.1 and cuDNN 9
RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        cuda-toolkit-12-1 \
        libcudnn9-cuda-12 \
    && rm -rf /var/lib/apt/lists/*

COPY . .
   
RUN python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt



ENV PATH="/opt/uvr-webui/env/bin:$PATH"
ENV PYTHONUNBUFFERED=1

VOLUME [ "/opt/uvr-webui/modelss", "/opt/uvr-webui/inputs", "/opt/uvr-webui/outputs" ]

EXPOSE 7860


CMD ["python", "app.py"]
