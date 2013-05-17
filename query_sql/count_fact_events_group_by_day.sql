select date_trunc('day', occurred_at), count(1)
from fact_events
group by 1
order by 1;