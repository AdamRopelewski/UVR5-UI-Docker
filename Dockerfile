FROM continuumio/miniconda3:25.1.1-2


WORKDIR /opt/uvr-webui


COPY . .

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN conda create --prefix ./env python=3.10.12 -y && \
    ./env/bin/python -m pip install "pip==24.1.2" && \
    ./env/bin/python -m pip install -r requirements.txt


ENV PATH="/opt/uvr-webui/env/bin:$PATH"

ENV PYTHONUNBUFFERED=1

VOLUME [ "/opt/uvr-webui/modelss" ]
VOLUME [ "/opt/uvr-webui/outputs" ]
VOLUME [ "/opt/uvr-webui/inputs" ]

EXPOSE 7860


CMD ["python", "app.py"]
