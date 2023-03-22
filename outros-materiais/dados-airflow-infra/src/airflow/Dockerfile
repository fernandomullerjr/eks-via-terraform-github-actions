FROM apache/airflow:2.3.3
RUN pip install --no-cache-dir 'apache-airflow[amazon]'
RUN pip install apache-airflow-providers-http apache-airflow-providers-slack apache-airflow-providers-slack[http]
RUN pip install aiohttp