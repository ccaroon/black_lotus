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
# TODO: new search clears search results
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

# TODO: partial for adding card to deck
# TODO: Add to Main x 1, Add to Main x 5, Add to Main x 10
# TODO: Add to Side x 1, Add to Side x 5, Add to Side x 10
    partial = "Hello, Card -- ZZZZZZZZZ";


    for card in cards
        html = "
        <li id='sr_card_#{card.id}' data-id='#{card.id}' class='span2'>
            <div id='sr_card_img_#{card.id}' class='thumbnail' style='display:none'>
                <a rel='popover' id='sr_card_po_#{card.id}'
                   href='javascript:void(0)'
                   data-placement='top'
                   data-html='true'
                   data-animation='false'
                   data-trigger='click'
                   data-original-title='#{card.name}'
                   data-content='#{partial}'><img src='/card_images/#{card.image_name}'></a>
            </div>
        </li>";
        sr_list.prepend(html);
        $("#sr_card_po_#{card.id}").popover();

        card_img = $("#sr_card_img_#{card.id}");
        card_img.slideDown("slow", "linear");

    return false;

set_search_error = (msg) ->
    $('#search_error').addClass('alert').text(msg);
    return false;

clear_search_error = ->
    $('#search_error').removeClass('alert').text('');
    return false;

# insert_card = (card) ->
#     deck = $('#cards_found');

#     html = "
#     <li id='card_#{card.id}' data-id='#{card.id}' class='span2'>
#         <div id='card_img_#{card.id}' class='thumbnail' style='display:none'>
#             <img src='/card_images/#{card.image_name}'>
#         </div>
#     </li>";
#     deck.prepend(html);
#     card_img = $("#card_img_#{card.id}");
#     card_img.slideDown("slow", "linear");

#     cards_to_add = $('#cards_to_add');

#     html = "
#     <input id='add_card_#{card.id}' 
#            type='hidden' 
#            name='add_card_#{card.id}' 
#            value='#{card.id}'>";
#     cards_to_add.append(html);

#     return false;

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
