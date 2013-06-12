@card_search = ->
    clear_search_error();

    search_string = $('#search_string').val();

    if search_string.length <= 3
        set_search_error("Search string too short: '#{search_string}'");
        return false;

    $.ajax(
        url: "/cards.json?search_string="+search_string,
        dataType: "json"
    ).done((data, status, req) ->
        if data.length == 0
            set_search_error("No Cards Found for '#{search_string}'!")
        else
            card_to_insert = null;

            if data.length > 1
                $('#search_string').typeahead({
                    source:  ->
                        card_names = [];
                        card_names.push card.name for card in data;
                        card_names;
                })
                return false;
            else
                card_to_insert = data[0];

            insert_card(card_to_insert);
        return false;
    ).fail((req, status, err) ->
        set_search_error("Network error '#{status}' | '#{error}'");
        return false;
    );

    $('#search_string').select();

    return false;

set_search_error = (msg) ->
    $('#search_error').addClass('alert').text(msg);
    return false;

clear_search_error = ->
    $('#search_error').removeClass('alert').text('');
    return false;

insert_card = (card) ->
    deck = $('#main_deck');
    deck.prepend('<li class="span2"><div id="card_'+card.id+'" class="thumbnail" style="display:none"><img src="/card_images/'+card.image_name+'" ></div></li>');
    card = $('#card_'+card.id);
    card.slideDown("slow", "linear");
    return false;
