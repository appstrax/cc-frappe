#FROM frappe/erpnext:v15
FROM frappe/bench:latest

COPY ./init.sh .

CMD ["sh", "./init.sh"]