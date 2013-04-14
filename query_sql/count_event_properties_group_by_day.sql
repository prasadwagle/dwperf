select date_trunc('day', occurred_at), count(1)
from event_properties
group by 1
order by 1;