# ParDo: Wywołanie funkcji dla każdego elementu w strumieniu, podobne do map(), ale bardziej elastyczne.

import apache_beam as beam

class Square(beam.DoFn):
    def process(self, element):
        return [element**2]

with beam.Pipeline() as p:
    numbers = p | beam.Create([1, 2, 3, 4, 5])
    squared_numbers = numbers | beam.ParDo(Square())
    squared_numbers | 'Print output' >> beam.Map(print)

# 1
# 4
# 9
# 16
# 25