from google.cloud import videointelligence
import os

# Ścieżka do pliku z danymi autoryzacyjnymi GCS pobrana ze zmiennej środowiskowej
credentials_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials_path

# Ścieżka do pliku wyjściowego
output_file = "transcription.txt"

# Inicjalizacja klienta Video Intelligence
video_client = videointelligence.VideoIntelligenceServiceClient()
features = [videointelligence.Feature.SPEECH_TRANSCRIPTION]

# Konfiguracja transkrypcji mowy
config = videointelligence.SpeechTranscriptionConfig(
    language_code="pl-PL",  # Kod języka polskiego
    enable_automatic_punctuation=True
)
video_context = videointelligence.VideoContext(speech_transcription_config=config)

# Rozpoczęcie operacji analizy wideo
operation = video_client.annotate_video(
    request={
        "features": features,
        "input_uri": "gs://data_stream_gcs/011_Video-Intelligence-APIs-for-Video-Transcription-With-Python/The X-Files S01E24 The Erlenmeyer Flask.avi",
        "video_context": video_context,
    }
)

print("\nPrzetwarzanie wideo w celu transkrypcji mowy.")

# Oczekiwanie na wynik
result = operation.result(timeout=6000)

# Otwarcie pliku do zapisu
with open(output_file, "w") as file:
    # Przechodzenie przez wyniki transkrypcji
    annotation_results = result.annotation_results[0]
    for speech_transcription in annotation_results.speech_transcriptions:
        # Przechodzenie przez każdą alternatywę w transkrypcji
        for alternative in speech_transcription.alternatives:
            transcription_text = alternative.transcript.strip()  # Wydobycie tekstu transkrypcji
            if transcription_text:  # Sprawdzenie, czy transkrypcja nie jest pusta
                file.write(transcription_text + "\n")  # Zapisanie tekstu do pliku
                print("Zapisano transkrypt do pliku:", transcription_text)  # Informacja o zapisie