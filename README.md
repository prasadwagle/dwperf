dwperf
======

Benchmark for data warehouse query performance

The event_properties table has 100 billion rows.
event_properties is transformed to fact_events using load_fact_events.
fact_events is joined with dimension tables in the rollup query.
