# Importowanie biblioteki Apache Beam
import apache_beam as beam  # Apache Beam to framework do przetwarzania danych strumieniowych i wsadowych.

# Importowanie modułów z biblioteki Apache Beam
from apache_beam import pvalue  # pvalue zawiera narzędzia do pracy z wartościami w Apache Beam.
from apache_beam import Create, FlatMap, Map, ParDo, Flatten, Partition  # Importowanie transformacji, takich jak tworzenie danych, mapowanie, płaskie mapowanie, itp.
from apache_beam import Values, CoGroupByKey  # Values i CoGroupByKey to operacje grupowania danych po kluczach.
from apache_beam import pvalue, window, WindowInto  # Importowanie modułu okien (window) do pracy z danymi w czasie.
from apache_beam.transforms import trigger  # Importowanie triggerów, które kontrolują, kiedy uruchamiać operacje na strumieniach danych.

# Importowanie narzędzi do pracy z interaktywnym trybem wykonania Apache Beam
from apache_beam.runners.interactive.interactive_runner import InteractiveRunner  # InteractiveRunner umożliwia uruchamianie Beam w trybie interaktywnym.
import apache_beam.runners.interactive.interactive_beam as ib  # Skrót do interaktywnych funkcji Apache Beam.

import time
import random
from datetime import datetime


'''	1.	import apache_beam as beam – Importuje główną bibliotekę Apache Beam, która zapewnia narzędzia do przetwarzania strumieniowego i wsadowego, czyli operacji na danych w czasie rzeczywistym i zbiorczych.
	2.	from apache_beam import pvalue – Importuje moduł pvalue, który pozwala na przechowywanie wartości w strumieniach Apache Beam.
	3.	from apache_beam import Create, FlatMap, Map, ParDo, Flatten, Partition – Importuje różne operacje transformujące w Apache Beam:
	•	Create: Tworzy początkowy strumień danych.
	•	FlatMap: Mapuje dane na nowy strumień, rozbijając złożone struktury.
	•	Map: Zastosowanie funkcji do każdego elementu w strumieniu.
	•	ParDo: Wywołanie funkcji dla każdego elementu w strumieniu, podobne do map(), ale bardziej elastyczne.
	•	Flatten: Łączy kilka strumieni w jeden.
	•	Partition: Dzieli strumień na różne podstrumienie.
	4.	from apache_beam import Values, CoGroupByKey – Importuje operacje związane z grupowaniem danych:
	•	Values: Grupuje dane według wartości.
	•	CoGroupByKey: Łączy dane po kluczach z różnych źródeł.
	5.	from apache_beam import pvalue, window, WindowInto – Importuje moduły do pracy z oknami w czasie:
	•	window: Moduł do pracy z danymi strumieniowymi, w których operacje są wykonywane w oknach czasowych.
	•	WindowInto: Określa, jak dane powinny być podzielone na okna czasowe.
	6.	from apache_beam.transforms import trigger – Importuje mechanizmy wyzwalania operacji na danych strumieniowych w określonych warunkach.
	7.	from apache_beam.runners.interactive.interactive_runner import InteractiveRunner – Importuje InteractiveRunner, który pozwala na uruchamianie Apache Beam w trybie interaktywnym, co jest przydatne w analizach danych w czasie rzeczywistym.
	8.	import apache_beam.runners.interactive.interactive_beam as ib – Skrót do funkcji interaktywnych Apache Beam, pozwalający na eksperymentowanie z przetwarzaniem danych w trybie interaktywnym.'''