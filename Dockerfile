FROM python:3.10.12-slim

WORKDIR /opt/uvr-webui

COPY . .

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip==24.1.2 \
    && python -m pip install -r requirements.txt



ENV PATH="/opt/uvr-webui/env/bin:$PATH"

ENV PYTHONUNBUFFERED=1

VOLUME [ "/opt/uvr-webui/modelss" ]
VOLUME [ "/opt/uvr-webui/outputs" ]
VOLUME [ "/opt/uvr-webui/inputs" ]

EXPOSE 7860


CMD ["python", "app.py"]
