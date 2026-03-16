
-- OBJECTIVE: CLEANING DATA

with source as (
    select * from DB1.PUBLIC.TABLE1
),

cleaned as (
    select
        -- identifiers
        company_name,
        -- domain,

        -- company size
        employee_ct::integer as employee_count,

        -- for now, convert size into some ordinal rank, encode later for ML part
        case size
            when '201-500 employees'     then 1
            when '501-1,000 employees'   then 2
            when '1,001-5,000 employees' then 3
            when '5,001-10,000 employees' then 4
            when '10,001+ employees'     then 5
        end as size_rank,

        -- industry
        industry,

        -- normalize funding to dollars
        -- values under 1000 are in millions (CB Insights data)
        -- values over 1000 are already in raw dollars (Crunchbase, Dealroom data)
        case
            when latest_funding < 1000
                then latest_funding * 1000000
            else
                latest_funding
        end as latest_funding_usd,

        -- job openings (fill null with 0)
        coalesce(openings, 0)::integer as job_openings,

        -- we convert tech stack into binary flags (GTM-relevant tools only)
        case when site_stack ilike '%salesforce%'  then 1 else 0 end as has_salesforce,
        case when site_stack ilike '%hubspot%'     then 1 else 0 end as has_hubspot,
        case when site_stack ilike '%marketo%'     then 1 else 0 end as has_marketo,
        case when site_stack ilike '%pardot%'      then 1 else 0 end as has_pardot,
        case when site_stack ilike '%outreach%'    then 1 else 0 end as has_outreach,
        case when site_stack ilike '%segment%'     then 1 else 0 end as has_segment,
        case when site_stack ilike '%demandbase%'  then 1 else 0 end as has_demandbase,
        case when site_stack ilike '%drift%'       then 1 else 0 end as has_drift,
        case when site_stack ilike '%apollo%'      then 1 else 0 end as has_apollo,
        case when site_stack ilike '%zoominfo%'    then 1 else 0 end as has_zoominfo,
        case when site_stack ilike '%clearbit%'    then 1 else 0 end as has_clearbit,
        case when site_stack ilike '%intercom%'    then 1 else 0 end as has_intercom

    from source
    where company_name is not null
)

select * from cleaned

