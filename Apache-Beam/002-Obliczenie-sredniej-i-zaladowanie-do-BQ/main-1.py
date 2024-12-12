import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, GoogleCloudOptions, StandardOptions
from apache_beam.io.gcp.bigquery import WriteToBigQuery
import os

SERVICE_ACCOUNT_FILE = "/Users/p/Documents/sa/service_account.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = SERVICE_ACCOUNT_FILE

# Konfiguracja opcji pipeline
options = PipelineOptions()

# Ustawienia Google Cloud
gcp_options = options.view_as(GoogleCloudOptions) # Zwraca widok opcji skonkretyzowanych dla Google Cloud. Dzięki temu możemy łatwiej ustawiać parametry związane z GCP, takie jak projekt czy lokalizacje w Google Cloud Storage.
gcp_options.project = "your-project-id"
gcp_options.job_name = "dataflow-average-job"
gcp_options.staging_location = "gs://your-bucket/staging" # Określa lokalizację w Google Cloud Storage (GCS), gdzie Apache Beam będzie przechowywać pliki tymczasowe wymagane do działania potoku, takie jak skrypty czy pliki wynikowe.
gcp_options.temp_location = "gs://your-bucket/temp" # Określa lokalizację na dane tymczasowe, takie jak pliki robocze, które będą używane podczas przetwarzania danych i mogą być usunięte po zakończeniu zadania.

# Dataflow jako runner
options.view_as(StandardOptions).runner = "DataflowRunner"

# Dane wyjściowe w BigQuery
output_table = "your-project-id:your_dataset.your_table"

with beam.Pipeline(options=options) as p:
    numbers = p | "Create numbers" >> beam.Create([1, 2, 3, 4, 5])
    average = numbers | "Calculate mean" >> beam.combiners.Mean.Globally()
    output = average | "Format to BigQuery" >> beam.Map(lambda x: {'average': x})
    output | "Write to BigQuery" >> WriteToBigQuery(
        table=output_table,
        schema='SCHEMA_AUTODETECT',
        write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE,
        create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
    )