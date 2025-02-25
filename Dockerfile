FROM continuumio/miniconda3:25.1.1-2

# Ustawienie katalogu roboczego
WORKDIR /opt/uvr-webui

# Kopiowanie całej zawartości repozytorium do obrazu
COPY . .

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Tworzenie środowiska Conda oraz instalacja zależności
RUN conda create --prefix ./env python=3.10.12 -y && \
    ./env/bin/python -m pip install "pip==24.1.2" && \
    ./env/bin/python -m pip install -r requirements.txt && \
    ./env/bin/python -m pip uninstall -y torch torchvision && \
    ./env/bin/python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

# Ustawienie ścieżki, aby używać Pythona z utworzonego środowiska
ENV PATH="/opt/uvr-webui/env/bin:$PATH"
# Wymuszenie natychmiastowego wypisywania logów przez Pythona
ENV PYTHONUNBUFFERED=1

# Udostępnienie portu (domyślnie 7860)
EXPOSE 7860

# Domyślna komenda uruchamiająca aplikację
CMD ["python", "app.py"]
