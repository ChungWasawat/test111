{% macro get_shared_ride_description(shared_ride_type) -%}

    case {{ shared_ride_type }}
        when shared_ride_type = 0 then 'Non-shared rides'
        when shared_ride_type > 0 then 'Shared trips'
    end

{%- endmacro %}