#!/bin/bash

# Lê as configurações do arquivo de configuração
source /innerbit/backup_nuvem/config.conf

# Redireciona saída padrão e de erro para o arquivo de log
exec > >(tee -i "$log_file") 2>&1

# Define a data e hora atual como o momento do backup
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Backup iniciado: $start_time"

# Faz o backup com o rclone
start_backup=$(date +%s)
rclone sync "$rclone_source" "$rclone_destination" --exclude "$rclone_exclude" --progress
end_backup=$(date +%s)

# Calcula o tempo de duração do backup
backup_duration=$((end_backup - start_backup))

# Verifica o status do backup
backup_status=$?
if [ $backup_status -eq 0 ]; then
    echo "Backup status: SUCESSO"
else
    echo "Backup status: ERRO"
fi

# Tamanho do backup
backup_size=$(rclone size "$rclone_destination" --json | jq -r '.bytes')
echo "Backup tamanho (bytes): $backup_size"

# Tempo de duração
echo "Backup duração (segundos): $backup_duration"

# Finaliza o script
echo "Backup concluído: $(date +"%Y-%m-%d %H:%M:%S")"

