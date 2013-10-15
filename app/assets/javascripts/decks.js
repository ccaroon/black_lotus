BlackLotus.Deckbuilder = {};

(function () {
"use strict";

BlackLotus.Deckbuilder = {

    init: function () {
        var that = this;
        $(document).ready(function () {
            // set up click handler to remove cards already part of the deck
            $('.existing_card').click(function () {
                var card_id     = $(this).data('id'),
                    cards_to_rm = $('#cards_to_remove'),
                    template    = that.template_from_string(
                        "<input id='remove_card_<%= card_id %>'   \
                                type='hidden'                     \
                                name='remove_card_<%= card_id %>' \
                                value='<%= card_id %>'>"
                    );

                $(this).remove();

                cards_to_rm.append(template.render({ card_id: card_id }));
            });
        });
    },

    card_search: function () {
        var that          = this,
            search_string = $('#search_string').val();

        this.clear_search_error();
        this.clear_search_results();

        if (search_string.length < 3) {
            this.set_search_error("Search string too short: '"+search_string+"'");
        }
        else {
            $.ajax({
                url: "/cards.json?card[name]="+search_string,
                dataType: "json"
            }).done(function (data) {
                if (data.length === 0) {
                    that.set_search_error("No Cards Found for '"+search_string+"'!");
                }
                else {
                    that.display_search_results(data);
                }
            }).fail(function (req, status, err) {
                that.set_search_error("Network error '"+status+"' | '"+err+"'");
            });        
        }

        $('#search_string').select();
    },

    set_search_error: function (msg) {
        $('#search_results').addClass('alert alert-warning').text(msg);
    },

    clear_search_results: function () {
        $('.search_result').remove();
    },

    clear_search_error: function () {
        $('#search_results').removeClass('alert alert-warning').text('');
    },

    display_search_results: function (cards) {
        var i        = 0,
            html     = null,
            card     = null,
            card_img = null,
            template = null,
            sr_list  = $('#search_results');

        for (i = 0; i < cards.length; i+=1) {
            card = cards[i];

            template = new EJS({url: '/templates/deck/builder/card.ejs'});
            html = template.render({
                card: card
            });

            sr_list.prepend(html);
            $("#sr_card_po_"+card.id).popover();

            card_img = $("#sr_card_img_"+card.id);
            card_img.slideDown("slow", "linear");
        }
    },

    add_card: function (deck_type, id, image_name, count) {
        var deck          = $("#"+deck_type),
            card_x        = "add_card_"+deck_type+"_"+id,
            added_card    = $("#"+card_x),
            curr_value    = null,
            old_count     = null,
            count_element = null,
            parts         = null,
            new_count     = null,
            card_img      = null,
            cards_to_add  = null,
            template      = null;

        if (added_card.length) {
            curr_value = added_card.val();
            parts      = curr_value.split('|');
            old_count  = parts[2];
            new_count  = Number(old_count) + Number(count);

            count_element = $("#card_"+id+"_count");
            count_element.html(new_count);

            added_card.val(id + "|" + deck_type + "|" + new_count);

            card_img = $("#card_img_" + id);
            card_img.fadeOut("fast");
            card_img.fadeIn("fast");            
        }
        else {
            template = this.template_from_string(
                "<div id='card_<%= id %>' data-id='<%= id %>' class='col-md-3'>                    \
                    <div id='card_img_<%= id %>' class='thumbnail' style='display:none'>           \
                        <img src='/card_images/<%= image_name %>'>                                 \
                        <div class='caption text-center'>                                          \
                            x <strong><span id='card_<%= id %>_count'><%= count %></span></strong> \
                        </div>                                                                     \
                    </div>                                                                         \
                </div>"
            );
            deck.prepend(template.render({ id: id, image_name: image_name, count: count}));

            card_img = $("#card_img_" + id);
            card_img.slideDown("slow", "linear");

            cards_to_add = $('#cards_to_add');
            template = this.template_from_string(
                "<input id='<%= card_x %>' type='hidden' name='<%= card_x %>' \
                        value='<%= id %>|<%= deck_type %>|<%= count %>'>"
            );
            cards_to_add.append(template.render({
                card_x    : card_x,
                id        : id,
                deck_type : deck_type,
                count     : count
            }));
        }
    },

    template_from_string: function (tmpl_str) {
        var template = new EJS({
            text: tmpl_str
        });

        return (template);
    }

};

}());
