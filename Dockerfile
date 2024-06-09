FROM python:3.10-slim-bullseye

WORKDIR /build
COPY requirements.txt .

RUN true && \
    apt update && \
    apt install -y wget procps vim ffmpeg && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y && \
    pip install -r requirements.txt && \
    rm -rf google-chrome-stable_current_amd64.deb && \
    cd /usr/local/lib/python3.10/site-packages/DrissionPage/_configs/ && \
    sed -i "/browser_path/s/$(grep 'browser_path' 'configs.ini' | awk -F '=' '{print $2}')/\/usr\/bin\/google-chrome/" configs.ini && \
    sed -i "/arguments/s/\[/\[\'--no-sandbox\', \'--headless=new\', /" configs.ini

WORKDIR /app
CMD ["python"]
