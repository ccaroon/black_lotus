$(document).ready ->

    # set up click handler to remove cards already part of the deck
    $('.existing_card').click ->
        card_id = $(this).data('id');
        $(this).remove();
        cards_to_rm = $('#cards_to_remove');
        html = "
         <input id='remove_card_#{card_id}' 
                type='hidden' 
                name='remove_card_#{card_id}' 
                value='#{card_id}'>";
        cards_to_rm.append(html);

@card_search = ->
    clear_search_error();

    search_string = $('#search_string').val();

    if search_string.length < 3
        set_search_error("Search string too short: '#{search_string}'");
        return false;

    $.ajax(
        url: "/cards.json?search_string="+search_string,
        dataType: "json"
    ).done((data, status, req) ->
        if data.length == 0
            set_search_error("No Cards Found for '#{search_string}'!")
        else
            # card_to_insert = null;

            # if data.length > 1
            #     card_names = [];
            #     card_names.push card.name for card in data;
            #     return false;
            # else
            #     card_to_insert = data[0];

            for card in data
                insert_card(card);
                $("#card_#{card.id}").click( -> 
                    remove_card($(this));
                );

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

    html = "
    <li id='card_#{card.id}' data-id='#{card.id}' class='span2'>
        <div id='card_img_#{card.id}' class='thumbnail' style='display:none'>
            <img src='/card_images/#{card.image_name}'>
        </div>
    </li>";
    deck.prepend(html);
    card_img = $("#card_img_#{card.id}");
    card_img.slideDown("slow", "linear");

    cards_to_add = $('#cards_to_add');

    html = "
    <input id='add_card_#{card.id}' 
           type='hidden' 
           name='add_card_#{card.id}' 
           value='#{card.id}'>";
    cards_to_add.append(html);

    return false;

remove_card = (card_element) ->
    card_id = card_element.data('id');
    card_element.remove();

    $("#add_card_#{card_id}").remove();

    return false;
