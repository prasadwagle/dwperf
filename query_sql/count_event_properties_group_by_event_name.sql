select event_name, count(1)
from event_properties
group by 1
order by 1;