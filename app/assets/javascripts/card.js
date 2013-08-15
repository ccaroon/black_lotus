BlackLotus.Card = {

    init: function () {
        $('#card_count_dec').click(function () {
            count = $('#card_count').val();
            count = Number(count) - 1;
            $('#card_count').val(count);        
        });

        $('#card_count_inc').click(function () {
            count = $('#card_count').val();
            count = Number(count) + 1;
            $('#card_count').val(count);        
        });        
    }

};

BlackLotus.Card.init();    
