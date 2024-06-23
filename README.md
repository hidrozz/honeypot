# Cowrie Automation Installation
Honeypot adalah server atau sistem jaringan yang sengaja dipasang sebagai umpan untuk memikat hacker yang akan melakukan penyerangan atau peretasan. Dengan honeypot, kita bisa mengecoh hacker, mengumpulkan informasi penting, dan memperkuat keamanan jaringan.
Repositori ini berisi script otomatisasi untuk menginstal dan mengonfigurasi honeypot menggunakan Cowrie, serta menambahkan Prometheus Node Exporter untuk monitoring tambahan.
# Features
* Menginstal semua dependensi yang diperlukan
* Mengonfigurasi dan memulai Cowrie honeypot
* Menambahkan dan mengonfigurasi Prometheus Node Exporter untuk monitoring

# Prerequisites
* Sistem operasi berbasis Debian (Raspberry Pi 4)
* Akses root atau sudo

# Installation
--
Ikuti langkah-langkah di bawah ini untuk menginstal dan mengonfigurasi honeypot menggunakan script ini.

### Step 1: Clone Repository ###
Buka terminal dan clone repositori ini:

    git clone https://github.com/hidrozz/honeypot.git 
    cd honeypot
### Step 2: Make Script Executable ###
Sebelum menjalankan script, pastikan untuk membuatnya executable:

    chmod +x cowrie-automation.sh
### Step 3: Run Installation Script ###
Jalankan script instalasi dengan perintah berikut:

    ./cowrie-automation.sh
Script ini akan melakukan langkah-langkah berikut secara otomatis:

1. Update Sistem:

       sudo apt-get update -y
2. Menginstal Dependensi Sistem:

       sudo apt-get install -y git python3-venv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind
3. Membuat Akun Pengguna 'cowrie':

       sudo adduser --disabled-password --gecos "" cowrie

4. Meng-clone Repository Cowrie:

       sudo -u cowrie git clone https://github.com/cowrie/cowrie /home/cowrie/cowrie
5. Menyiapkan Virtual Environment:

       sudo -u cowrie python3 -m venv /home/cowrie/cowrie/cowrie-env
6. Mengaktifkan Virtual Environment dan Menginstal Paket yang Diperlukan:

        sudo -u cowrie /bin/bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && pip install --upgrade pip && pip install -r /home/cowrie/cowrie/requirements.txt'

7. Memulai Cowrie:
    
        sudo -u cowrie /bin/bash -c 'source /home/cowrie/cowrie/cowrie-env/bin/activate && cd /home/cowrie/cowrie && bin/cowrie start'

### Step 4: Install Prometheus Node Exporter ###
Script ini juga akan menginstal Prometheus Node Exporter untuk monitoring tambahan:
1. Mengunduh dan Mengekstrak Node Exporter:

        wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-arm64.tar.gz
        tar xvfz node_exporter-1.8.0.linux-arm64.tar.gz
        sudo mv node_exporter-1.8.0.linux-arm64/node_exporter /usr/local/bin/

2. Membuat Pengguna 'node_exporter'

        sudo useradd -rs /bin/false node_exporter
3. Membuat File Layanan systemd untuk Node Exporter:

        sudo tee /etc/systemd/system/node_exporter.service<<EOF
        [Unit]
        Description=Node Exporter
        After=network.target
        
        [Service]
        User=node_exporter
        Group=node_exporter
        Type=simple
        ExecStart=/usr/local/bin/node_exporter
        
        [Install]
        WantedBy=multi-user.target
        EOF
4. Memulai dan Mengaktifkan Layanan Node Exporter:

        sudo systemctl daemon-reload
        sudo systemctl start node_exporter
        sudo systemctl enable node_exporter

### Step 5: Verify Installation ###
Periksa status layanan Node Exporter:
        
        sudo systemctl status node_exporter


