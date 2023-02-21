{% macro get_shared_ride_description(sr_flag) -%}

    case {{ sr_flag }}
        when 0 then 'Non-shared rides,'
        when 1 then 'Shared trips'
    end

{%- endmacro %}