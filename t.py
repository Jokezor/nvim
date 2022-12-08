import heapq
from datetime import timedelta

from django.utils.timezone import now
from stdnum import isbn

isbn.validate("978-9024538270")

print(now() + timedelta(days=3))


heap = []
heapq.heappush([], 2)
print(heap)
