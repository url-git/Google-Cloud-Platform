from google.cloud import videointelligence
import os

# Ścieżka do pliku z danymi autoryzacyjnymi GCS pobrana ze zmiennej środowiskowej
credentials_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials_path

"""Transkrypcja mowy z wideo przechowywanego na GCS."""

# Inicjalizacja klienta Video Intelligence
video_client = videointelligence.VideoIntelligenceServiceClient()
features = [videointelligence.Feature.SPEECH_TRANSCRIPTION]

# Konfiguracja transkrypcji mowy
config = videointelligence.SpeechTranscriptionConfig(
    language_code="en-US", enable_automatic_punctuation=True
)
video_context = videointelligence.VideoContext(speech_transcription_config=config)

# Rozpoczęcie operacji analizy wideo
operation = video_client.annotate_video(
    request={
        "features": features,
        "input_uri": "gs://data_stream_gcs/011_Video-Intelligence-APIs-for-Video-Transcription-With-Python/JaneGoodall.mp4",
        "video_context": video_context,
    }
)

print("\nPrzetwarzanie wideo w celu transkrypcji mowy.")

# Oczekiwanie na wynik
result = operation.result(timeout=600)

# W analizie jest tylko jeden wynik, ponieważ przetwarzane jest tylko jedno wideo
annotation_results = result.annotation_results[0]
for speech_transcription in annotation_results.speech_transcriptions:

    # Liczba alternatyw dla każdej transkrypcji jest ograniczona przez
    # SpeechTranscriptionConfig.max_alternatives.
    # Każda alternatywa to inna możliwa transkrypcja
    # i ma swój własny wynik zaufania.
    for alternative in speech_transcription.alternatives:
        print("Informacje na poziomie alternatyw:")

        print("Transkrypt: {}".format(alternative.transcript))
        print("Zaufanie: {}\n".format(alternative.confidence))

        print("Informacje na poziomie słów:")
        for word_info in alternative.words:
            word = word_info.word
            start_time = word_info.start_time
            end_time = word_info.end_time
            print(
                "\t{}s - {}s: {}".format(
                    start_time.seconds + start_time.microseconds * 1e-6,
                    end_time.seconds + end_time.microseconds * 1e-6,
                    word,
                )
            )