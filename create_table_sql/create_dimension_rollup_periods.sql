CREATE TABLE public.dimension_rollup_periods
(
    period_id int NOT NULL,
    time_id timestamp NOT NULL,
    id int,
    begin_time timestamp,
    end_time timestamp
);
