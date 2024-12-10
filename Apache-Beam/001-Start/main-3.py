# Ten kod oblicza średnią wartość liczb w liście [1, 2, 3, 4, 5] za pomocą potoku przetwarzania Apache Beam z niestandardową funkcją kombinującą AverageFn.

import apache_beam as beam

class AverageFn(beam.CombineFn):
    def create_accumulator(self):
        return (0.0, 0)  # tuple to store sum and count

    def add_input(self, accumulator, input):
        sum, count = accumulator
        return sum + input, count + 1

    def merge_accumulators(self, accumulators):
        sums, counts = zip(*accumulators)
        return sum(sums), sum(counts)

    def extract_output(self, accumulator):
        sum, count = accumulator
        return sum / count if count else float('NaN')

with beam.Pipeline() as p:
    numbers = p | beam.Create([1, 2, 3, 4, 5])
    average = numbers | beam.CombineGlobally(AverageFn())
    average | 'Print output' >> beam.Map(print)

# 3.0

print('-'*50)

class AverageFn(beam.CombineFn):
    def create_accumulator(self):
        # Tworzy początkowy akumulator jako tuple: (sum = 0.0, count = 0)
        return (0.0, 0)

    def add_input(self, accumulator, input):
        # Aktualizuje akumulator na podstawie nowego elementu wejściowego.
        # Dane wejściowe:
        # - accumulator: aktualny stan akumulatora, np. (sum = 3.0, count = 2)
        # - input: nowy element, np. 4
        sum, count = accumulator
        # Zwraca zaktualizowany akumulator: (sum + input, count + 1)
        return sum + input, count + 1

    def merge_accumulators(self, accumulators):
        # Łączy wiele akumulatorów w jeden.
        # Dane wejściowe:
        # - accumulators: lista akumulatorów, np. [(3.0, 2), (7.0, 3)]
        # Rozdziela sumy i liczniki na oddzielne listy: sums = [3.0, 7.0], counts = [2, 3]
        sums, counts = zip(*accumulators)
        # Zwraca scalony akumulator: (sum(sums), sum(counts)), np. (10.0, 5)
        return sum(sums), sum(counts)

    def extract_output(self, accumulator):
        # Oblicza wynik końcowy na podstawie akumulatora.
        # Dane wejściowe:
        # - accumulator: końcowy stan akumulatora, np. (10.0, 5)
        sum, count = accumulator
        # Zwraca średnią: sum / count, jeśli count > 0, w przeciwnym razie NaN
        return sum / count if count else float('NaN')

# Tworzenie potoku Apache Beam
with beam.Pipeline() as p:
    # Dane wejściowe: lista liczb
    numbers = p | beam.Create([1, 2, 3, 4, 5])
    # Obliczenie średniej za pomocą CombineGlobally z niestandardową funkcją AverageFn
    average = numbers | beam.CombineGlobally(AverageFn())
    # Wyświetlenie wyniku
    average | 'Print output' >> beam.Map(print)


print('-'*50)

with beam.Pipeline() as p:
    numbers = p | beam.Create([1, 2, 3, 4, 5])
    # Użycie Mean.Globally() bezpośrednio
    average = numbers | beam.combiners.Mean.Globally()
    average | 'Print output' >> beam.Map(print)