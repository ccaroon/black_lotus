# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

find_card = ->
    card_name = $('#card_name').val();

    $.ajax(
      url: "/cards.json?search_string="+card_name,
      dataType: "json"
    ).done((data, status, req) ->
      c = data[0];
      insert_card(data[0]);
      $('#card_name').select();
      return false;
    ).fail((req, status, err) ->
        alert(err);
        false;
    );

    false;

insert_card = (card) ->
    deck = $('#main_deck');
    deck.prepend('<li class="span2"><div id="card_'+card.id+'" class="thumbnail" style="display:none"><img src="/card_images/'+card.image_name+'" ></div></li>');
    card = $('#card_'+card.id);
    card.slideDown("slow", "linear");
    false;
