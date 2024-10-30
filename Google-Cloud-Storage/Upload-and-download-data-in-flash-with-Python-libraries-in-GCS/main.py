import os
from google.cloud import storage
from dotenv import load_dotenv

# Wczytanie zmiennych środowiskowych z pliku env.sh
load_dotenv('/Users/p/Documents/VSC/Google-Cloud-Platform/Google-Cloud-Storage/Upload-and-download-data-in-flash-with-Python-libraries-in-GCS/env.sh')

""" Tworzenie Bucketu """

# Nazwa nowego bucketu
bucket_name = "data_stream_gcs_123"

def create_bucket_class_location(bucket_name):
    """
    Tworzy nowe wiaderko w regionie EU z klasą przechowywania STANDARD.
    """
    # Inicjalizacja klienta storage
    storage_client = storage.Client()

    # Konfiguracja wiaderka
    bucket = storage_client.bucket(bucket_name)
    bucket.storage_class = "STANDARD"
    new_bucket = storage_client.create_bucket(bucket, location="eu")

    # Informacja o nowo utworzonym wiaderku
    print(
        "Utworzono wiaderko {} w {} z klasą przechowywania {}".format(
            new_bucket.name, new_bucket.location, new_bucket.storage_class
        )
    )
    return new_bucket

""" Lista Bucketów """

def list_buckets():
    """Wyświetla wszystkie bucket'y."""

    storage_client = storage.Client()
    buckets = storage_client.list_buckets()

    for bucket in buckets:
        print(bucket.name)

""" Uzyskiwanie informacji o metadanych Bucketu """

def bucket_metadata(bucket_name):
    """Wyświetla metadane bucketu."""

    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)

    print(f"ID: {bucket.id}")
    print(f"Nazwa: {bucket.name}")
    print(f"Klasa przechowywania: {bucket.storage_class}")
    print(f"Lokalizacja: {bucket.location}")
    print(f"Typ lokalizacji: {bucket.location_type}")
    print(f"CORS: {bucket.cors}")
    print(f"Domyślna blokada zdarzeń: {bucket.default_event_based_hold}")
    print(f"Domyślna nazwa klucza KMS: {bucket.default_kms_key_name}")
    print(f"Metageneracja: {bucket.metageneration}")
    print(f"Zapobieganie dostępowi publicznemu: {bucket.iam_configuration.public_access_prevention}")
    print(f"Czas obowiązywania polityki przechowywania: {bucket.retention_policy_effective_time}")
    print(f"Okres przechowywania: {bucket.retention_period}")
    print(f"Polityka przechowywania zablokowana: {bucket.retention_policy_locked}")
    print(f"Tryb przechowywania obiektów: {bucket.object_retention_mode}")
    print(f"Koszt ponoszony przez wnioskodawcę: {bucket.requester_pays}")
    print(f"Link do obiektu: {bucket.self_link}")
    print(f"Czas utworzenia: {bucket.time_created}")
    print(f"Wersjonowanie włączone: {bucket.versioning_enabled}")
    print(f"Etykiety: {bucket.labels}")

""" Wgrywanie pliku do bucketu """

bucket_name = "data_stream_gcs"
source_file_name = "/Users/p/Movies/The X-Files S01E01 Pilot.avi"
destination_blob_name = "011_Video-Intelligence-APIs-for-Video-Transcription-With-Python/The X-Files S01E01 Pilot.avi"

def upload_blob(bucket_name, source_file_name, destination_blob_name):
    """Wgrywa plik do bucketu."""

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print(
        f"Plik {source_file_name} wgrany do {destination_blob_name}."
    )

""" Uzyskiwanie ACL obiektu """

bucket_name = "ecommerce_ml"
blob_name = 'model/explanation_metadata.json'

def print_blob_acl(bucket_name, blob_name):
    """Wyświetla listę kontroli dostępu (ACL) dla obiektu."""

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)

    for entry in blob.acl:
        print(f"{entry['role']}: {entry['entity']}")

""" Lista wszystkich obiektów w bucketie """

bucket_name = "ecommerce_ml"

def list_blobs(bucket_name):
    """Wyświetla wszystkie obiekty w bucketie."""

    storage_client = storage.Client()

    blobs = storage_client.list_blobs(bucket_name)

    for blob in blobs:
        print(blob.name)

""" Prześlij wiele obiektów równolegle za pomocą menedżera transferu """

bucket_name = "data_stream_gcs"
filenames = ["The X-Files S01E02 Deep Throat.avi", "The X-Files S01E10 Fallen Angel.avi"]
source_directory = "/Users/p/Movies/"
workers = 8

def upload_many_blobs_with_transfer_manager(
    bucket_name, filenames, source_directory, workers
):
    """Prześlij każdy plik z listy do kontenera, jednocześnie w puli procesów.

    Każda nazwa blobu jest pochodną nazwy pliku, nie wliczając parametru
    `source_directory`. Aby uzyskać pełną kontrolę nad nazwą blobu dla każdego
    pliku (i innych aspektów indywidualnych metadanych blobu), użyj zamiast tego
    transfer_manager.upload_many().
    """

    from google.cloud.storage import Client, transfer_manager
    import datetime

    storage_client = Client()
    bucket = storage_client.bucket(bucket_name)

    print("Czas rozpoczęcia:", datetime.datetime.now())

    results = transfer_manager.upload_many_from_filenames(
        bucket, filenames, source_directory=source_directory, max_workers=workers
    )

    for name, result in zip(filenames, results):
        if isinstance(result, Exception):
            print("Nie udało się przesłać {} z powodu wyjątku: {}".format(name, result))
        else:
            print("Przesłano {} do {}.".format(name, bucket.name))
    print("Czas zakończenia:", datetime.datetime.now())

""" Wgrywanie dużych plików w częściach """

bucket_name = "data_stream_gcs"
source_filename = "/home/demo1.mov"
destination_blob_name = "demo1.mov"
workers = 8

def upload_chunks_concurrently(
    bucket_name,
    source_filename,
    destination_blob_name,
    chunk_size=32 * 1024 * 1024,
    workers=8,
):
    """Wgrywa pojedynczy plik w częściach, równolegle w puli procesów."""

    from google.cloud.storage import Client, transfer_manager
    import datetime

    print("Czas rozpoczęcia:", datetime.datetime.now())
    storage_client = Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    transfer_manager.upload_chunks_concurrently(
        source_filename, blob, chunk_size=chunk_size, max_workers=workers
    )

    print(f"Plik {source_filename} wgrany do {destination_blob_name}.")
    print("Czas zakończenia:", datetime.datetime.now())

# upload_chunks_concurrently(bucket_name, source_filename, destination_blob_name, chunk_size=32 * 1024 * 1024, workers=8)


""" Pobieranie wielu plików """

bucket_name = "data_stream_gcs"
blob_names = ["demo1.mov", "input_batch_data.csv", "ind_niftyrealtylist.csv"]  # Lista nazw obiektów
destination_directory = "/home/downloads"  # Katalog docelowy
workers = 8  # Liczba wątków roboczych

def download_many_blobs_with_transfer_manager(
    bucket_name, blob_names, destination_directory, workers=8
):
    """Pobierz obiekty z listy według nazwy, równolegle w puli procesów.

    Nazwa pliku każdego obiektu po pobraniu jest wyprowadzana z nazwy obiektu i
    parametru `destination_directory`. Aby uzyskać pełną kontrolę nad nazwą pliku
    każdego obiektu, użyj zamiast tego transfer_manager.download_many().

    Katalogi będą tworzone automatycznie w razie potrzeby, aby pomieścić obiekty
    o nazwach zawierających znaki ukośnika.
    """
    from google.cloud.storage import Client, transfer_manager  # Import wymaganych modułów

    storage_client = Client()  # Inicjalizacja klienta storage
    bucket = storage_client.bucket(bucket_name)  # Pobranie wiaderka

    # Pobranie obiektów do podanego katalogu, równolegle w puli procesów
    results = transfer_manager.download_many_to_path(
        bucket, blob_names, destination_directory=destination_directory, max_workers=workers
    )

    # Sprawdzenie wyników pobierania
    for name, result in zip(blob_names, results):
        # Lista wyników jest albo `None`, albo wyjątkiem dla każdego obiektu
        # w liście wejściowej, w kolejności.

        if isinstance(result, Exception):
            print("Nie udało się pobrać {} z powodu wyjątku: {}".format(name, result))
        else:
            print("Pobrano {} do {}.".format(name, destination_directory + name))


# download_many_blobs_with_transfer_manager(bucket_name, blob_names, destination_directory, workers=8)

""" Usuwanie wiaderka """

bucket_name = "data_stream_gcs"  # Nazwa wiaderka do usunięcia

def delete_bucket(bucket_name):
    """Usuwa wiaderko. Wiaderko musi być puste."""
    storage_client = storage.Client()  # Inicjalizacja klienta storage

    bucket = storage_client.get_bucket(bucket_name)  # Pobranie wiaderka
    bucket.delete()  # Usunięcie wiaderka

    print(f"Wiadro {bucket.name} zostało usunięte.")  # Informacja o usunięciu wiaderka

# delete_bucket(bucket_name)  # Wywołanie funkcji do usunięcia wiaderka


if __name__ == "__main__":
    # create_bucket_class_location(bucket_name) # Create Bucket
    # list_buckets() # List Buckets
    # bucket_metadata("data_stream_gcs") # Get Bucket metadata info
	# upload_blob(bucket_name, source_file_name, destination_blob_name) # Uploads a file to the bucket
    # print_blob_acl(bucket_name, blob_name) # Get object's ACLs
    # list_blobs(bucket_name) # List all objcet in a bucket
    # upload_many_blobs_with_transfer_manager(bucket_name, filenames, source_directory, workers) # Prześlij wiele obiektów równolegle za pomocą menedżera transferu