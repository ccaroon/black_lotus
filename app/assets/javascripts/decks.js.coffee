##############################################################################
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

    return false;
##############################################################################
@card_search = ->

    clear_search_error();
    clear_search_results();

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
            display_search_results(data);

        return false;
    ).fail((req, status, err) ->
        set_search_error("Network error '#{status}' | '#{error}'");
        return false;
    );

    $('#search_string').select();

    return false;

display_search_results = (cards) ->
    sr_list = $('#search_results');

    for card in cards
        html = """
        <li id="sr_card_#{card.id}" data-id="#{card.id}" class="span2 search_result">
            <div id="sr_card_img_#{card.id}" class="thumbnail" style="display:none">
                <img src="/card_images/#{card.image_name}">
                <p>
                <div class="btn-group">
                    <button class="btn btn-small btn-primary" disabled="1">Main</button>
                    <button class="btn btn-small" onClick="add_card('main_deck', #{card.id}, '#{card.image_name}', 1)">+1</button>
                    <button class="btn btn-small" onClick="add_card('main_deck', #{card.id}, '#{card.image_name}', 5)">+5</button>
                    <button class="btn btn-small" onClick="add_card('main_deck', #{card.id}, '#{card.image_name}', 10)">+10</button>
                </div>
                </p>
                <p>
                <div class="btn-group">
                    <button class="btn btn-small btn-inverse" disabled="1">Side</button>
                    <button class="btn btn-small" onClick="add_card('side_deck', #{card.id}, '#{card.image_name}', 1)">+1</button>
                    <button class="btn btn-small" onClick="add_card('side_deck', #{card.id}, '#{card.image_name}', 5)">+5</button>
                    <button class="btn btn-small" onClick="add_card('side_deck', #{card.id}, '#{card.image_name}', 10)">+10</button>
                </div>
                </p>
            </div>
        </li>
        """;
        sr_list.prepend(html);
        $("#sr_card_po_#{card.id}").popover();

        card_img = $("#sr_card_img_#{card.id}");
        card_img.slideDown("slow", "linear");

    return false;

set_search_error = (msg) ->
    $('#search_error').addClass('alert').text(msg);
    return false;

clear_search_results = ->
    $('.search_result').remove();

clear_search_error = ->
    $('#search_error').removeClass('alert').text('');
    return false;

@add_card = (deck_type, id, image_name, count) ->
    deck = $("##{deck_type}");

    html = "
    <li id='card_#{id}' data-id='#{id}' class='span2'>
        <div id='card_img_#{id}' class='thumbnail' style='display:none'>
            <img src='/card_images/#{image_name}'>
        </div>
    </li>";
    deck.prepend(html);
    card_img = $("#card_img_#{id}");
    card_img.slideDown("slow", "linear");

    cards_to_add = $('#cards_to_add');

    # TODO: need to suppply card id, deck (main or side) and count
    html = "
    <input id='add_card_#{id}' 
           type='hidden' 
           name='add_card_#{id}' 
           value='#{id}|#{deck_type}|#{count}'>";
    cards_to_add.append(html);

    return false;

# remove_card = (card_element) ->
#     card_id = card_element.data('id');
#     card_element.remove();

#     $("#add_card_#{card_id}").remove();

#     return false;

##############################################################################
# Code graveyard
##############################################################################

        # $("#card_#{card.id}").click( -> 
        #     remove_card($(this));
        # );
