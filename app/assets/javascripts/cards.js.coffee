
$(document).ready ->

    $('#card_count_dec').click ->
        count = $('#card_count').val();
        count = Number(count) - 1;
        $('#card_count').val(count);

    $('#card_count_inc').click ->
        count = $('#card_count').val();
        count = Number(count) + 1;
        $('#card_count').val(count);
