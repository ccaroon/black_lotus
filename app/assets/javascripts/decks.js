BlackLotus.Deckbuilder = {};
BlackLotus.DeckView    = {};

(function () {
"use strict";

BlackLotus.DeckView = {

    opacity: 0.2,

    highlightEdition: function (name) {
        // $("[data-type=card]").fadeTo("slow", 1.0);
        // $('[data-type=card]:not([data-edition="'+name+'"])').fadeTo("normal", this.opacity);
        $("[data-type=card]").show();
        $('[data-type=card]:not([data-edition="'+name+'"])').hide();
    },

    highlightMainType: function (name) {
        // $("[data-type=card]").fadeTo("slow", 1.0);
        // $("[data-type=card]:not([data-main-type='"+name+"'])").fadeTo("normal", this.opacity);
        $("[data-type=card]").show();
        $("[data-type=card]:not([data-main-type='"+name+"'])").hide();
    },

    highlightColor: function (name) {
        var colorMap = {
            red:       'R',
            green:     'G',
            blue:      'U',
            black:     'B',
            white:     'W',
            colorless: '0'
        };

        // $("[data-type=card]").fadeTo("slow", 1.0);
        // $("[data-type=card]:not([data-color*='"+colorMap[name]+"'])").fadeTo("normal", this.opacity);
        $("[data-type=card]").show();
        $("[data-type=card]:not([data-color*='"+colorMap[name]+"'])").hide();
    }
},

BlackLotus.Deckbuilder = {

    init: function () {
        var that = this;
            
        this.page = 1;

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

    card_search: function (new_search) {
        var that          = this,
            card_name     = $('#card_name').val(),
            card_mtype    = $('#card_main_type').val(),
            card_stype    = $('#card_sub_type').val(),
            card_color    = $('#card_color').val(),
            card_rarity   = $('#card_rarity').val(),
            page          = this.page;

        if (new_search) {
            page      = 1;
            this.page = page;
        }

        this.clear_search_error();
        this.clear_search_results();

        if (card_name.length   < 3 && 
            card_color.length  < 1 && 
            card_mtype.length  < 1 &&
            card_stype.length  < 1 &&
            card_rarity.length < 1) {
            this.set_search_error("Search too broad. Narrow it down.");
        }
        else {
            $.ajax({
                url: "/cards.json?per=8;page="+page+";card[name]="+card_name+";card[color]="+card_color+";card[main_type]="+card_mtype+";card[sub_type]="+card_stype+";card[rarity]="+card_rarity,
                dataType: "json"
            }).done(function (data) {
                if (data.length === 0) {
                    that.set_search_error("No Cards Found for '"+card_name+"'!");
                }
                else {
                    that.display_search_results(data);
                }
            }).fail(function (req, status, err) {
                that.set_search_error("Network error '"+status+"' | '"+err+"'");
            });        
        }

        $('#card_name').select();
    },

    card_search_next: function () {
        this.page = this.page + 1;
        this.card_search();
    },

    card_search_prev: function () {
        if (this.page > 1) {
            this.page = this.page - 1;
        }

        this.card_search();
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

            sr_list.append(html);
            $("#sr_card_po_"+card.id).popover();

            card_img = $("#sr_card_img_"+card.id);
            card_img.slideDown("slow", "linear");
        }
    },

    add_card: function (deck_type, id, image_path, count) {
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
                        <img src='<%= image_path %>'>                                              \
                        <div class='caption text-center'>                                          \
                            x <strong><span id='card_<%= id %>_count'><%= count %></span></strong> \
                        </div>                                                                     \
                    </div>                                                                         \
                </div>"
            );
            deck.prepend(template.render({ id: id, image_path: image_path, count: count}));

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
