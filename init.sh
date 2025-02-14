#!bin/bash

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd frappe-bench
    bench start
else
    echo "Creating new bench..."
fi

export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"
echo $PATH

bench init --skip-redis-config-generation frappe-bench

cd frappe-bench

# Use containers instead of localhost
bench set-mariadb-host mysql-capsule-kapw-mysql-master.erp-next-staging-eiho.svc.cluster.local:3306
bench set-redis-cache-host redis-capsule-yndv.erp-next-staging-eiho:6379
bench set-redis-queue-host redis-capsule-yndv.erp-next-staging-eiho:6379
bench set-redis-socketio-host redis-capsule-yndv.erp-next-staging-eiho:6379

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app erpnext
bench get-app hrms

bench new-site erp-next-qnxo.codecapsules.co.za \
--force \
--mariadb-root-password 1cc5083f-c881-87b3-c065-54956ed62c73 \
--admin-password admin \
--no-mariadb-socket

bench --site erp-next-qnxo.codecapsules.co.za install-app hrms
bench --site erp-next-qnxo.codecapsules.co.za set-config developer_mode 1
bench --site erp-next-qnxo.codecapsules.co.za enable-scheduler
bench --site erp-next-qnxo.codecapsules.co.za clear-cache
bench use erp-next-qnxo.codecapsules.co.za

bench start