with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
plenty as (
    select 
        month(datum) as month_number,
        year(datum) as  year_number,
        sum(brutto) as sales
    from 
        blg_hdr_plenty
    group by 
        month(datum),
        year(datum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(plenty.sales, 0) total_sales,
    if( plenty.sales is null,'N/A','ok' ) plenty_message
from 
    calendar
    left join plenty
        on (calendar.year_number,calendar.month_number) = (plenty.year_number,plenty.month_number)
order by calendar.year_number,calendar.month_number




with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
amazonmarket as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_amazonmarket
        where saldenausgleich <> 0 and saldenausgleich is not null
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(amazonmarket.payments, 0) total_payments,
    if( amazonmarket.payments is null,'N/A','ok' ) amazonmarket_message
from 
    calendar
    left join amazonmarket
        on (calendar.year_number,calendar.month_number) = (amazonmarket.year_number,amazonmarket.month_number)
order by calendar.year_number,calendar.month_number



with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
ottoauszahlung as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_ottoauszahlung
        where saldenausgleich <> 0 and saldenausgleich is not null
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(ottoauszahlung.payments, 0) total_payments,
    if( ottoauszahlung.payments is null,'N/A','ok' ) ottoauszahlung_message
from 
    calendar
    left join ottoauszahlung
        on (calendar.year_number,calendar.month_number) = (ottoauszahlung.year_number,ottoauszahlung.month_number)
order by calendar.year_number,calendar.month_number



with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
paypal as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_paypal
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(paypal.payments, 0) total_payments,
    if( paypal.payments is null,'N/A','ok' ) paypal_message
from 
    calendar
    left join paypal
        on (calendar.year_number,calendar.month_number) = (paypal.year_number,paypal.month_number)
order by calendar.year_number,calendar.month_number





with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
ebay as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_ebay
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(ebay.payments, 0) total_payments,
    if( ebay.payments is null,'N/A','ok' ) ebay_message
from 
    calendar
    left join ebay
        on (calendar.year_number,calendar.month_number) = (ebay.year_number,ebay.month_number)
order by calendar.year_number,calendar.month_number



with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
kaufland as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_kaufland
        where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(kaufland.payments, 0) total_payments,
    if( kaufland.payments is null,'N/A','ok' ) kaufland_message
from 
    calendar
    left join kaufland
        on (calendar.year_number,calendar.month_number) = (kaufland.year_number,kaufland.month_number)
order by calendar.year_number,calendar.month_number




with months as (
    select 
        seq month_number
    from 
    seq_1_to_12 as months
),
years as (
    select 
        year(now())-  5 + seq year_number
    from 
    seq_1_to_10 as years
),
calendar as (
    select 
        months.month_number,
        years.year_number
    from months join years on 1=1 and years.year_number <= year(now())
),
amazon_pay as (
    select 
        month(vdatum) as month_number,
        year(vdatum) as  year_number,
        sum(brutto) as payments
    from 
        blg_pos_amazon_pay
    where saldenausgleich <> 0 and saldenausgleich is not null 
    group by 
        month(vdatum),
        year(vdatum)
)
select 
    calendar.year_number,
    calendar.month_number,
    ifnull(amazon_pay.payments, 0) total_payments,
    if( amazon_pay.payments is null,'N/A','ok' ) amazon_pay_message
from 
    calendar
    left join amazon_pay
        on (calendar.year_number,calendar.month_number) = (amazon_pay.year_number,amazon_pay.month_number)
order by calendar.year_number,calendar.month_number