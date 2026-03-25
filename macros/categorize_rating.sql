{% macro categorize_rating(rating_column) %}
    case
        when {{ rating_column }} >= 4.4 then 'Elite'
        when {{ rating_column }} >= 3.8 then 'Good'
        when {{ rating_column }} > 0 then 'Needs Improvement'
        else 'Unrated'
    end
{% endmacro %}